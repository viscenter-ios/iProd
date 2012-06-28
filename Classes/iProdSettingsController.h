//
//	iProdViewController.h
//	iProd
//
//	Created by Justin Proffitt on 11/3/10.
//	Copyright __MyCompanyName__ 2010. All rights reserved.
//
//This class controls the view that allows the user to specifies settings for the 
//iProdTimerController.

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface iProdSettingsController : UIViewController {
	UITextField *experimentName;//name of experiment
	UITextField *subjectName;   //subject number
	UITextField *trialName;     //trial number
	UITextField *description;   //additional information

  UITextField *totalTimerText;//text field for total duration
  UITextField *intervalText;
	UILabel *dateTimeLabel;     //label for timestamp
	UILabel *intervalLabel;     //label for interval to test
	UISwitch *intervalDisplaySwitch;  //switch to turn on and off timer display
  UISwitch *useTotalTimeSwitch;     //switch to turn on and off total duration
  UISwitch *totalTimeDisplaySwitch; //switch to turn on and off 
}

@property (nonatomic, retain) IBOutlet UITextField *experimentName;
@property (nonatomic,retain) IBOutlet UITextField *subjectName;
@property (nonatomic,retain) IBOutlet UITextField *trialName;
@property (nonatomic,retain) IBOutlet UITextField *description;
@property (nonatomic,retain) IBOutlet UILabel *dateTimeLabel;
@property (nonatomic,retain) IBOutlet UILabel *intervalLabel;
@property (nonatomic,retain) IBOutlet UISwitch *intervalDisplaySwitch;
@property (nonatomic,retain) IBOutlet UISwitch *totalTimeDisplaySwitch;
@property (nonatomic,retain) IBOutlet UISwitch *useTotalTimeSwitch;
@property (nonatomic,retain) IBOutlet UITextField *totalTimerText;
@property (nonatomic,retain) IBOutlet UITextField *intervalText;
@property (nonatomic,retain) IBOutlet UIScrollView *scrollView;

//Method to hide keyboard when finished.
- (IBAction)hideKeyboard: (UITextField*)text;
//Method to push the next view controller onto stack.
- (void)startTimer;
//Method to return the contents of the description text field.
- (NSString*) getAddInfo;
//Method to return the contents of the subject name text field.
- (NSString*) getSubjectName;
//Method to return the contents of the trial name text field.
- (NSString*) getTrialName;
//Method to return the contents of the experiment name text field.
- (NSString*) getExperimentName;
//Method to return value of the interval display switch.
- (bool) getIntervalDisplay;
//Method to return value of the use total time switch.
- (bool) getUseTotalTime;
//Method to return value of the total time display switch.
- (bool) getTotalTimeDisplaySwitch;
//Method to return value of the total duration of the experiment in seconds.
- (int) getTotalDuration;
//Method to return value of the interval to use in seconds.
- (int) getInterval;
//Method to go to the main menu view.
-(IBAction) goToMain;
//Method to check the textfield input of the view.
-(IBAction) checkInput;
@end    

