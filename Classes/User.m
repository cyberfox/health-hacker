//
//  User.m
//  Health Hacker
//
//  Created by Morgan Schweers on 1/2/11.
//  Copyright 2011 CyberFOX Software, Inc. All rights reserved.
//

#import "User.h"


@implementation User

@dynamic username;
@dynamic password;

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
