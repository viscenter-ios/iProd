//
//	iProdTimerController.h
//	iProd
//
//	Created by Justin Proffitt on 11/5/10.
//	Copyright 2010 __MyCompanyName__. All rights reserved.
//
//This class controls the view that is the 'stop watch'. It allows for multiple experiment trials to be ran. It saves the data of these trials using Core Data and does so after each trial has finished. The data collected is stored as a string in the Experiment entity of the core data database in a csv ready format.

#import <UIKit/UIKit.h>
#import "Experiment.h"
#import <MessageUI/MessageUI.h>

@interface iProdTimerController : UIViewController <MFMailComposeViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>{
    //These members are passed to this class from the settings view controller.
    int subNum;
    NSString *addInfo;
    NSString *experimentName;
    NSString *printResults;
    NSString *saveResults;
    NSInteger trialNum;
    bool showTotalTimer;
    bool showInterval;
    bool useBoundTimer;
    double totalDuration;
    int testInterval;
	
    //These members are used to either perform the calculations behind the scenes, or update the UI.
    NSDate *start, *upperTime;
	UILabel *timerLabel, *results, *totalTimerLabel;
    UIBarButtonItem *homeButton, *nextButton, *stopTrial;
	NSTimer *totalDurationTimer;
	NSMutableArray *intervals;
	NSManagedObjectContext *managedObjectContext;
    
    //These members are used for displaying the results in a tableview. Very exciting.  The arrays and dictionaries hold "polished" data to show on the tableview.
    UITableView *resultsTable;
    NSMutableArray *displayIntervals;
    NSMutableDictionary *displayResults;

    //These members form a small state machine that controls the flow of this view.
	bool timerIsRunning;
	bool finishedTest;
	bool nextTrialFlag;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSTimer *totalDurationTimer;
@property (nonatomic, retain) NSString *experimentName;
@property (nonatomic, retain) NSString *printResults;
@property (nonatomic, retain) NSString *saveResults;
@property (nonatomic, retain) IBOutlet UILabel *totalTimerLabel;
@property (nonatomic, retain) IBOutlet UILabel *timerLabel;
@property (nonatomic, retain) IBOutlet UILabel *results;
@property (nonatomic, retain) IBOutlet UITableView *resultsTable;
@property (nonatomic, retain) NSMutableArray *displayIntervals;
@property (nonatomic, retain) NSMutableDictionary *displayResults;

- (void) endTrial;
- (void) resetState;
- (void) nextTrial;
- (void) startTimer;
- (void) timerFireMethod:(NSTimer*)theTimer;
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void) saveTrial:(NSString*) data;
- (void) printDatabase;
- (void) showActionMenu: (NSIndexPath *)fr;
- (void) goToMainMenu;

//These are the setters that are used to pass the settings from the previous controller.
-(void) setUseBoundTimer :(bool) val;
-(void) setShowInterval :(bool) val;
-(void) setShowTotalTimer :(bool) val;
-(void) setTrialNum :(int) val;
-(void) setTotalDuration: (double)val;
-(void) setSubjectNumber:(int)val;
-(void) setAddInfo:(NSString*)val;
-(void) setInterval:(int) val;
-(void) setExperimentName:(NSString*)val;
@end
