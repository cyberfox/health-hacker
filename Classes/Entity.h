//
//  Entity.h
//  Health Hacker
//
//  Created by Morgan Schweers on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Entity : NSManagedObject {
    
}

+ (NSArray *)getEntities:(NSManagedObjectContext *)context forEntity:(NSString *)entityName count:(int)count;
@end
