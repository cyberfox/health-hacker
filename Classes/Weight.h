//
//  Weight.h
//  Health Hacker
//
//  Created by Morgan Schweers on 1/20/11.
//  Copyright 2011 CyberFOX Software, Inc. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "User.h"
#import "Entity.h"

@interface Weight :  Entity  
{
}

@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSDecimalNumber * pounds;
@property (nonatomic, retain) User * user;

+ (NSArray *)getWeight:(NSManagedObjectContext *)context;

@end



