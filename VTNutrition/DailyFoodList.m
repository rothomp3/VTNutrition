//
//  DailyFoodList.m
//  VTNutrition
//
//  Created by Robert Stephen Thompson on 4/10/13.
//  Copyright (c) 2013 ENGE 1104 W7G4. All rights reserved.
//

#import "DailyFoodList.h"
#import "Food.h"


@implementation DailyFoodList

@dynamic foods;
@dynamic totalCalories;

- (NSNumber*)totalCalories
{
    NSUInteger cal = 0;
    
    for (Food* food in self.foods)
    {
        cal += [food.calories unsignedIntegerValue];
    }
    register NSNumber* result = [NSNumber numberWithUnsignedInteger:cal];
    [super setValue:result forKey:@"totalCalories"];
    return result;
}

@end
