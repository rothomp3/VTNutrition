//
//  VTNSecondViewController.h
//  VTNutrition
//
//  Created by Robert Stephen Thompson on 3/27/13.
//  Copyright (c) 2013 ENGE 1104 W7G4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTNSStringParsingExtensions.h"
@class VTNWebViewController;
@class DailyFoodList;

@interface VTNSecondViewController : UIViewController <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>
- (IBAction)parseFile:(UIButton *)sender;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UITableView *FoodListView;
@property (weak, nonatomic) IBOutlet UILabel *totalCaloriesLabel;
@property (strong, nonatomic) VTNWebViewController* detailViewController;
@property (strong, nonatomic) DailyFoodList* foodList;

@end
