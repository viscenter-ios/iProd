//
//  iProdViewController.h
//  iProd
//
//  Created by Matt Field on 11/3/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iProdSettingsController : UIViewController {
  UITextField *subject;
  UITextField *trial;
  UITextField *description;

  UISlider *slider;
  UILabel *datetime;
  UILabel *sliderValue;
  UISwitch *timer;
}

@property (nonatomic,retain) IBOutlet UITextField *subject;
@property (nonatomic,retain) IBOutlet UITextField *trial;
@property (nonatomic,retain) IBOutlet UITextField *description;
@property (nonatomic,retain) IBOutlet UISlider *slider;
@property (nonatomic,retain) IBOutlet UILabel *datetime;
@property (nonatomic,retain) IBOutlet UILabel *sliderValue;
@property (nonatomic,retain) IBOutlet UISwitch *timer;

- (IBAction)hideKeyboard: (UITextField*)text;
- (IBAction)updateInterval: (UISlider*)slide;
- (IBAction)startTimer: (UIButton*)button;

- (int) getInterval;
@end

