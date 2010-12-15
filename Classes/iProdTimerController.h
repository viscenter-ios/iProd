//
//  iProdTimerController.h
//  iProd
//
//  Created by Matt Field on 11/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface iProdTimerController : UIViewController {

  NSDate *start;
  UILabel *timer, *desc, *results;
  UIButton *end;
  NSMutableArray *intervals;
  
  bool timerIsRunning;
}

@property (nonatomic,retain) IBOutlet UILabel *timer;
@property (nonatomic,retain) IBOutlet UILabel *desc;
@property (nonatomic,retain) IBOutlet UILabel *results;
@property (nonatomic,retain) IBOutlet UIButton *end;

- (IBAction) endTrial:(UIButton*)button;

- (void)startTimer;
- (void)hideButton:(NSTimer*)theTimer;
- (void)timerFireMethod:(NSTimer*)theTimer;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event;

@end
