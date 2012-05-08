//
//	iProdTimerController.m
//	iProd
//
//	Created by Justin Proffitt on 11/5/10.
//	Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "iProdTimerController.h"
#import "iProd2AppDelegate.h"
#import "iProdSettingsController.h"
#import "MainMenu.h"

@implementation iProdTimerController

@synthesize totalTimerLabel, timerLabel, desc, results, nextButton, goToMain, managedObjectContext, stopTrial, totalDurationTimer, bgImage;

/*
 // The designated initializer.	Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
		if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
				// Custom initialization
		}
		return self;
}
*/

///////////////////////////////////////////////////////////////////////////////////////////
//This function prepares the views state when it is being opened for the first time.
//The bgImage UIImageView from the xib is resized to fill the view.
- (void)viewDidLoad {
  [bgImage sizeToFit];
  [self.view sendSubviewToBack:bgImage];
	[super viewDidLoad];
	[nextButton setHidden:TRUE];
	[stopTrial setHidden:TRUE];
	timerIsRunning = FALSE;
	nextTrialFlag = FALSE;
	intervals = [[NSMutableArray alloc] init];
	if(showInterval){
        [timerLabel setText:@"00:00.00"];
    }
    else{
        [timerLabel setText:@""];
    }
}

//////////////////////////////////////////////////////////////////////////////////////////
//This function resets the state of the timer so that the next trial may be ran.
-(IBAction) resetState{
	timerIsRunning = FALSE;
	finishedTest = FALSE;
	[desc setText:@"Tap anywhere on the screen to start the experiment."];
	[nextButton setHidden:TRUE];
	[intervals removeAllObjects];
	[results setText:nil];
	
	if(nextTrialFlag)trialNum += 1;
	
	nextTrialFlag = FALSE;
}
///////////////////////////////////////////////////////////////////////////////////////////
//This function is called when the next trial option is selected after a trial has been ran
-(IBAction) nextTrial{
	nextTrialFlag = TRUE;
	[self resetState];
}
///////////////////////////////////////////////////////////////////////////////////////////
//This function pops the stack of views back to the main menu view.
-(IBAction) goToMainMenu{
	NSLog(@"hit button Main Menu");
	[self resetState];
	[self.navigationController popToRootViewControllerAnimated:TRUE];
}
///////////////////////////////////////////////////////////////////////////////////////////
//If the view is going to disappear (go to background) this function ends the current trial
- (void)viewWillDisappear:(BOOL)animated{
    [self endTrial];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
		// Return YES for supported orientations
		return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
- (void)didReceiveMemoryWarning {
		// Releases the view if it doesn't have a superview.
		[super didReceiveMemoryWarning];
		
		// Release any cached data, images, etc that aren't in use.
	[start release];
}

- (void)viewDidUnload {
		[super viewDidUnload];
		// Release any retained subviews of the main view.
		// e.g. self.myOutlet = nil;
}
//////////////////////////////////////////////////////////////////////////////////////////
//This method begins the timer if it is not already running
- (void)startTimer {
	if(!timerIsRunning){
    upperTime = [[NSDate date] retain];
    // This will starts a timer that updates every .01 seconds
		[NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    if(useBoundTimer){
      //this block sets at timer to go off after the duration of seconds specified in the 
      //previous view has elapsed.
      totalDurationTimer = [NSTimer scheduledTimerWithTimeInterval:totalDuration target:self selector:@selector(endTrial) userInfo:nil repeats:NO];
    }
    if(showTotalTimer){
      [totalTimerLabel setHidden:NO];
    }
    timerIsRunning = true;
	[self hideButton:nil];
	[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
	[[UIApplication sharedApplication] setStatusBarHidden:YES];
	}
}
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
        if( interval > 0.125 ) 
          [[self view] setBackgroundColor: [UIColor colorWithRed:204/255.0 
                                                           green:204/255.0
                                                            blue:204/255.0 
                                                           alpha:1]];
	}
	else {
    //this stops the timer and empties the timer label.
		[theTimer invalidate];
		[timerLabel setText: nil];
		[[UIApplication sharedApplication] setIdleTimerDisabled:NO];
		[[UIApplication sharedApplication] setStatusBarHidden:NO];
	}

}
//////////////////////////////////////////////////////////////////////////////////////////
//This method updates the start variable with the current time, adds it to the intervals
//array and starts the timer if it is not allready running.
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [bgImage setHidden:YES];
	[[self view] setBackgroundColor:[UIColor colorWithRed:102/255.0
                                                  green:201/255.0
                                                   blue:51/255.0
                                                  alpha:1]];
	start = [[NSDate date] retain];
	[intervals addObject:start];
	if( !timerIsRunning && !finishedTest) [self startTimer];
}
///////////////////////////////////////////////////////////////////////////////////////////
//This function is called after a touch has ended, did not use in the current
//implementation except for writing to stdout.
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [bgImage setHidden:NO];
  //	[[self view] setBackgroundColor: [UIColor colorWithRed:0.5 green:0 blue:0 alpha:1]];
	NSLog(@"touchesEnded\n");
}
///////////////////////////////////////////////////////////////////////////////////////////
//This function hides the buttons on the view and changes the description text to indicate
// that the trial is running.
- (void)hideButton:(NSTimer*)theTimer {
	if(timerIsRunning) {
		[nextButton setHidden:TRUE];
		[goToMain setHidden:TRUE];
		[desc setText: @"Trial running.\nPress the Home button\nor shake to exit."];
		[[UIApplication sharedApplication] setStatusBarHidden:YES];
	}
}
///////////////////////////////////////////////////////////////////////////////////////////
//This function is called after a 'shake' gesture and displayes the stop trial button for
//a duration of 3 seconds.
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	[stopTrial setHidden:FALSE];
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
	[desc setText: @"Click the button to end trial."];
	[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(hideButton:) userInfo:nil repeats:NO];
}
///////////////////////////////////////////////////////////////////////////////////////////
//This function is called when the home button is pressed or when the stop trial button has
//been pressed.
- (void) endTrial {
	NSLog(@"endTrial\n");
    // Vibrate on trial end
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    //Store the true intervals in the csvIntervals string
    NSMutableString *csvIntervals = [[NSMutableString alloc] init];
  //Make sure a trial is running
	if(timerIsRunning) {
        [totalTimerLabel setHidden:TRUE];
        if([totalDurationTimer isValid])
        {
            NSLog(@"invalidated");
            [totalDurationTimer invalidate];
        }
    //Properly set our state bools.
		finishedTest = true;
		timerIsRunning = false;
    //Empty out the description label and unhide the results label.
		[desc setText:nil];
		[results setHidden:FALSE];
    //Prepare the variables needed to calculate the trials data.
		double total = 0, mean = 0, error = 0, std = 0;
		int i;
		NSDate *last, *next;
    //These for loops iterates through the intervals that were recorded preparing the data
    //needed for calculations.
		for( i=1, last=nil; i<[intervals count]; i++, last = next)
		{
			if (last == nil) {
                last = [intervals objectAtIndex: 0];
            }
			next = (NSDate*)[intervals objectAtIndex:i];
			NSLog(@"%f\n", [next timeIntervalSinceDate:last]);
			double current = [next timeIntervalSinceDate: last];
            
            // Store the current interval in the string.
            if(i+1 < [intervals count]) {
                [csvIntervals appendFormat:@"%0.2lf,", current];
            }
            else {
                [csvIntervals appendFormat:@"%0.2lf\n", current];
            }
            
			total += current;
			error += fabs( current - testInterval );
		}
		mean = total / ([intervals count] -1);
		error /= [intervals count] - 1;
		
		for( i=1, last=nil; i<[intervals count]; i++, last = next)
		{
			if (last == nil) last = [intervals objectAtIndex: 0];
			next = (NSDate*)[intervals objectAtIndex:i];
			double current = [next timeIntervalSinceDate: last];
			std += (current - mean)*(current - mean);
		}
		std = sqrt( 1./([intervals count]-1) * std);
    //These blocks prepare the data for presentation through the view.
    //printResults is used to print the data to stdout.
    NSString *printResults = 
    [NSString stringWithFormat:@"Trial %u\nTotal Time:\t%0.2lf\nIntervals:\t%u\nMean:\t\t%0.2lf\nError:\t\t%0.2lf\nStd Dev:\t%0.2lf\nCoeff of Var:\t%0.2lf\n",trialNum,
      total, [intervals count]-1, mean, error, std, std/(total/([intervals count]-1)) ];
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
		NSString *dateString = [formatter stringFromDate:[NSDate date]];
		NSLog(@"%@\t%u\t%@\t%@", subNum,trialNum,addInfo,dateString);
		NSLog(@"(%@)\n", printResults);
    //saveResults is the actual string that will be saved in Core Data.
		NSString *saveResults = [NSString stringWithFormat:@"%@,%u,%0.2lf,%u,%0.2lf,%0.2lf,%0.2lf,%0.2lf,%@,%@\n",
								 subNum, trialNum, total, [intervals count]-1, mean, error, std, std/(total/([intervals count]-1)),
								 dateString,addInfo];
    //Print to standard out what we just saved.
		NSLog(@"(%@)\n", saveResults);
		//Change the results label.
		[results setText: printResults];
		[self saveTrial:saveResults];
        //Prepend the date to the csvIntervals string, then save it
        [self saveTrialRaw:[NSString stringWithFormat:@"%@,%@", dateString, csvIntervals]];
		//[self printDatabase]; //this call was for early debugging.
    //finally, reconfigure our buttons.
		[goToMain setHidden:FALSE];
		[nextButton setHidden:FALSE];
		[stopTrial setHidden:TRUE];
    [formatter release];
	} else {}
	
}
///////////////////////////////////////////////////////////////////////////////////////////
//This function saves the passed in string containing the data of the experiment to Core
//Data. The experiment name is the key used to store the string inside the database.
- (void) saveTrial: (NSString*) data {
	NSError *error;
	NSLog(@"%@", experimentName);
  //The predicate is what core data is queried with. In this case we are looking under
  //the expName attribute for any entries that match the experiment name entered in
  //the previous view.
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(expName matches %@)", experimentName];
  //The entity is the model in core data that we are looking inside. We pass it the
  //managed object context that was created inside the app delegate.
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Experiment" inManagedObjectContext:managedObjectContext];
  //We create an NSFetchRequest, set its entity and predicate and finally store the
  //the results inside an NSArray.
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:entity];
	[request setPredicate:predicate];
	NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:request
                                                                error:&error];
  //If we did not get any results from our fetch, we make a new entry
	if([fetchedObjects count] < 1){
		//This is the header for the csv file and what every data string should begin with
    //inside the experiment entry. The data is concatenated to the end of the header 
    //since this will be the first entry.
		NSString *header = [NSString stringWithFormat:@"subNum,trialNum,total,interval count,mean,error,std dev,coeff of variance,Date & Time, Add. Info,\n%@", data];
    //Create a managed object to hold the new information under the current experiments
    //name.
		NSManagedObject *experimentObj = [NSEntityDescription insertNewObjectForEntityForName:@"Experiment" inManagedObjectContext:managedObjectContext];
		[experimentObj setValue:experimentName forKey:@"expName"];
		[experimentObj setValue:header forKey:@"dataString"];
	}
	else{
    //If an entry exist for the given experiment name we simply use a for each loop to
    //concatenate the data onto the end of the dataString attribute.
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
///////////////////////////////////////////////////////////////////////////////////////////
//This function saves the passed in string containing the data of the experiment to Core
//Data. The experiment name is the key used to store the string inside the database.
- (void) saveTrialRaw: (NSString*) data {
	NSError *error;
    //Modify the existing experiment name 
    NSString *modExperimentName = [NSString stringWithFormat:@"%@-Raw", experimentName];
	NSLog(@"%@", modExperimentName);
    //The predicate is what core data is queried with. In this case we are looking under
    //the expName attribute for any entries that match the experiment name entered in
    //the previous view.
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(expName matches %@)", modExperimentName];
    //The entity is the model in core data that we are looking inside. We pass it the
    //managed object context that was created inside the app delegate.
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Experiment" inManagedObjectContext:managedObjectContext];
    //We create an NSFetchRequest, set its entity and predicate and finally store the
    //the results inside an NSArray.
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:entity];
	[request setPredicate:predicate];
	NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:request
                                                                  error:&error];
    //If we did not get any results from our fetch, we make a new entry
	if([fetchedObjects count] < 1){
        //Create a managed object to hold the new information under the current experiments
        //name.
		NSManagedObject *experimentObj = [NSEntityDescription insertNewObjectForEntityForName:@"Experiment" inManagedObjectContext:managedObjectContext];
		[experimentObj setValue:modExperimentName forKey:@"expName"];
		[experimentObj setValue:data forKey:@"dataString"];
	}
	else{
        //If an entry exist for the given experiment name we simply use a for each loop to
        //concatenate the data onto the end of the dataString attribute.
        // I guess we do this for every object that matches the request? Seems odd -Kyle
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
///////////////////////////////////////////////////////////////////////////////////////////
//This function iterates through all experiment entries in the Experiment entity and prints
//them to the console. This was used for early debugging/figuring out what was going on.
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
//////////////////////////////////////////////////////////////////////////////////////////
//These functions are setters that allow the settings view controller to pass the 
//experiment parameters forward.
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
-(void) setSubjectNumber:(NSString*)val{
  if(val)
    subNum = val;
}
-(void) setAddInfo:(NSString*)val{
  if(val != nil)
    addInfo = val;
  else
    addInfo = @"";
}
-(void) setInterval: (int)val{
  testInterval = val;
}
-(void) setExperimentName: (NSString*)val{
  if(val != nil)
    experimentName = val;
  else
    experimentName = @"";
}
//////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)canBecomeFirstResponder {
	return TRUE;
}

- (void)viewDidAppear:(BOOL)animated {
	[self becomeFirstResponder];
}

- (void)dealloc {
	[super dealloc];
}


@end
