// 
//  BloodPressure.m
//  Health Hacker
//
//  Created by Morgan Schweers on 1/20/11.
//  Copyright 2011 CyberFOX Software, Inc. All rights reserved.
//

#import "BloodPressure.h"
#import "User.h"

@implementation BloodPressure 

@dynamic systolic;
@dynamic document_id;
@dynamic diastolic;
@dynamic beats;
@dynamic created_at;
@dynamic user;

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
    for (User *info in fetchResults) {
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

+ (BloodPressure *)create:(NSManagedObjectContext *)context systolic:(int)sys diastolic:(int)dia heartRate:(int)heartRate {
  BloodPressure *bpInfo = [NSEntityDescription insertNewObjectForEntityForName:@"BloodPressure" inManagedObjectContext:context];
  bpInfo.systolic = [NSNumber numberWithInt:sys];
  bpInfo.diastolic = [NSNumber numberWithInt:dia];
  bpInfo.beats = [NSNumber numberWithInt:heartRate];
  bpInfo.created_at = [[NSDate alloc] init];
  User *currentUser = [User getUser:context];
  bpInfo.user = currentUser;
  [context save:nil];

  return bpInfo;
}

+ (NSArray *)getBP:(NSManagedObjectContext *)context {
  NSArray *rval = [self getEntities:context forEntity:@"BloodPressure" count:5];
  if(rval == nil) rval = [NSArray new];
  return rval;
}

@end
