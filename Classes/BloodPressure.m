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
