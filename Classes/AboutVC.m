//
//  AboutVC.m
//  iProd2
//
//  Created by Justin Proffitt on 6/2/11.
//  Copyright 2011 University Of Kentucky. All rights reserved.
//

#import "AboutVC.h"


@implementation AboutVC

@synthesize aboutWebView;

///////////////////////////////////////////////////////////////////////////////////////////
    //When the view loads, we add the webview to the view and load the "about.html" file
- (void)viewDidLoad {
    self.title = @"About";
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"];
	NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:path];
	NSString *htmlString = [[NSString alloc] initWithData: [readHandle readDataToEndOfFile] encoding:NSUTF8StringEncoding];
	[self.aboutWebView loadHTMLString:htmlString baseURL:nil];
	[htmlString release];
}
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\


@end
