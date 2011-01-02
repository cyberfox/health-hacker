//
//  UserInfo.h
//  Health Hacker
//
//  Created by Morgan Schweers on 1/2/11.
//  Copyright 2011 CyberFOX Software, Inc. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface UserInfo : NSManagedObject {
}

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * password;

@end

@interface UserInfo (CoreDataGeneratedAccessors)
+ (UserInfo *)getUserInfo:(NSManagedObjectContext *)context;
@end
