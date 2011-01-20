//
//  User.h
//  Health Hacker
//
//  Created by Morgan Schweers on 1/20/11.
//  Copyright 2011 CyberFOX Software, Inc. All rights reserved.
//

#import <CoreData/CoreData.h>

@class BloodGlucose;
@class BloodPressure;
@class Medication;
@class Weight;

@interface User :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSNumber * goalWeight;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSSet* weights;
@property (nonatomic, retain) NSSet* medications;
@property (nonatomic, retain) NSSet* glucoses;
@property (nonatomic, retain) NSSet* bloodPressures;

@end


@interface User (CoreDataGeneratedAccessors)
- (void)addWeightsObject:(Weight *)value;
- (void)removeWeightsObject:(Weight *)value;
- (void)addWeights:(NSSet *)value;
- (void)removeWeights:(NSSet *)value;

- (void)addMedicationsObject:(Medication *)value;
- (void)removeMedicationsObject:(Medication *)value;
- (void)addMedications:(NSSet *)value;
- (void)removeMedications:(NSSet *)value;

- (void)addGlucosesObject:(BloodGlucose *)value;
- (void)removeGlucosesObject:(BloodGlucose *)value;
- (void)addGlucoses:(NSSet *)value;
- (void)removeGlucoses:(NSSet *)value;

- (void)addBloodPressuresObject:(BloodPressure *)value;
- (void)removeBloodPressuresObject:(BloodPressure *)value;
- (void)addBloodPressures:(NSSet *)value;
- (void)removeBloodPressures:(NSSet *)value;

+ (User *)getUser:(NSManagedObjectContext *)context;
@end
