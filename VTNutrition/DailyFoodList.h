//
//  DailyFoodList.h
//  VTNutrition
//
//  Created by Robert Stephen Thompson on 4/10/13.
//  Copyright (c) 2013 ENGE 1104 W7G4. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Food;

@interface DailyFoodList : NSManagedObject

@property (nonatomic, retain) NSNumber * totalCalories;
@property (nonatomic, retain) NSSet *foods;
@end

@interface DailyFoodList (CoreDataGeneratedAccessors)

- (void)addFoodsObject:(Food *)value;
- (void)removeFoodsObject:(Food *)value;
- (void)addFoods:(NSSet *)values;
- (void)removeFoods:(NSSet *)values;

@end
