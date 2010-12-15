//
//  iProdViewController.m
//  iProd
//
//  Created by Matt Field on 11/3/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "iProdSettingsController.h"
#import "iProdAppDelegate.h"

@implementation iProdSettingsController


@synthesize subject, trial, description, slider, datetime, sliderValue, timer;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
  [self updateInterval:slider];
  time_t tt = time(NULL);
  [datetime setText: [NSString stringWithFormat:@"%s", ctime(&tt)]];
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
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (void)hideKeyboard: (UITextField*)text {
  [text resignFirstResponder];
};

- (void)updateInterval: (UISlider*)slide {
  [sliderValue setText: [NSString stringWithFormat:@"%d", (int)[slider value]]];
};

- (void)startTimer: (UIButton*)button {
  [(iProdAppDelegate*)[[UIApplication sharedApplication] delegate] showTimer];
};

- (int) getInterval {
  return [slider value];
};
@end
