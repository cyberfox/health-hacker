// 
//  Medication.m
//  Health Hacker
//
//  Created by Morgan Schweers on 6/25/10.
//  Copyright 2010 CyberFOX Software, Inc. All rights reserved.
//

#import "Medication.h"


@implementation Medication 

@dynamic comment;
@dynamic dosage;
@dynamic product;
@dynamic frequency;
@dynamic current;
@dynamic dose_count;
@dynamic document_id;
@dynamic kind;
@dynamic route;
@dynamic user;

+ (Medication *)findByDocumentId:(NSString *)docId fromContext:(NSManagedObjectContext *)context {
  NSError *fetchError = nil;
  NSArray *fetchResults;
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Medication" inManagedObjectContext:context];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"document_id = %@", docId];
  [fetchRequest setEntity:entity];
  [fetchRequest setPredicate:predicate];
  fetchResults = [context executeFetchRequest:fetchRequest error:&fetchError];
  [fetchRequest release];
  if (fetchResults != nil && ([fetchResults count] > 0) && fetchError == nil) {
    return [fetchResults objectAtIndex:0];
  }
  
  if (fetchError != nil) {
    NSLog(@"findByDocumentId error: %@", fetchError);
  } else {
    //  Could not fetch any results; that's not really an error, though.
    NSLog(@"No results searching for document id: %@", docId);
  }
  
  return nil;
}

@end
