//
//  BloodPressure.h
//  Health Hacker
//
//  Created by Morgan Schweers on 1/20/11.
//  Copyright 2011 CyberFOX Software, Inc. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "User.h"
#import "Entity.h"

@interface BloodPressure :  Entity  
{
}

@property (nonatomic, retain) NSNumber * systolic;
@property (nonatomic, retain) NSString * document_id;
@property (nonatomic, retain) NSNumber * diastolic;
@property (nonatomic, retain) NSNumber * beats;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) User * user;

+ (NSArray *)getBP:(NSManagedObjectContext *)context;
+ (BloodPressure *)create:(NSManagedObjectContext *)context systolic:(int)sys diastolic:(int)dia heartRate:(int)heartRate;
@end



