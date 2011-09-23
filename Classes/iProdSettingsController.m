//
//	iProdViewController.m
//	iProd
//
//	Created by Justin Proffitt on 11/3/10.
//	Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "iProdSettingsController.h"
#import "iProd2AppDelegate.h"

@implementation iProdSettingsController
@synthesize subjectName, trialName, description, intervalText, dateTimeLabel, intervalLabel, intervalDisplaySwitch, experimentName, totalTimerText, 
 totalTimeDisplaySwitch, useTotalTimeSwitch;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
		if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
				// Custom initialization
		}
		return self;
}
*/

///////////////////////////////////////////////////////////////////////////////////////////
//When the view loads we update the interval slider and the time stamp label appropriately,
//as well as prepare the scroll view dimensions.
- (void)viewDidLoad {
	[super viewDidLoad];
	//[self updateInterval:intervalSlider];
	time_t tt = time(NULL);
	[dateTimeLabel setText: [NSString stringWithFormat:@"%s", ctime(&tt)]];
	NSLog(@"ViewDidLoad");
	UIScrollView *tempScrollView=(UIScrollView *)self.view;
  tempScrollView.contentSize=CGSizeMake(320,560);
}

///////////////////////////////////////////////////////////////////////////////////////////
//This function initializes a time view controller and sets the managed object context
//appropriately.
- (void)startTimer{
  NSLog(@"StartTImer");

  iProdTimerController *timeController = [[iProdTimerController alloc] init];
  //This code passes along the settings from the current view to the timer view.
  timeController.managedObjectContext = [(iProd2AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
  
  [self.navigationController pushViewController:timeController animated:true];
  
  [timeController setUseBoundTimer:[self getUseTotalTime]];
  [timeController setShowTotalTimer:[self getTotalTimeDisplaySwitch]];
  [timeController setShowInterval:[self getIntervalDisplay]];
  [timeController setTotalDuration:(double)[self getTotalDuration]];
  [timeController setAddInfo:[self getAddInfo]];
  [timeController setSubjectNumber:[self getSubjectName]];
  [timeController setInterval:[self getInterval]];
  [timeController setTrialNum:[[self getTrialName] intValue]];
  [timeController setExperimentName:[self getExperimentName]];

  [timeController release];
};
///////////////////////////////////////////////////////////////////////////////////////////
//These getters are for passing along the settings to the timer controller.
- (bool) getIntervalDisplay{
    return intervalDisplaySwitch.on;
}
- (bool) getUseTotalTime{
    return useTotalTimeSwitch.on;
}
- (bool) getTotalTimeDisplaySwitch{
    return totalTimeDisplaySwitch.on;
}
- (int) getTotalDuration{
    return [[totalTimerText text] intValue]; 
}
- (int) getInterval {
	return [[intervalText text] intValue];
};
- (NSString*) getSubjectName {
	return [subjectName text];
};
- (NSString*) getTrialName {
	return [trialName text];
};
- (NSString*) getExperimentName {
	return [experimentName text];
};
- (NSString*) getAddInfo {
	return [description text];
};
///////////////////////////////////////////////////////////////////////////////////////////
//This function checks the values contained in the text fields of this view (not including
//the add. info field) and verifies that they are not empty, and that the interval, total
//time and trial number are all positive integer values. If any errors are found an alert
//is shown that presents a list of the errors that occured.
-(IBAction) checkInput{
  BOOL error = NO;
  int errCnt = 0;
  NSString* errMsg = @"The following errors were found:\n";
  UIAlertView* alert;
  //NSPredicate was used to validate the fields that must be integers. The regex: ^[0-9]+$
  //checks that only numeric characters are contained in the string.
  NSPredicate* isNumeric = [NSPredicate predicateWithFormat:@"SELF MATCHES '^[0-9]+$'"];

  //These statements check the text fields that are required to be filled in.
  if([[experimentName text] length] == 0){
    errMsg = [errMsg stringByAppendingFormat:
              @"%d. Experiment Name cannot be empty\n", ++errCnt];
    error = YES;
  }
  if([[subjectName text] length] == 0){
    errMsg = [errMsg stringByAppendingFormat:
              @"%d. Experiment Name cannot be empty\n", ++errCnt];
    error = YES;
  }
  if([[trialName text] length] == 0){
    errMsg = [errMsg stringByAppendingFormat:
              @"%d. Experiment Name cannot be empty\n", ++errCnt];
    error = YES;
  }
  if([[totalTimerText text] length] == 0){
    errMsg = [errMsg stringByAppendingFormat:
              @"%d. Experiment Name cannot be empty\n", ++errCnt];
    error = YES;
  }
  if([[intervalText text] length] == 0){
    errMsg = [errMsg stringByAppendingFormat:
              @"%d. Experiment Name cannot be empty\n", ++errCnt];
    error = YES;
  }
  
  //The following if statements use the isNumeric predicate to check the value held in the
  //text fields.
  if(![isNumeric evaluateWithObject:[totalTimerText text]]){
    errMsg = [errMsg stringByAppendingFormat:
              @"%d. Total time field must be an integer\n", ++errCnt];
    error = YES;
  }
  if(![isNumeric evaluateWithObject:[intervalText text]]){
    errMsg = [errMsg stringByAppendingFormat:
              @"%d. Interval field must be an integer.\n", ++errCnt];
    error = YES;
  }
  if(![isNumeric evaluateWithObject:[trialName text]]){
    errMsg = [errMsg stringByAppendingFormat:
              @"%d. Trial field must be an integer.\n", ++errCnt];
    error = YES;
  }
  
  //If an error was found, an alert is presented with error details and return.
  if(error){
    alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
    return;
  }
  //If no error was found, call start timer.
  [self startTimer];
}
///////////////////////////////////////////////////////////////////////////////////////////
//Pop to the main menu.
-(IBAction) goToMain{
  [[self navigationController] popToRootViewControllerAnimated:YES];
}
///////////////////////////////////////////////////////////////////////////////////////////
/*
- (void)viewWillAppear:(BOOL)animated{

}
*/


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
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
}


- (void)dealloc {
  [super dealloc];
}

- (void)hideKeyboard: (UITextField*)text {
	[text resignFirstResponder];
};
- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil]; 
}

@end
