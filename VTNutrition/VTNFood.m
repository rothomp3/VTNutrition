//
//  VTNFood.m
//  VTNutrition
//
//  Created by Robert Stephen Thompson on 3/27/13.
//  Copyright (c) 2013 ENGE 1104 W7G4. All rights reserved.
//

#import "VTNFood.h"

@implementation VTNFood
- (id)initWithName:(NSString *)name calories:(int)cal fatCalories:(int)fatcal servingSize:(int)size
{
    self = [super init];
    if (self)
    {
        self.foodName = name;
        self.calories = cal;
        self.fatCalories = fatcal;
        self.servingSize = size;
    }
    
    return self;
}

- (id)initWithName:(NSString *)name
{
    return [self initWithName:name calories:0 fatCalories:0 servingSize:0];
}
@end
