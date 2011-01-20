//
//  Medication.h
//  Health Hacker
//
//  Created by Morgan Schweers on 6/25/10.
//  Copyright 2010 CyberFOX Software, Inc. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Medication :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSString * dosage;
@property (nonatomic, retain) NSString * product;
@property (nonatomic, retain) NSString * frequency;
@property (nonatomic, retain) NSNumber * current;
@property (nonatomic, retain) NSNumber * dose_count;
@property (nonatomic, retain) NSString * document_id;
@property (nonatomic, retain) NSString * kind;
@property (nonatomic, retain) NSString * route;
@property (nonatomic, retain) UserInfo * user;

@end

@interface Medication (CoreDataGeneratedAccessors)
+ (Medication *)findByDocumentId:(NSString *)docId fromContext:(NSManagedObjectContext *)context;
@end
