//
//  Food.h
//  VTNutrition
//
//  Created by Robert Stephen Thompson on 4/10/13.
//  Copyright (c) 2013 ENGE 1104 W7G4. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DailyFoodList, SubRestaraunt;

@interface Food : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * calories;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) SubRestaraunt *subRestaraunt;
@property (nonatomic, retain) NSSet *foodLists;
@end

@interface Food (CoreDataGeneratedAccessors)

- (void)addFoodListsObject:(DailyFoodList *)value;
- (void)removeFoodListsObject:(DailyFoodList *)value;
- (void)addFoodLists:(NSSet *)values;
- (void)removeFoodLists:(NSSet *)values;

@end
