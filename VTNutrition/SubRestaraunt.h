//
//  SubRestaraunt.h
//  VTNutrition
//
//  Created by Robert Stephen Thompson on 4/10/13.
//  Copyright (c) 2013 ENGE 1104 W7G4. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DiningHall;

@interface SubRestaraunt : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) DiningHall *diningHall;
@property (nonatomic, retain) NSSet *foods;
@end

@interface SubRestaraunt (CoreDataGeneratedAccessors)

- (void)addFoodsObject:(NSManagedObject *)value;
- (void)removeFoodsObject:(NSManagedObject *)value;
- (void)addFoods:(NSSet *)values;
- (void)removeFoods:(NSSet *)values;

@end
