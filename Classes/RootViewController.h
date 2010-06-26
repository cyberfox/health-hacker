//
//  RootViewController.h
//  Health Hacker
//
//  Created by Morgan Schweers on 6/25/10.
//  Copyright CyberFOX Software, Inc. 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "GoogleHealth.h"

@interface RootViewController : UITableViewController <NSFetchedResultsControllerDelegate, GoogleHealthNotifier> {

@private
    NSFetchedResultsController *fetchedResultsController_;
    NSManagedObjectContext *managedObjectContext_;
    GoogleHealth *healthService;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end
