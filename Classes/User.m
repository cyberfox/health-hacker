// 
//  User.m
//  Health Hacker
//
//  Created by Morgan Schweers on 1/20/11.
//  Copyright 2011 CyberFOX Software, Inc. All rights reserved.
//

#import "User.h"

#import "BloodGlucose.h"
#import "BloodPressure.h"
#import "Medication.h"
#import "Weight.h"

@implementation User

@dynamic password;
@dynamic goalWeight;
@dynamic username;
@dynamic weights;
@dynamic medications;
@dynamic glucoses;
@dynamic bloodPressures;

+ (User *)getUser:(NSManagedObjectContext *)context {
  NSError *fetchError = nil;
  NSArray *fetchResults;
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
  [fetchRequest setEntity:entity];
  NSLog(@"Fetching results.");
  fetchResults = [context executeFetchRequest:fetchRequest error:&fetchError];
  [fetchRequest release];
  if (fetchResults != nil && ([fetchResults count] > 0) && fetchError == nil) {
    NSLog(@"Returning fetched results (%d)", [fetchResults count]);
    NSLog(@"Data: %@", fetchResults);
    for (User *info in fetchResults) {
      NSLog(@"Info: %@", info);
    }
    return [fetchResults objectAtIndex:0];
  }
  
  if (fetchError != nil) {
    NSLog(@"getUser error: %@", fetchError);
  } else {
    //  Could not fetch any results; that's not really an error, though.
    NSLog(@"No results for user info!");
  }
  
  return nil;
}

@end
