// 
//  BloodGlucose.m
//  Health Hacker
//
//  Created by Morgan Schweers on 1/20/11.
//  Copyright 2011 CyberFOX Software, Inc. All rights reserved.
//

#import "BloodGlucose.h"

#import "User.h"

@implementation BloodGlucose 

@dynamic created_at;
@dynamic milligrams;
@dynamic user;

+ (NSArray *)getGlucose:(NSManagedObjectContext *)context {
  NSArray *rval = [self getEntities:context forEntity:@"BloodGlucose" count:5];
  if(rval == nil) rval = [NSArray new];
  return rval;
}

@end
