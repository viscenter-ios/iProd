//
//  iProdAppDelegate.h
//  iProd
//
//  Created by Matt Field on 11/3/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iProdSettingsController;
@class iProdTimerController;

@interface iProdAppDelegate : NSObject <UIApplicationDelegate> {
  UIWindow *window;
  iProdSettingsController *viewController;
  iProdTimerController *timeController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet iProdSettingsController *viewController;
@property (nonatomic, retain) IBOutlet iProdTimerController *timeController;

- (void)showTimer;
- (void)showResults: (NSMutableArray*)intervals;
@end

