//
//  Weight.h
//  Health Hacker
//
//  Created by Morgan Schweers on 1/20/11.
//  Copyright 2011 CyberFOX Software, Inc. All rights reserved.
//

#import <CoreData/CoreData.h>

@class UserInfo;

@interface Weight :  NSManagedObject  
{
}

@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSDecimalNumber * pounds;
@property (nonatomic, retain) UserInfo * user;

@end



