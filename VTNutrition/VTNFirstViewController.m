//
//  VTNFirstViewController.m
//  VTNutrition
//
//  Created by Robert Stephen Thompson on 3/27/13.
//  Copyright (c) 2013 ENGE 1104 W7G4. All rights reserved.
//

#import "VTNFirstViewController.h"
#import "VTNFood.h"
#import "VTNViewController.h"

@interface VTNFirstViewController ()

@end

@implementation VTNFirstViewController
@synthesize foodArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    foodArray = [[NSMutableArray alloc] init];
    [foodArray addObject:[[VTNFood alloc] initWithName:@"French Fries" calories:1000 fatCalories:950 servingSize:1]];
    [foodArray addObject:[[VTNFood alloc] initWithName:@"Ice Cream" calories:10000 fatCalories:10000 servingSize:5]];
    [foodArray addObject:[[VTNFood alloc] initWithName:@"Lettuce" calories:0 fatCalories:0 servingSize:100]];
    [foodArray addObject:[[VTNFood alloc] initWithName:@"Celery" calories:-5 fatCalories:0 servingSize:10]];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"Foods";
    [self.foodTable setDataSource:self];
    [self.foodTable setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [foodArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"foodCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [(VTNFood*)(foodArray[indexPath.row]) description];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VTNFood* food = foodArray[indexPath.row];
    VTNViewController* foodView = [[VTNViewController alloc] initWithNibName:@"VTNutritionView" bundle:nil food:food];
    [self.navigationController pushViewController:foodView animated:YES];
}
@end
