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


///////////////////////////////////////////////////////////////////////////////////////////
    //Initialization for when the view loads
- (void)viewDidLoad {
    self.title = @"Main Menu";
    [super viewDidLoad];
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
    //Push an instance of the settings controller onto the nav controller stack.
-(IBAction)showSettings{
    iProdSettingsController *settings = [[iProdSettingsController alloc] init];
    [self.navigationController pushViewController:settings animated:YES];
    [settings release];
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
    //Push an instance of the About view onto the nav controller stack.
-(IBAction) showAbout{
  AboutVC *about = [[AboutVC alloc] init];
  [self.navigationController pushViewController:about animated:YES];
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////
    //Create an instance of the experiment selector view controller, set its managed object context, and then push it onto the nav controller.
-(IBAction)showTable{
	ExpSelViewController *tableController = [[ExpSelViewController alloc] init];
	tableController.managedObjectContext = [(iProd2AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
	
    [self.navigationController pushViewController:tableController animated:YES];
    [tableController release];
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\




///////////////////////////////////////////////////////////////////////////////////////////	
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    [super dealloc];
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

@end
