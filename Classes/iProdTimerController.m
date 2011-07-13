//
//	iProdTimerController.m
//	iProd
//
//	Created by Justin Proffitt on 11/5/10.
//	Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "iProdTimerController.h"
#import "iProd2AppDelegate.h"
#import "iProdSettingsController.h"
#import "MainMenu.h"

@implementation iProdTimerController
@synthesize totalTimerLabel, timerLabel, results, managedObjectContext, totalDurationTimer, experimentName, printResults, saveResults, resultsTable, displayIntervals, displayResults;


///////////////////////////////////////////////////////////////////////////////////////////
    //This function prepares the views state when it is being opened for the first time.
- (void)viewDidLoad {
	[super viewDidLoad];
	timerIsRunning = FALSE;
	nextTrialFlag = FALSE;
	intervals = [[NSMutableArray alloc] init];
    self.navigationItem.prompt = @"Tap the screen anywhere to start experiment.";
    homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style: UIBarButtonItemStyleBordered target:self action:@selector(goToMainMenu)];
    nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next Trial" style: UIBarButtonItemStyleBordered target:self action:@selector(nextTrial)];
    stopTrial = [[UIBarButtonItem alloc] initWithTitle:@"End Trial" style: UIBarButtonItemStyleBordered target:self action:@selector(endTrial)];
    if(!displayIntervals){
        displayIntervals = [[NSMutableArray alloc] init];
    }
    resultsTable.hidden = YES;
    resultsTable.userInteractionEnabled = NO;
	if(showInterval){
        [timerLabel setText:@"00:00.00"];}
    else{
        [timerLabel setText:@""];}
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




//////////////////////////////////////////////////////////////////////////////////////////
    //This function resets the state of the timer so that the next trial may be ran.
-(void) resetState{
    resultsTable.hidden = YES;
    resultsTable.userInteractionEnabled = NO;
    timerLabel.hidden = NO;
	timerIsRunning = FALSE;
	finishedTest = FALSE;
    self.navigationItem.prompt = @"Tap the screen anywhere to start experiment.";
    self.navigationItem.rightBarButtonItem = nil;
	[intervals removeAllObjects];
	[results setText:nil];
	if(showInterval){
        [timerLabel setText:@"00:00.00"];}
    else{
        [timerLabel setText:@""];}
	if(nextTrialFlag)trialNum += 1;
	
	nextTrialFlag = FALSE;
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
    //This function is called when the next trial option is selected after a trial has been ran
-(void) nextTrial{
	nextTrialFlag = TRUE;
	[self resetState];
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
    //This function pops the stack of views back to the main menu view.
-(IBAction) goToMainMenu{
	[self resetState];
	[self.navigationController popToRootViewControllerAnimated:TRUE];
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
    //If the view is going to disappear (go to background) this function ends the current trial
- (void)viewWillDisappear:(BOOL)animated{
    [self endTrial];
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning {
    //Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




//////////////////////////////////////////////////////////////////////////////////////////
    //This method begins the timer if it is not already running
- (void)startTimer {
	if(!timerIsRunning){
        [displayIntervals removeAllObjects];
        [self.navigationItem setHidesBackButton:YES animated:YES];
        [self.navigationItem setLeftBarButtonItem:homeButton animated:YES];
        [self.navigationItem setRightBarButtonItem:stopTrial animated:YES];
        
        upperTime = [[NSDate date] retain];
        // This will starts a timer that updates every .01 seconds
        [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
        if(useBoundTimer){
            //this block sets at timer to go off after the duration of seconds specified in the previous view has elapsed.
            totalDurationTimer = [NSTimer scheduledTimerWithTimeInterval:totalDuration target:self selector:@selector(endTrial) userInfo:nil repeats:NO];
        }
        if(showTotalTimer){
            [totalTimerLabel setHidden:NO];
        }
        timerIsRunning = true;
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        self.navigationItem.prompt = @"Trial running. Tap for interval.";
	}
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




//////////////////////////////////////////////////////////////////////////////////////////
    //This function is called every .01 seconds after the experiment has been started.
- (void)timerFireMethod:(NSTimer*)theTimer {
	if(timerIsRunning){
		double interval = -[start timeIntervalSinceNow];
        if(showInterval) {
            //update label if specified to.
            [timerLabel setText:[NSString stringWithFormat:@"%02d:%02d.%02d", (int)interval/60, (int)interval%60, (int)(interval*100)%100]];
        }
        if(showTotalTimer){
            //this updates the total timer if showTotalTimer is set to true.
            double totalInterval = -[upperTime timeIntervalSinceNow];
            [totalTimerLabel setText:[NSString stringWithFormat:@"Total:%02d:%02d.%02d", (int)totalInterval/60, (int)totalInterval%60, (int)(totalInterval*100)%100]];
        }
        //if(interval > 0.125) 
          //[[self view] setBackgroundColor: [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1]];
	}
	else {
        //this stops the timer and empties the timer label.
		[theTimer invalidate];
		[timerLabel setText: nil];
		[[UIApplication sharedApplication] setIdleTimerDisabled:NO];
	}
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




//////////////////////////////////////////////////////////////////////////////////////////
    //This method updates the start variable with the current time, adds it to the intervals array and starts the timer if it is not allready running.
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[[self view] setBackgroundColor:[UIColor lightGrayColor]];
	start = [[NSDate date] retain];
	[intervals addObject:start];
	if (!timerIsRunning && !finishedTest){
        [self startTimer];
    }
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
    //This function is called after a touch has ended, did not use in the current implementation except for writing to stdout.
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] setBackgroundColor: [UIColor whiteColor]];
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
    //This function is called when the home button is pressed or when the stop trial button has been pressed.
- (void) endTrial {
    
	if(timerIsRunning) {
        if([totalDurationTimer isValid]){
            NSLog(@"invalidated");
            [totalDurationTimer invalidate];
        }
        
        [totalTimerLabel setHidden:TRUE];
		finishedTest = true;
		timerIsRunning = false;
		self.navigationItem.prompt = @"Trial complete. Tap to export.";
		[results setHidden:FALSE];
        
        if([intervals count] > 1){
            //Prepare the variables needed to calculate the trials data.
            double total = 0, mean = 0, error = 0, std = 0;
            int i;
            NSDate *last, *next;
        
            //These for loops iterates through the intervals that were recorded preparing the data needed for calculations.
            for(i=1, last=nil; i<[intervals count]; i++, last = next){
                if (last == nil) last = [intervals objectAtIndex: 0];
                next = (NSDate*)[intervals objectAtIndex:i];
                NSLog(@"%dth interval: %f", i, [next timeIntervalSinceDate:last]);
                [displayIntervals addObject:[NSString stringWithFormat:@"%f", [next timeIntervalSinceDate:last]]];
                double current = [next timeIntervalSinceDate: last];
			
                total += current;
                error += fabs(current - testInterval);
            }
            
            mean = total / ([intervals count] -1);
            error /= [intervals count] - 1;
            for( i=1, last=nil; i<[intervals count]; i++, last = next){
                if (last == nil) last = [intervals objectAtIndex: 0];
                next = (NSDate*)[intervals objectAtIndex:i];
                double current = [next timeIntervalSinceDate: last];
                std += (current - mean)*(current - mean);
            }
            std = sqrt(1./([intervals count]-1) * std);
            NSLog(@"%f", std);
        
            //These blocks prepare the data for presentation through the view.
            //printResults is used to print the data to stdout.
            printResults = [[NSString alloc] initWithFormat:@"%@\nTotal Time:\t\t\t%0.2lf\nIntervals:\t\t\t\t%u\nMean:\t\t\t\t%0.2lf\nError:\t\t%0.2lf\nStandard Deviation:\t\t\t%0.2lf\nCoefficient of Variance:\t%0.2lf\n", experimentName,total, [intervals count]-1, mean, error, std, std/(total/([intervals count]-1))];
            displayResults = [[NSMutableDictionary alloc] init];
            [displayResults setValue:[NSString stringWithFormat:@"%0.2lf", total] forKey:@"Total Time"];
            [displayResults setValue:[NSString stringWithFormat:@"%u", [intervals count]-1] forKey:@"Intervals"];
            [displayResults setValue:[NSString stringWithFormat:@"%0.2lf", mean] forKey:@"Mean"];
            [displayResults setValue:[NSString stringWithFormat:@"%0.2lf", error] forKey:@"Error"];
            [displayResults setValue:[NSString stringWithFormat:@"%0.2lf", std] forKey:@"Standard Deviation"];
            [displayResults setValue:[NSString stringWithFormat:@"%0.2lf", std/(total/([intervals count]-1))] forKey:@"Coefficient of Variance"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSLog(@"subNum: %u", subNum);
            NSLog(@"trialNum: %u",trialNum);
            NSLog(@"addInfo: %@",addInfo);
            NSLog(@"dateString: %@", dateString);
            NSLog(@"(%@)\n", printResults);
        
        
            //saveResults is the actual string that will be saved in Core Data.
            saveResults = [[NSString alloc] initWithFormat:@"%u,%u,%0.2lf,%u,%0.2lf,%0.2lf,%0.2lf,%0.2lf,%@,%@\n", subNum, trialNum, total, [intervals count]-1, mean, error, std, std/(total/([intervals count]-1)), dateString,addInfo];
        
        
            //Print to standard out what we just saved.
            NSLog(@"(%@)\n", saveResults);
            //Change the results label.
            [results setText: printResults];
            [self saveTrial:saveResults];
            //[self printDatabase]; //this call was for early debugging.
            //finally, reconfigure our buttons.
            self.navigationItem.rightBarButtonItem = nextButton;
            [resultsTable reloadData];
            resultsTable.hidden = NO;
            resultsTable.userInteractionEnabled = YES;
            //[formatter release];
        }
        
        
        else {
            //If there weren't any intervals, we can't run the methods for calculations.
            UIAlertView *sad = [[UIAlertView alloc] initWithTitle:@"No Intervals" message:@"Please record multiple intervals so the app is able to provide statistical data."  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [sad show];
            [sad release];
            [self resetState];
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
    //These functions handle the action menu for the user to either email or copy the results
- (void) showActionMenu: (NSIndexPath *)fr {
    [self becomeFirstResponder];
    UIMenuItem* copyresults = [[[UIMenuItem alloc] initWithTitle: @"Copy Results" action:@selector(copyResults)] autorelease];
    UIMenuItem* mailresults = [[[UIMenuItem alloc] initWithTitle: @"Email Results" action:@selector(emailResults)] autorelease];
    
    UIMenuController* mc = [UIMenuController sharedMenuController];
    mc.menuItems = [NSArray arrayWithObjects: copyresults, mailresults, nil];
    UITableViewCell *tmpcell = [resultsTable cellForRowAtIndexPath:fr];
    [mc setTargetRect: CGRectMake(tmpcell.frame.origin.x, tmpcell.frame.origin.y - resultsTable.contentOffset.y, tmpcell.frame.size.width, tmpcell.frame.size.height) inView: self.view];
    [mc setMenuVisible: YES animated: YES];
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
- (void)emailResults{
    //This code was borrowed from ExpSelVeiwController, just swapping out the variables
    NSLog(@"onCustom1 // Email");
    if(![MFMailComposeViewController canSendMail]) {
		NSLog(@"can't send mail");
		return;
	}
    
    else {
        NSLog(@"can send mail");
        //Prepare the time stamp for the CSV filename and email subject.
        NSLog(@"creating date formatter");
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
	
        //Allocate a modal mail compose view controller.
        NSLog(@"creating mail compose controller");
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
    
        //Generate the string that will be the subject of the email, then append .csv to it for the filename.
        NSLog(@"creating subject and csvFileName");
        NSString *subject = [NSString stringWithFormat:@"%@ - %@",experimentName, dateString];
        NSString *csvFileName = [NSString stringWithFormat:@"%@.csv", subject];
    
        //Extract the contents of the data attribute as a string.
        NSLog(@"creating message");
        NSString *message = [NSString stringWithFormat:@"%@", saveResults];
    
        //Generate a block of data to be used as the attachment.
        NSLog(@"creating fileData");
        NSData *fileData = [message dataUsingEncoding:NSASCIIStringEncoding];
    
        //Set the subject of the email, add the attachment, and finally present the email view.
        NSLog(@"setting variables to mail composer");
        [controller setSubject:subject];
        [controller addAttachmentData:fileData mimeType:@"text/csv" fileName:csvFileName];
        [self presentModalViewController:controller animated:YES];
    
        NSLog(@"releasing");
        [formatter release];
        [controller release];
    }
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
    //This function is called when the user selects an action from the modal view that should cause the view to be dismissed.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self becomeFirstResponder];
    [self dismissModalViewControllerAnimated:YES];
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
    //Simple method to copy the results for the user
- (void)copyResults{
    [[UIPasteboard generalPasteboard] setString:printResults];
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
    //This function saves the passed in string containing the data of the experiment to CoreData. The experiment name is the key used to store the string inside the database.
- (void) saveTrial: (NSString*) data {
	NSError *error;
	//The predicate is what core data is queried with. In this case we are looking under the expName attribute for any entries that match the experiment name entered in the previous view.
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(expName matches %@)", experimentName];
    //The entity is the model in core data that we are looking inside. We pass it the managed object context that was created inside the app delegate.
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Experiment" inManagedObjectContext:managedObjectContext];
    //We create an NSFetchRequest, set its entity and predicate and finally store the the results inside an NSArray.
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	[request setPredicate:predicate];
	NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:request
                                                                error:&error];
    //If we did not get any results from our fetch, we make a new entry
	if([fetchedObjects count] < 1){
		//This is the header for the csv file and what every data string should begin with inside the experiment entry. The data is concatenated to the end of the header since this will be the first entry.
		NSString *header = [NSString stringWithFormat:@"subNum,trialNum,total,interval count,mean,error,std dev,coeff of variance,Date & Time, Add. Info,\n%@", data];
    //Create a managed object to hold the new information under the current experiments name.
        NSLog(@"Creating NSManagedObject");
		NSManagedObject *experimentObj = [NSEntityDescription insertNewObjectForEntityForName:@"Experiment" inManagedObjectContext:managedObjectContext];
		[experimentObj setValue:experimentName forKey:@"expName"];
		[experimentObj setValue:header forKey:@"dataString"];
	}
	else{
    //If an entry exist for the given experiment name we simply use a for each loop to concatenate the data onto the end of the dataString attribute.
		for(NSManagedObject *info in fetchedObjects){
			NSString *temp = [info valueForKey:@"dataString"];
			NSString *newData = [NSString stringWithFormat:@"%@%@", temp, data];
			[info setValue:newData forKey:@"dataString"];
		}
	}
  
    //Finally, we save our changes to the managed object context.
	if([managedObjectContext save:&error]){
	
	}
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
    //This function iterates through all experiment entries in the Experiment entity and prints them to the console. This was used for early debugging/figuring out what was going on.
- (void) printDatabase {
	NSError *error;
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Experiment" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity: entity];
	NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
	if([fetchedObjects count] == 0) NSLog(@"empty");
	for(NSManagedObject *info in fetchedObjects) {
		NSLog(@"Experiment: %@", [info valueForKey:@"expName"]);
		NSLog(@"Data: %@", [info valueForKey:@"dataString"]);
	}
	[fetchRequest release];
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




//////////////////////////////////////////////////////////////////////////////////////////
    //These functions are setters that allow the settings view controller to pass the experiment parameters forward.
-(void) setUseBoundTimer :(bool) val{
  useBoundTimer = val;
}
-(void) setShowInterval :(bool) val{
  showInterval = val;
}
-(void) setShowTotalTimer :(bool) val{
  showTotalTimer = val;
}
-(void) setTrialNum :(int) val{
  trialNum = val; 
}
-(void) setTotalDuration: (double)val{
  totalDuration = val;
}
-(void) setSubjectNumber:(int) val{
    subNum = val;
}
-(void) setAddInfo:(NSString*)val{
  if(val != nil)
    addInfo = [val retain];
  else
    addInfo = @"No Additional Information";
}
-(void) setInterval: (int)val{
  testInterval = val;
}
-(void) setExperimentName: (NSString*)val{
  if(val != nil)
    experimentName = [val retain];
    self.title = experimentName;
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
    //This function returns the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
    //This function will return the number of rows in a section, in our case it is the number of result items or the number of intervals.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(section == 0)
		return [displayResults count];
	if(section == 1)
		return [displayIntervals count];
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
    //This function populates each cell inside the table view. It is called when the table view is first loaded and also when scrolling occurs (table views recycle cells to save memory)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.resultsTable dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
	switch (indexPath.section) {
		case 0:
            //The first section shows all the statistics which are stored in a dictionary 
			switch (indexPath.row) {
				case 0:
					[cell.textLabel setText:@"Total Time"];
                    [cell.detailTextLabel setText:[displayResults objectForKey:@"Total Time"]];
					break;
                case 1:
					[cell.textLabel setText:@"Intervals"];
                    [cell.detailTextLabel setText:[displayResults objectForKey:@"Intervals"]];
					break;
                case 2:
					[cell.textLabel setText:@"Mean"];
                    [cell.detailTextLabel setText:[displayResults objectForKey:@"Mean"]];
					break;
                case 3:
					[cell.textLabel setText:@"Error"];
                    [cell.detailTextLabel setText:[displayResults objectForKey:@"Error"]];
					break;
                case 4:
					[cell.textLabel setText:@"Standard Deviation"];
                    [cell.detailTextLabel setText:[displayResults objectForKey:@"Standard Deviation"]];
					break;
                case 5:
					[cell.textLabel setText:@"Coefficient of Variance"];
                    [cell.detailTextLabel setText:[displayResults objectForKey:@"Coefficient of Variance"]];
					break;
				default:
					break;
			}
			break;
		case 1:
            //The second section shows the actual times for all of the intervals, whose times are stored in an array
			cell.textLabel.textAlignment = UITextAlignmentLeft;
			[cell.textLabel setText:[NSString stringWithFormat:@"Interval %i", indexPath.row + 1]];
            [cell.detailTextLabel setText:[displayIntervals objectAtIndex:indexPath.row]];
			break;
		default:
			break;
	}
    return cell;
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
    //This function returns the title for the section that it is called on.
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0)
		return [NSString stringWithFormat: @"Trial #%u", trialNum];
	else if(section == 1)
		return @"Intervals";
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
    //This function is called when a user selects an experiment they wish to email out data from.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        [self showActionMenu:indexPath];
    }
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




//////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)canBecomeFirstResponder {
	return TRUE;
}

- (void) viewWillAppear:(BOOL)animated {
    [self.view becomeFirstResponder];
    [super viewWillAppear:animated];
}

- (void)dealloc {
	[super dealloc];
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

@end
