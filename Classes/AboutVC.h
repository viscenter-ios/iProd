//
//  AboutVC.h
//  iProd2
//
//  Created by Justin Proffitt on 6/2/11.
//  Copyright 2011 University Of Kentucky. All rights reserved.
//
//This class is used to display the about information for the app. The information is presented using a UIWebView and an html file.

#import <UIKit/UIKit.h>

@interface AboutVC : UIViewController {
    IBOutlet UIWebView *aboutWebView;
}

@property (nonatomic, retain) IBOutlet UIWebView *aboutWebView;

@end
