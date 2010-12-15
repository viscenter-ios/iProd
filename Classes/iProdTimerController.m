//
//  iProdTimerController.m
//  iProd
//
//  Created by Matt Field on 11/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "iProdTimerController.h"
#import "iProdAppDelegate.h"
#import "iProdSettingsController.h"


@implementation iProdTimerController

@synthesize timer, desc, results, end;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
  timerIsRunning = false;
  intervals = [[NSMutableArray alloc] init];
}

- (BOOL)canBecomeFirstResponder {
  return YES;
}

- (void)viewDidAppear:(BOOL)animated {
  [self becomeFirstResponder];
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

- (void)startTimer {
  if(!timerIsRunning)
  {
//    start = [[NSDate date] retain];
    [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    timerIsRunning = true;
    [self hideButton:nil];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
  }
}

- (void)timerFireMethod:(NSTimer*)theTimer {
  if(timerIsRunning) {
    double interval = -[start timeIntervalSinceNow];
    [timer setText:[NSString stringWithFormat:@"%02d:%02d.%02d", (int)interval/60, (int)interval%60, (int)(interval*100)%100]];
    if( interval > 0.125 ) [[self view] setBackgroundColor: [UIColor colorWithRed:0.5 green:0 blue:0 alpha:1]];
  }
  else {
    [theTimer invalidate];
    [timer setText: nil];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
  }

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [[self view] setBackgroundColor: [UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
  start = [[NSDate date] retain];
  [intervals addObject:start];
  if( !timerIsRunning ) [self startTimer];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//  [[self view] setBackgroundColor: [UIColor colorWithRed:0.5 green:0 blue:0 alpha:1]];
  NSLog(@"touchesEnded\n");
}

- (void)hideButton:(NSTimer*)theTimer {
  if(timerIsRunning) {
    [end setHidden:TRUE];
    [desc setText: @"Trial running.\nPress the Home button\nor shake to exit."];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
  }
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
  [end setHidden:FALSE];
  [[UIApplication sharedApplication] setStatusBarHidden:NO];
  [desc setText: @"Click the button to end trial."];
  [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(hideButton:) userInfo:nil repeats:NO];
}

- (void) endTrial:(UIButton*)button {
  NSLog(@"endTrial\n");
  if(timerIsRunning) {
    timerIsRunning = false;
    [desc setText:nil];
    [results setHidden:FALSE];
    double total = 0, mean = 0, error = 0, std = 0;
    int interval = [[(iProdAppDelegate*)[[UIApplication sharedApplication] delegate] viewController] getInterval], i;
    NSDate *last, *next;
    for( i=1, last=nil; i<[intervals count]; i++, last = next)
    {
      if (last == nil) last = [intervals objectAtIndex: 0];
      next = (NSDate*)[intervals objectAtIndex:i];
      NSLog(@"%f\n", [next timeIntervalSinceDate:last]);
      double current = [next timeIntervalSinceDate: last];
      
      total += current;
      error += fabs( current - interval );
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
    
    [results setText:[NSString stringWithFormat:@"Total Time:\t%0.2lf\nIntervals:\t%u\nMean:\t\t%0.2lf\nError:\t\t%0.2lf\nStd Dev:\t%0.2lf\nCoeff of Var:\t%0.2lf\n",
                      total, [intervals count]-1, mean, error, std, std/(total/([intervals count]-1)) ]];
  } else {
  }
}

- (void)dealloc {
    [super dealloc];
}


@end
