//
//  VTNViewController.m
//  VTNutrition
//
//  Created by Robert Stephen Thompson on 3/27/13.
//  Copyright (c) 2013 ENGE 1104 W7G4. All rights reserved.
//

#import "VTNViewController.h"
#import "Food.h"
#import "VTNWebViewController.h"
#import "SubRestaraunt.h"
#import "DiningHall.h"

@interface VTNViewController ()

@end

@implementation VTNViewController

- (IBAction)loadWeb:(UIButton *)sender {
    VTNWebViewController* wvc = [[VTNWebViewController alloc] initWithNibName:@"VTNWebView" bundle:nil];
    wvc.url = [NSURL URLWithString:self.food.url];
    
    [self.navigationController pushViewController:wvc animated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil food:(Food*)food
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.food = food;
    }
    return self;
}

- (IBAction)getDHInfo:(UIButton *)sender {
    NSMutableString* list = [[NSMutableString alloc] init];
    for (SubRestaraunt* i in self.food.subRestaraunt.diningHall.subRestaraunts)
    {
        [list appendString:i.name];
        [list appendString:@" and "];
    }
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:self.food.subRestaraunt.diningHall.name message:list delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    [alert show];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.foodNameLabel.text = [self.food name];
    self.caloriesLabel.text = [[self.food calories] stringValue];
    self.subRestLabel.text = self.food.subRestaraunt.name;
    self.diningHallLabel.text = self.food.subRestaraunt.diningHall.name;
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.foodNameLabel.text = nil;
    self.caloriesLabel.text = nil;
    self.subRestLabel.text = nil;
    self.diningHallLabel.text = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
