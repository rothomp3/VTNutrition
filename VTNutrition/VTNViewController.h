//
//  VTNViewController.h
//  VTNutrition
//
//  Created by Robert Stephen Thompson on 3/27/13.
//  Copyright (c) 2013 ENGE 1104 W7G4. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VTNFood;

@interface VTNViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *foodNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *caloriesLabel;
@property (weak, nonatomic) IBOutlet UILabel *fatCaloriesLabel;
@property (weak, nonatomic) IBOutlet UILabel *servingSizeLabel;

@property (weak, nonatomic) VTNFood* food;
- (IBAction)loadWeb:(UIButton *)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil food:(VTNFood*)food;
@end
