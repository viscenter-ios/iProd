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
@synthesize subjectName, trialName, description, intervalText, dateTimeLabel, intervalDisplaySwitch, experimentName, totalTimerText, 
 totalTimeDisplaySwitch, useTotalTimeSwitch;


///////////////////////////////////////////////////////////////////////////////////////////
    //When the view loads we update the interval slider and the time stamp label appropriately, as well as prepare the scroll view dimensions.
- (void)viewDidLoad {
	[super viewDidLoad];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm  -  MM/dd/yyyy"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
	[dateTimeLabel setText: dateString];
	self.title = @"New Experiment";
	UIScrollView *tempScrollView=(UIScrollView *)self.view;
    tempScrollView.contentSize=CGSizeMake(320,521);
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\



    
///////////////////////////////////////////////////////////////////////////////////////////
    //This function initializes a time view controller and sets the managed object context appropriately.
- (void)startTimer{
    NSLog(@"StartTImer");

    iProdTimerController *timeController = [[iProdTimerController alloc] init];
    //This code passes along the settings from the current view to the timer view.
    timeController.managedObjectContext = [(iProd2AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
  
    [timeController setUseBoundTimer:[self getUseTotalTime]];
    [timeController setShowTotalTimer:[self getTotalTimeDisplaySwitch]];
    [timeController setShowInterval:[self getIntervalDisplay]];
    [timeController setTotalDuration:(double)[self getTotalDuration]];
    [timeController setAddInfo:[self getAddInfo]];
    [timeController setSubjectNumber:[self getSubjectName]];
    [timeController setInterval:[self getInterval]];
    [timeController setTrialNum:[self getTrialName]];
    [timeController setExperimentName:[self getExperimentName]];
    
    [self.navigationController pushViewController:timeController animated:true];
    [timeController release];
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




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
}
- (int) getSubjectName {
	return [[subjectName text] intValue];
}
- (int) getTrialName {
	return [[trialName text] intValue];
}
- (NSString*) getExperimentName {
	return [experimentName text];
}
- (NSString*) getAddInfo {
	return [description text];
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
    //This function checks the values contained in the text fields of this view (not including the add. info field) and verifies that they are not empty, and that the interval, total time and trial number are all positive integer values. If any errors are found an alert is shown that presents a list of the errors that occured.
-(IBAction) checkInput{
  BOOL error = NO;
  int errCnt = 0;
  NSString* errMsg = @"The following errors were found:\n";
  UIAlertView* alert;
  //NSPredicate was used to validate the fields that must be integers. The regex: ^[0-9]+$ checks that only numeric characters are contained in the string.
  NSPredicate* isNumeric = [NSPredicate predicateWithFormat:@"SELF MATCHES '^[0-9]+$'"];

  //These statements check the text fields that are required to be filled in.
  if([[experimentName text] length] == 0){
    errMsg = [errMsg stringByAppendingFormat:@"%d. Experiment Name cannot be empty\n", ++errCnt];
    error = YES;
  }
  if([[subjectName text] length] == 0){
    errMsg = [errMsg stringByAppendingFormat:@"%d. Subject Number cannot be empty\n", ++errCnt];
    error = YES;
  }
  if([[trialName text] length] == 0){
    errMsg = [errMsg stringByAppendingFormat:@"%d. Trial Number cannot be empty\n", ++errCnt];
    error = YES;
  }
  if([[totalTimerText text] length] == 0){
    errMsg = [errMsg stringByAppendingFormat:@"%d. Timer Limit cannot be empty\n", ++errCnt];
    error = YES;
  }
  if([[intervalText text] length] == 0){
    errMsg = [errMsg stringByAppendingFormat:@"%d. Timer Interval cannot be empty\n", ++errCnt];
    error = YES;
  }
  
  //The following if statements use the isNumeric predicate to check the value held in the text fields.
  if(![isNumeric evaluateWithObject:[totalTimerText text]]){
    errMsg = [errMsg stringByAppendingFormat:@"%d. Total time field must be an integer\n", ++errCnt];
    error = YES;
  }
  if(![isNumeric evaluateWithObject:[intervalText text]]){
    errMsg = [errMsg stringByAppendingFormat:@"%d. Interval field must be an integer.\n", ++errCnt];
    error = YES;
  }
  if(![isNumeric evaluateWithObject:[trialName text]]){
    errMsg = [errMsg stringByAppendingFormat:@"%d. Trial field must be an integer.\n", ++errCnt];
    error = YES;
  }
  
  //If an error was found, an alert is presented with error details and return.
  if(error){
    alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
    return;
  }
  else {
      //If no error was found, call start timer.
      [self startTimer];
  }
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
    //This function shrinks the view to fit the screen when the keyboard is visible.
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    //Code for animation
    [UIView beginAnimations:@"Move" context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    //The new size the view has to be when the keyboard shows
    self.view.frame = CGRectMake(0, 0, 320, 200);
    [UIView commitAnimations];
    
    //Now scroll the view to the proper location for the textField
    [self.view setContentOffset:CGPointMake(0, textField.frame.origin.y - 20) animated:YES];
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
    //This function returns the view to its original size when the keyboard hides
-(void)textFieldDidEndEditing:(UITextField *)textField {
    self.view.frame = CGRectMake(0, 0, 320, 416);
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
    //When the user clicks the return key (which says next) this function is called.  It moves the user to the next field, unless they are editing the last field
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == experimentName) {
        [experimentName resignFirstResponder];
        [subjectName becomeFirstResponder];
    }
    else if (textField == subjectName) {
        [subjectName resignFirstResponder];
        [trialName becomeFirstResponder];
    }
    else if (textField == trialName) {
        [trialName resignFirstResponder];
        [totalTimerText becomeFirstResponder];
    }
    else if (textField == totalTimerText) {
        [totalTimerText resignFirstResponder];
        [intervalText becomeFirstResponder];
    }
    else if (textField == intervalText) {
        [intervalText resignFirstResponder];
        [description becomeFirstResponder];
    }
    else if (textField == description) {
        [description resignFirstResponder];
    }
    return YES;
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
}

- (void)dealloc {
  [super dealloc];
}

- (void)viewWillDisappear:(BOOL)animated{

}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

@end
