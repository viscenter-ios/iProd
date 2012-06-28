//
//  AboutVC.m
//  iProd2
//
//  Created by Justin Proffitt on 6/2/11.
//  Copyright 2011 University Of Kentucky. All rights reserved.
//

#import "AboutVC.h"


@implementation AboutVC
@synthesize bgImage,aboutWebView;
-(IBAction) goToMain
{
  [self.navigationController popToRootViewControllerAnimated:YES];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    return YES;
}

#pragma mark - View lifecycle
///////////////////////////////////////////////////////////////////////////////////////////
//When the view loads the background image in the xib is fitted to the page, then the
//information from the web is presented in the UIWebView found in this view.
- (void)viewDidLoad
{
  [super viewDidLoad];
  [bgImage sizeToFit];
  [self.view sendSubviewToBack:bgImage];
  //NSString *address = ABOUT_ADDRESS;
  //NSURL *url = [NSURL URLWithString:address];
  //NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //[aboutWebView loadRequest:request];
  //[aboutWebView.delegate = self];
  aboutWebView.delegate = self;
  [aboutWebView loadRequest:
     [NSURLRequest requestWithURL:
      [NSURL fileURLWithPath:
       [[NSBundle mainBundle] pathForResource:@"about.html" ofType:nil]isDirectory:NO]]];
  [aboutWebView setBackgroundColor:[UIColor clearColor]];
  [aboutWebView setOpaque:NO];
    
  
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
