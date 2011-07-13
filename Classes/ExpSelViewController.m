//
//  ExpSelViewController.m
//  iProd2
//
//  Created by Justin Proffitt on 4/7/11.
//  Copyright 2011 University Of Kentucky. All rights reserved.
//

#import "ExpSelViewController.h"
#import "iProd2AppDelegate.h"

@implementation ExpSelViewController

@synthesize experimentArray, managedObjectContext, tableView, fetchedResultsController, csvFileName, editButton;


///////////////////////////////////////////////////////////////////////////////////////////
    //When the view loads we set the title of the navigation bar, add a button to the bar that will serve for entering delete mode, and make sure that we have the managed object context from main.
- (void)viewDidLoad {
	[super viewDidLoad];
	if(self.managedObjectContext == nil){
		self.managedObjectContext = [(iProd2AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
	}
	self.title = @"Experiments";
    //show an 'edit' button on the right side of the navigation bar
    editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style: UIBarButtonItemStyleBordered target:self action:@selector(edit)];
    self.navigationItem.rightBarButtonItem = editButton;
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
    //This function swaps the value of the tableviews editing property, which occurs when the edit button is pressed. While editing is true, the entries can be removed from the table by pressing the red minus button and then pressing delete.
-(void) edit{
    if(!tableView.editing){
        [self.tableView setEditing:YES animated:YES];
        editButton.title = @"Done";
        editButton.style = UIBarButtonItemStyleDone;
    }
    else {
        [self.tableView setEditing:NO animated:YES];
        editButton.title = @"Edit";
        editButton.style = UIBarButtonItemStyleBordered;
    }
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
    //This function is called when an entry is deleted. It gets the object located at the table index that is passed in and deletes it and finally saves the changes and reloads the data.
- (void)tableView:(UITableView *)tView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
	if (editingStyle == UITableViewCellEditingStyleDelete){
		NSLog(@"deleted, %u", [indexPath row]);
        //Delete the object.
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
		[context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]){
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        //Grab the records again so that the old data is no longer present.
		[self fetchRecords];
        //Reload the table.
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [tView reloadData];
        [self.tableView endUpdates];
		
	}
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
    //This returns a reference to teh experiment located at the specified index path. This is used when creating the CSV file.
-(Experiment*) objForIndexPath:(NSIndexPath*)indexPath{
	Experiment *e = [self.fetchedResultsController objectAtIndexPath:indexPath];
	NSLog(@"experiment Name: %@", [e valueForKey:@"expName"]);
	NSLog(@"experiment Name: %@", [e valueForKey:@"dataString"]);
	return e;
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
    //This function grabs the Experiment data from the managed object context and populates the table view with the fetched records.
-(void) fetchRecords{
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Experiment" inManagedObjectContext:self.managedObjectContext];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
  
	[request setEntity:entity];
	//Set the way that we will sort the fetched records. In this case in alphabetical order.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"expName" ascending:YES];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptor release];
  //Fetch the proper data from the database.
	fetchedResultsController = [[NSFetchedResultsController alloc]
											  initWithFetchRequest:request
											  managedObjectContext:managedObjectContext
											  sectionNameKeyPath:nil
											  cacheName:nil];
	
	NSError *error;
  
	if(![fetchedResultsController performFetch:&error]){
    //Error occured.
  }

	[request release];
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
    //When the view appears we refetch the records.
- (void) viewWillAppear:(BOOL)animated {
    [self.view becomeFirstResponder];
    [self fetchRecords];
    [super viewWillAppear:animated];
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
    //This function returns the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[fetchedResultsController sections] count];
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
    //This function will return the number of rows in a section, in our case it is the number of experiments found in the database.
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
    //This function populates each cell inside the table view. It is called when the table view is first loaded and also when scrolling occurs (table views recycle cells to save memory)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
	//Grab the object at the corresponding index in the fetchedResultsController.
    NSManagedObject *managedObject = [fetchedResultsController objectAtIndexPath:indexPath];
    [cell.textLabel setText:[managedObject valueForKey:@"expName"]];
    NSDate *today = [managedObject valueForKey:@"dateString"];
    NSLog(@"%@", [managedObject valueForKey:@"dateString"]);
    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormat setDateStyle:NSDateFormatterShortStyle];
    NSString *dateString = [dateFormat stringFromDate:today];
    [cell.detailTextLabel setText:dateString];
	return cell;
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
    //This function returns the title for the section that it is called on.
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:
(NSInteger)section{ 
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo name];
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
    //This function returns an array containing the section index titles.
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [fetchedResultsController sectionIndexTitles];
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
    //This function returns an integer corresponding to the index passed in.
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
    //This function is called when user selects an experiment.
- (void)tableView:(UITableView *)tblView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    resultIndex = indexPath;
    [self showActionMenu];
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
    //This function shows an action menu with a button to email the results
-(void) showActionMenu{
    [self becomeFirstResponder];
    UIMenuItem* mailresults = [[[UIMenuItem alloc] initWithTitle: @"Email Results" action:@selector(emailResult)] autorelease];
    UIMenuController* mc = [UIMenuController sharedMenuController];
    mc.menuItems = [NSArray arrayWithObject: mailresults];
    UITableViewCell *tmpcell = [tableView cellForRowAtIndexPath:resultIndex];
    [mc setTargetRect: CGRectMake(tmpcell.frame.origin.x, tmpcell.frame.origin.y - tableView.contentOffset.y, tmpcell.frame.size.width, tmpcell.frame.size.height) inView: self.view];
    [mc setMenuVisible: YES animated: YES];
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
    //We just make sure if the user is scrolling, no row is selected. Also reset the variable so we can keep checking.
-(void)scrollViewDidScroll:(UIScrollView *)scrolled{
    if(resultIndex){
        [tableView deselectRowAtIndexPath:resultIndex animated:YES];
        resultIndex = Nil;
    }
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
    //This function handles the data to email the results as a csv attachment
-(void) emailResult{
    if(![MFMailComposeViewController canSendMail]) {
        UIAlertView *alrt;
        alrt = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error while trying to send the email.  Try updating to the latest version of iOS." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrt show];
        [alrt release];
		return;
	}
    
    else {
        //Grab the experiment data from that is at the index path.
        Experiment *e = [self objForIndexPath:resultIndex];
        
        //Prepare the time stamp for the CSV filename and email subject.
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        
        //Allocate a modal mail compose view controller.
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        
        //Generate the string that will be the subject of the email, then append .csv to it for the filename.
        NSString *subject = [NSString stringWithFormat:@"%@ - %@",[e valueForKey:@"expName"], dateString];
        csvFileName = [NSString stringWithFormat:@"%@.csv", subject];
        
        //Extract the contents of the data attribute as a string.
        NSString *message = [NSString stringWithFormat:@"%@", [e valueForKey:@"dataString"]];
        
        //Generate a block of data to be used as the attachment.
        NSData *fileData = [message dataUsingEncoding:NSASCIIStringEncoding];
        
        //Set the subject of the email, add the attachment, and finally present the email view.
        [controller setSubject:subject];
        [controller addAttachmentData:fileData mimeType:@"text/csv" fileName:csvFileName];
        [self presentModalViewController:controller animated:YES];
        
        [formatter release];
        [controller release];
    }
    [tableView deselectRowAtIndexPath:resultIndex animated:YES];
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
    //This function is called when the user selects an action from the modal view that should cause the view to be dismissed.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




//////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)canBecomeFirstResponder {
	return TRUE;
}

- (void)dealloc {
	[super dealloc];
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

@end
