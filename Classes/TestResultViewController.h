//
//  TestResultViewController.h
//  Health Hacker
//
//  Created by Morgan Schweers on 1/18/11.
//  Copyright 2011 CyberFOX Software, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TestResultViewController : UITableViewController {

@private
  NSFetchedResultsController *fetchedResultsController_;
  NSManagedObjectContext *managedObjectContext_;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@end
