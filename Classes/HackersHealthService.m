//
//  HackersHealthService.m
//  Health Hacker
//
//  Created by Morgan Schweers on 1/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HackersHealthService.h"

@implementation HackersHealthService

@dynamic username;
@dynamic password;

+(void) initialize {
  [self setBasicAuthWithUsername:@"a_username" password:@"a_password"];
//  [self setDefaultHeaders:[NSDictionary dictionaryWithObject:@"Some Header Value" forKey:@"My-Header"]];
}

@end
