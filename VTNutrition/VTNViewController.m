//
//  VTNViewController.m
//  VTNutrition
//
//  Created by Robert Stephen Thompson on 3/27/13.
//  Copyright (c) 2013 ENGE 1104 W7G4. All rights reserved.
//

#import "VTNViewController.h"
#import "VTNFood.h"
#import "VTNWebViewController.h"

@interface VTNViewController ()

@end

@implementation VTNViewController

- (IBAction)loadWeb:(UIButton *)sender {
    VTNWebViewController* wvc = [[VTNWebViewController alloc] initWithNibName:@"VTNWebView" bundle:nil];
    wvc.url = [NSURL URLWithString:@"http://foodpro.studentprograms.vt.edu/FoodPro_2.3/location.asp"];
    
    [self.navigationController pushViewController:wvc animated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil food:(VTNFood*)food
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.food = food;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.foodNameLabel.text = self.food.foodName;
    self.caloriesLabel.text = [NSString stringWithFormat:@"%d", self.food.calories];
    self.fatCaloriesLabel.text = [NSString stringWithFormat:@"%d", self.food.fatCalories];
    self.servingSizeLabel.text = [NSString stringWithFormat:@"%d", self.food.servingSize];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
