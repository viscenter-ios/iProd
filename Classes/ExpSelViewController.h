//
//  ExpSelViewController.h
//  iProd2
//
//  Created by Justin Proffitt on 4/7/11.
//  Copyright 2011 University Of Kentucky. All rights reserved.
//
//This view controller contains the table which is generated from the experiments stored using Core Data. It allows the user to either delete experiments that are currently on the device or email out (in csv format) the data of a given experiment.

#import <UIKit/UIKit.h>
#import "iProd2AppDelegate.h"
#import <MessageUI/MessageUI.h>

//The interface MFMailComposeViewControllerDelegate allows for pushing the modal mail view. This is used to email out the csv from the device.
@interface ExpSelViewController : UIViewController<MFMailComposeViewControllerDelegate> {
	//Managed object context to get information from core data and save changes.
    NSManagedObjectContext *managedObjectContext;
    //Array used in displaying of the table view.
	NSMutableArray *experimentArray;
    //This controller is used to display the experiments in the table view.
	NSFetchedResultsController *fetchedResultsController;
    //The filename that the csv will have when sent out.
    NSString *csvFileName;
	IBOutlet UITableView *tableView;
    UIBarButtonItem *editButton;
    NSIndexPath * resultIndex;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *experimentArray;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *editButton;
@property (nonatomic, retain) NSString *csvFileName;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

-(void) fetchRecords;
-(void) showActionMenu;
-(void) emailResult;
-(Experiment*) objForIndexPath:(NSIndexPath*)indexPath;

@end
