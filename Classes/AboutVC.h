//
//  AboutVC.h
//  iProd2
//
//  Created by Justin Proffitt on 6/2/11.
//  Copyright 2011 University Of Kentucky. All rights reserved.
//
//This class is used to display the about information for the app. The information is
//presented using a UIWebView and retrieved from a web server.

#import <UIKit/UIKit.h>
#define ABOUT_ADDRESS @"http://halsted.vis.uky.edu/~justin/about.html"

@interface AboutVC : UIViewController {
  IBOutlet UIImageView *bgImage;
  IBOutlet UIWebView *aboutWebView;
}

@property (nonatomic, retain) IBOutlet UIWebView *aboutWebView;
@property (nonatomic, retain) IBOutlet UIImageView *bgImage;
-(IBAction) goToMain;
@end
