//
//  MainMenu.h
//  iProd2
//
//  Created by Justin Proffitt on 3/28/11.
//  Copyright 2011 University Of Kentucky. All rights reserved.
//
//This view controller is a simple menu that allows the user to select if they would
//like to run an experiment or email out the experiment. It is used as the root view 
//controller for the UINavigationController inside the iProd2AppDelegate.

#import <UIKit/UIKit.h>


@interface MainMenu : UIViewController {
  UIButton *runTrial;
  UIButton *sendEmail;
  IBOutlet UIImageView *bgImage;
}
//These functions push the proper View Controller onto the navigation stack.
-(IBAction) showSettings;
-(IBAction) showTable;
-(IBAction) showAbout;
@property (nonatomic, retain) UIButton *runTrial;
@property (nonatomic, retain) UIButton *sendEmail;
@property (nonatomic, retain) IBOutlet UIImageView *bgImage;

@end
