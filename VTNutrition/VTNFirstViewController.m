//
//  VTNFirstViewController.m
//  VTNutrition
//
//  Created by Robert Stephen Thompson on 3/27/13.
//  Copyright (c) 2013 ENGE 1104 W7G4. All rights reserved.
//

#import "VTNFirstViewController.h"
#import "Food.h"
#import "DiningHall.h"
#import "SubRestaraunt.h"
#import "VTNWebViewController.h"
#import "DailyFoodList.h"

@interface VTNFirstViewController ()

@end

@implementation VTNFirstViewController
@synthesize foodArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Food List", @"Food List");
        self.tabBarItem.image = [UIImage imageNamed:@"magnifying_glass"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    switch (self.currentLevel) {
        case 0:
            self.navigationItem.title = @"Dining Halls";
            break;
        case 1:
            self.navigationItem.title = @"Sub Restaurants";
            break;
        case 2:
            self.navigationItem.title = @"Foods";
            break;
        default:
            break;
    }
    [self.searchDisplayController setValue:@(UITableViewStyleGrouped) forKey:@"_searchResultsTableViewStyle"];
    [self.foodTable setEditing:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.foodTable flashScrollIndicators];
    [self.foodTable setEditing:NO];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.foodTable deselectRowAtIndexPath:[self.foodTable indexPathForSelectedRow] animated:NO];
    [self.managedObjectContext save:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.foodTable)
        return [[self.fetchedResultsController sections] count];
    else
        return [[self.searchResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.foodTable)
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
        return [sectionInfo numberOfObjects];
    }
    else
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.searchResultsController sections][section];
        return [sectionInfo numberOfObjects];
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.foodTable)
    {
        static NSString *CellIdentifier = @"Cell";
        
        switch (self.currentLevel)
        {
            case 0:
            case 1:
                break;
            case 2:
                CellIdentifier = @"FoodCell";
                break;
        }
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            if ([CellIdentifier isEqualToString:@"FoodCell"])
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                cell.textLabel.adjustsFontSizeToFitWidth = YES;
                cell.textLabel.adjustsLetterSpacingToFitWidth = YES;
                cell.textLabel.minimumScaleFactor = 0.4f;
                cell.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            }
            else
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        
        [self configureCell:cell atIndexPath:indexPath];
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"FoodCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            cell.textLabel.adjustsFontSizeToFitWidth = YES;
            cell.textLabel.adjustsLetterSpacingToFitWidth = YES;
            cell.textLabel.minimumScaleFactor = 0.4f;
            cell.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        }
        Food* food = [self.searchResultsController objectAtIndexPath:indexPath];
        cell.textLabel.text = food.name;
        cell.detailTextLabel.text = [food.calories stringValue];
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.foodTable)
    {
        VTNFirstViewController* fvc;
        Food* food;
        DiningHall* selectedDiningHall;
        
        switch (self.currentLevel) {
            case 0:
                selectedDiningHall = [[self fetchedResultsController] objectAtIndexPath:indexPath];
                if(([selectedDiningHall.subRestaraunts count] == 1))
                {
                    if ([((SubRestaraunt*)(selectedDiningHall.subRestaraunts.anyObject)).foods count] == 1)
                    {
                        self.detailViewController.food = [((SubRestaraunt*)(selectedDiningHall.subRestaraunts.anyObject)).foods anyObject];
                        [self.navigationController pushViewController:self.detailViewController animated:YES];
                        break;
                    }
                    else
                    {
                        fvc = [[VTNFirstViewController alloc] init];
                        fvc.managedObjectContext = self.managedObjectContext;
                        fvc.currentLevel = self.currentLevel + 2;
                        fvc.diningHall = [[self fetchedResultsController] objectAtIndexPath:indexPath];
                        fvc.subRest = [fvc.diningHall.subRestaraunts anyObject];
                        [self.navigationController pushViewController:fvc animated:YES];
                        break;

                    }
                }
                fvc = [[VTNFirstViewController alloc] init];
                fvc.managedObjectContext = self.managedObjectContext;
                fvc.currentLevel = self.currentLevel + 1;
                fvc.diningHall = [[self fetchedResultsController] objectAtIndexPath:indexPath];
                [self.navigationController pushViewController:fvc animated:YES];
                break;
            case 1:
                fvc = [[VTNFirstViewController alloc] init];
                fvc.currentLevel = self.currentLevel + 1;
                fvc.managedObjectContext = self.managedObjectContext;
                fvc.diningHall = self.diningHall;
                fvc.subRest = [[self fetchedResultsController] objectAtIndexPath:indexPath];
                [self.navigationController pushViewController:fvc animated:YES];
                break;
            case 2:
                food = [[self fetchedResultsController] objectAtIndexPath:indexPath];
                [self.detailViewController setFood:food];
                [self.navigationController pushViewController:self.detailViewController animated:YES];
                break;
            default:
                break;
        }
    }
    else
    {
        self.detailViewController.food = [self.searchResultsController objectAtIndexPath:indexPath];
        self.navigationItem.title = @"Search Results";
        [self.navigationController pushViewController:self.detailViewController animated:YES];
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.foodTable)
    {
        NSArray* indexTitles = [self.fetchedResultsController sections];
        if ([indexTitles count] < section + 1)
            return @"";
        else
            return [indexTitles[section] valueForKey:@"name"];
    }
    else
    {
        return [[self.searchResultsController sections][section] valueForKey:@"name"];
    }
}
#pragma mark Search bar
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate* fetchPredicate;
    switch (self.currentLevel) {
        case 0:
            fetchPredicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@", searchText];
            break;
        case 1:
            fetchPredicate = [NSPredicate predicateWithFormat:@"(name contains[cd] %@) AND (subRestaraunt.diningHall == %@)", searchText, self.diningHall];
            break;
        case 2:
            fetchPredicate = [NSPredicate predicateWithFormat:@"(name contains[cd] %@) AND (subRestaraunt == %@)", searchText, self.subRest];
            break;
        default:
            break;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setPredicate:fetchPredicate];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Food" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSSortDescriptor *diningHallSort = [[NSSortDescriptor alloc] initWithKey:@"subRestaraunt.diningHall.name" ascending:YES];
    NSSortDescriptor *subRestSort = [[NSSortDescriptor alloc] initWithKey:@"subRestaraunt.name" ascending:YES];
    NSSortDescriptor *caloriesSort = [[NSSortDescriptor alloc] initWithKey:@"calories" ascending:YES];
    NSArray *sortDescriptors = @[diningHallSort, subRestSort, sortDescriptor, caloriesSort];
    [fetchRequest setSortDescriptors:sortDescriptors];
    [NSFetchedResultsController deleteCacheWithName:@"searchCache"];
    self.searchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"subRestaraunt.diningHall.name" cacheName:@"searchCache"];
    self.searchResultsController.delegate = self;
    [self.searchResultsController performFetch:nil];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[self.searchDisplayController.searchBar scopeButtonTitles][[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    switch (self.currentLevel) {
        case 0:
            self.navigationItem.title = @"Dining Halls";
            break;
        case 1:
            self.navigationItem.title = @"Sub Restaurants";
            break;
        case 2:
            self.navigationItem.title = @"Foods";
            break;
            
        default:
            self.navigationItem.title = @"Search Results";
            break;
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSPredicate* predicate = nil;
    // Edit the entity name as appropriate.
    NSString* entityString;
    NSString* sortString = @"name";
    NSString* cacheName;
    NSString* sectionKeyPath;
    switch (self.currentLevel) {
        case 0:
            entityString = @"DiningHall";
            cacheName = @"Master";
            sectionKeyPath = nil;
            break;
        case 1:
            entityString = @"SubRestaraunt";
            predicate = [NSPredicate predicateWithFormat:@"diningHall == %@", self.diningHall];
            cacheName = self.diningHall.name;
            sectionKeyPath = @"diningHall.name";
            break;
        case 2:
            entityString = @"Food";
            predicate = [NSPredicate predicateWithFormat:@"subRestaraunt == %@", self.subRest];
            sortString = @"calories";
            cacheName = self.subRest.name;
            sectionKeyPath = @"subRestaraunt.diningHall.name";
            break;
        default:
            break;
    }
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityString inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortString ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:sectionKeyPath cacheName:cacheName];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.foodTable beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.foodTable insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.foodTable deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.foodTable;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.foodTable endUpdates];
}

/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
 {
 // In the simplest, most efficient, case, reload the table view.
 [self.foodTable reloadData];
 }
 */

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [[object valueForKey:@"name"] description];
    if (self.currentLevel == 2)
    {
        cell.detailTextLabel.text = [[object valueForKey:@"calories"] stringValue];
    }
}

#pragma mark - food list stuff
- (NSFetchedResultsController*) foodListController
{
    if (_foodListController != nil) {
        return _foodListController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DailyFoodList" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"totalCalories" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"FoodListCache"];
    aFetchedResultsController.delegate = self;
    
    [aFetchedResultsController performFetch:nil];
    DailyFoodList *foodList;
    if ([[aFetchedResultsController fetchedObjects] count] == 0)
    {
        foodList = [NSEntityDescription insertNewObjectForEntityForName:@"DailyFoodList" inManagedObjectContext:self.managedObjectContext];
        foodList.totalCalories = @0;
        [aFetchedResultsController performFetch:nil];
    }
    _foodListController = aFetchedResultsController;
    return aFetchedResultsController;
}

- (VTNWebViewController* )detailViewController
{
    if (!_detailViewController) {
        _detailViewController = [[VTNWebViewController alloc] initWithNibName:@"VTNWebView" bundle:nil];
        [_detailViewController setFoodList:[self.foodListController fetchedObjects][0]];
    }
    
    return _detailViewController;
}
@end
