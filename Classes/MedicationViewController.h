//
//  RootViewController.h
//  Health Hacker
//
//  Created by Morgan Schweers on 6/25/10.
//  Copyright CyberFOX Software, Inc. 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "LoginAlertView.h"
#import "UIPullToReloadTableViewController.h"
#import "HackersHealthService.h"

@interface MedicationViewController : UIPullToReloadTableViewController <NSFetchedResultsControllerDelegate, LoginAlertViewDelegate> {

@private
    NSFetchedResultsController *fetchedResultsController_;
    NSManagedObjectContext *managedObjectContext_;
    HackersHealthService *healthService;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end
