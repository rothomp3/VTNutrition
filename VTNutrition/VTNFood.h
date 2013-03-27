//
//  VTNFood.h
//  VTNutrition
//
//  Created by Robert Stephen Thompson on 3/27/13.
//  Copyright (c) 2013 ENGE 1104 W7G4. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VTNFood : NSObject
@property (strong, nonatomic) NSString* foodName;
@property (nonatomic) int calories;
@property (nonatomic) int fatCalories;
@property (nonatomic) int servingSize;

- (id)initWithName:(NSString*)name calories:(int)cal fatCalories:(int)fatcal servingSize:(int)size;
- (id)initWithName:(NSString *)name;
@end
