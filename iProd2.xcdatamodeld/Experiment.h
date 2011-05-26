//
//  Experiment.h
//  iProd2
//
//  Created by Justin Proffitt on 3/28/11.
//  Copyright 2011 University Of Kentucky. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Experiment :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * expName;
@property (nonatomic, retain) NSDate * dateString;
@property (nonatomic, retain) NSString * dataString;

@end



