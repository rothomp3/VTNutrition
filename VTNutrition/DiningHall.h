//
//  DiningHall.h
//  VTNutrition
//
//  Created by Robert Stephen Thompson on 4/10/13.
//  Copyright (c) 2013 ENGE 1104 W7G4. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DiningHall : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSSet *subRestaraunts;
@end

@interface DiningHall (CoreDataGeneratedAccessors)

- (void)addSubRestarauntsObject:(NSManagedObject *)value;
- (void)removeSubRestarauntsObject:(NSManagedObject *)value;
- (void)addSubRestaraunts:(NSSet *)values;
- (void)removeSubRestaraunts:(NSSet *)values;

@end
