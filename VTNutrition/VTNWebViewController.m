//
//  VTNWebViewController.m
//  VTNutrition
//
//  Created by Robert Stephen Thompson on 3/27/13.
//  Copyright (c) 2013 ENGE 1104 W7G4. All rights reserved.
//

#import "VTNWebViewController.h"
#import "Food.h"
#import "DailyFoodList.h"
#import "VTNFirstViewController.h"

@interface VTNWebViewController ()

@end

@implementation VTNWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSURLRequest* request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addToDaily:(UIButton *)sender {

    //[self.foodList addFoodsObject:self.food];
    self.food.foodList = self.foodList;
    //self.foodList.totalCalories = [NSNumber numberWithUnsignedInteger:([self.foodList.totalCalories unsignedIntegerValue] + [self.food.calories unsignedIntegerValue])];
    //NSArray* navControllers = self.navigationController.viewControllers;
    //[navControllers[[navControllers count] - 2] addFoodToList:self.food];
}

- (void)setFood:(Food *)food
{
    _food = food;
    self.url = [NSURL URLWithString:self.food.url];
}


@end
