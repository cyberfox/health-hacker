//
//  Entity.m
//  Health Hacker
//
//  Created by Morgan Schweers on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Entity.h"


@implementation Entity

+ (NSArray *)getEntities:(NSManagedObjectContext *)context forEntity:(NSString *)entityName count:(int)count {
  NSError *fetchError = nil;
  NSArray *fetchResults;
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  
  NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
  [fetchRequest setEntity:entity];
  NSSortDescriptor *ns = [NSSortDescriptor sortDescriptorWithKey:@"created_at" ascending:false];
  [fetchRequest setSortDescriptors:[[NSArray alloc] initWithObjects:ns, nil]];
  if(count != -1) [fetchRequest setFetchLimit:count];
  NSLog(@"Fetching results.");
  fetchResults = [context executeFetchRequest:fetchRequest error:&fetchError];
  [fetchRequest release];
  if (fetchResults != nil && ([fetchResults count] > 0) && fetchError == nil) {
    NSLog(@"Returning fetched results (%d)", [fetchResults count]);
    NSLog(@"Data: %@", fetchResults);
    for (NSManagedObject *info in fetchResults) {
      NSLog(@"Info: %@", info);
    }
    return fetchResults;
  }
  
  if (fetchError != nil) {
    NSLog(@"getEntities error: %@", fetchError);
  } else {
    //  Could not fetch any results; that's not really an error, though.
    NSLog(@"No results for info!");
  }
  
  return nil;
}

@end
