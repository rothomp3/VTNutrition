//
//  VTNFirstViewController.h
//  VTNutrition
//
//  Created by Robert Stephen Thompson on 3/27/13.
//  Copyright (c) 2013 ENGE 1104 W7G4. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DiningHall;
@class SubRestaraunt;
@class VTNWebViewController;
@interface VTNFirstViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UISearchDisplayDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *foodTable;

@property (strong, nonatomic) VTNWebViewController* detailViewController;

@property (strong, nonatomic) NSMutableArray* foodArray;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSFetchedResultsController *searchResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic) int currentLevel;
@property (weak, nonatomic) DiningHall* diningHall;
@property (weak, nonatomic) SubRestaraunt* subRest;

@property (strong, nonatomic) NSString* oldTitle;
@end
