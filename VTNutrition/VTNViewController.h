//
//  VTNViewController.h
//  VTNutrition
//
//  Created by Robert Stephen Thompson on 3/27/13.
//  Copyright (c) 2013 ENGE 1104 W7G4. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Food;

@interface VTNViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *foodNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *caloriesLabel;
@property (weak, nonatomic) IBOutlet UILabel *subRestLabel;
@property (weak, nonatomic) IBOutlet UILabel *diningHallLabel;

@property (weak, nonatomic) Food* food;
- (IBAction)loadWeb:(UIButton *)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil food:(Food*)food;
- (IBAction)getDHInfo:(UIButton *)sender;
@end
