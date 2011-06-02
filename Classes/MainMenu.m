//
//  MainMenu.m
//  iProd2
//
//  Created by Justin Proffitt on 3/28/11.
//  Copyright 2011 University Of Kentucky. All rights reserved.
//

#import "MainMenu.h"
#import "iProd2AppDelegate.h"

@implementation MainMenu
@synthesize runTrial, sendEmail;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

///////////////////////////////////////////////////////////////////////////////////////////
//When the main menu loads we set the Nav bar to hidden.
- (void)viewDidLoad {
  [super viewDidLoad];
	[self.navigationController setNavigationBarHidden: TRUE];
}
///////////////////////////////////////////////////////////////////////////////////////////
//Push an instance of the settings controller onto nav controller stack.
-(IBAction)showSettings{
  iProdSettingsController *settings = [[iProdSettingsController alloc] init];
  [self.navigationController 
      pushViewController:settings animated:YES];
  [settings release];
}
///////////////////////////////////////////////////////////////////////////////////////////
//Create an instance of the experiment selector view controller, set its managed object
//context, and then push it onto the nav controller.
-(IBAction)showTable{
	ExpSelViewController *tableController = [[ExpSelViewController alloc] init];
    
	tableController.managedObjectContext = [(iProd2AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
	
    [self.navigationController pushViewController:tableController animated:YES];
  [tableController release];
}
///////////////////////////////////////////////////////////////////////////////////////////
-(void) viewWillAppear:(BOOL)animated{
	[self.navigationController setNavigationBarHidden: TRUE];
}	
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
