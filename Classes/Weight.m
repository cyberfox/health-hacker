// 
//  Weight.m
//  Health Hacker
//
//  Created by Morgan Schweers on 1/20/11.
//  Copyright 2011 CyberFOX Software, Inc. All rights reserved.
//

#import "Weight.h"

#import "User.h"

@implementation Weight 

@dynamic created_at;
@dynamic pounds;
@dynamic user;

+ (NSArray *)getWeight:(NSManagedObjectContext *)context {
  NSArray *rval = [self getEntities:context forEntity:@"Weight" count:5];
  if(rval == nil) rval = [NSArray new];
  return rval;
}


@end
