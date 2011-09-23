//
//	iProdTimerController.h
//	iProd
//
//	Created by Justin Proffitt on 11/5/10.
//	Copyright 2010 __MyCompanyName__. All rights reserved.
//
//This class controls the view that is the 'stop watch'. It allows for multiple experiment
//trials to be ran. It saves the data of these trials using Core Data and does so after 
//each trial has finished.
//
//The data collected is stored as a string in the Experiment entity of the core data 
//database in a csv ready format.

#import <UIKit/UIKit.h>
#import "Experiment.h"

@interface iProdTimerController : UIViewController {
  //These members are passed to this class from the settings view controller.
  NSString *subNum;
  NSString *addInfo;
  NSString *experimentName;
  NSInteger trialNum;
  bool showTotalTimer;
  bool showInterval;
  bool useBoundTimer;
  double totalDuration;
  int testInterval;
	
  //These members are used to either perform the calculations behind the scenes, or update
  //the UI.
  NSDate *start, *upperTime;
	UILabel *timerLabel, *desc, *results, *totalTimerLabel;
	UIButton *nextButton;
	UIButton *goToMain;
	UIButton *stopTrial;
	NSTimer *totalDurationTimer;
	NSMutableArray *intervals;
	NSManagedObjectContext *managedObjectContext;
  IBOutlet UIImageView *bgImage;
  //These members form a small state machine that controls the flow of this view.
	bool timerIsRunning;
	bool finishedTest;
	bool nextTrialFlag;
}

@property (nonatomic, retain) IBOutlet UIImageView *bgImage;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSTimer *totalDurationTimer;
@property (nonatomic,retain) IBOutlet UILabel *totalTimerLabel;
@property (nonatomic,retain) IBOutlet UILabel *timerLabel;
@property (nonatomic,retain) IBOutlet UILabel *desc;
@property (nonatomic,retain) IBOutlet UILabel *results;
@property (nonatomic,retain) IBOutlet UIButton *nextButton;
@property (nonatomic,retain) IBOutlet UIButton *goToMain;
@property (nonatomic,retain) IBOutlet UIButton *stopTrial;

- (IBAction) endTrial;
- (IBAction)resetState;
- (IBAction)nextTrial;
- (void)startTimer;
- (void)hideButton:(NSTimer*)theTimer;
- (void)timerFireMethod:(NSTimer*)theTimer;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event;
- (void)saveTrial:(NSString*) data;
- (void) printDatabase;
- (IBAction) goToMainMenu;
//These are the setters that are used to pass the settings from the previous controller.
-(void) setUseBoundTimer :(bool) val;
-(void) setShowInterval :(bool) val;
-(void) setShowTotalTimer :(bool) val;
-(void) setTrialNum :(int) val;
-(void) setTotalDuration: (double)val;
-(void) setSubjectNumber:(NSString*)val;
-(void) setAddInfo:(NSString*)val;
-(void) setInterval:(int) val;
-(void) setExperimentName:(NSString*)val;
@end
