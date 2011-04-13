//
//  TestResultViewController.h
//  Health Hacker
//
//  Created by Morgan Schweers on 1/18/11.
//  Copyright 2011 CyberFOX Software, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BPEntryController.h"

@interface TestResultViewController : UITableViewController {
  BPEntryController *bpEntry;
@private
  NSFetchedResultsController *fetchedResultsController_;
  NSManagedObjectContext *managedObjectContext_;
  UITableView *displayTableView;
  NSArray *bloodPressure;
}

@property (nonatomic, retain) IBOutlet UITableView *displayTableView;
@property (nonatomic, retain) IBOutlet BPEntryController *bpEntry;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

-(void)addBloodPressureReading:(int)heartRate systolic:(int)systolic diastolic:(int)diastolic;
@end
