//
//  iProd2AppDelegate.h
//  iProd2
//
//  Created by Justin Proffitt on 3/28/11.
//  Copyright 2011 University Of Kentucky. All rights reserved.
//
//This is the iProd application delegate and contains the inner workings of the application. The Core Data managed object context is created/retrieved from within this function for use by the ExpSelViewController and the iProdTimerController classes.

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "iProdSettingsController.h"
#import "iProdTimerController.h"
#import "MainMenu.h"
#import "Experiment.h"
#import "ExpSelViewController.h"
#import "AboutVC.h"

@class iProdSettingsController;
@class iProdTimerController;
@class MainMenu;
@class ExperimentTableController;

@interface iProd2AppDelegate : NSObject <UIApplicationDelegate> {
    //This is used as the root of the naviController.
    MainMenu *startMenu;
    //This is the navigation controller used by the application.
    UINavigationController *naviController;
    UIWindow *window;
  
    //These classes were added by xcode for use with Core Data.
    @private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UINavigationController *naviController;
@property (nonatomic, retain) IBOutlet MainMenu *startMenu;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//These methods were created by xcode.
- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;

@end

