//
//  VTNSecondViewController.m
//  VTNutrition
//
//  Created by Robert Stephen Thompson on 3/27/13.
//  Copyright (c) 2013 ENGE 1104 W7G4. All rights reserved.
//

#import "VTNSecondViewController.h"
#import "Food.h"
#import "SubRestaraunt.h"
#import "DiningHall.h"
#import "VTNWebViewController.h"
#import "DailyFoodList.h"

@interface VTNSecondViewController ()

@end

@interface FoodHolder : NSObject
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSNumber* calories;
@property (strong, nonatomic) NSString* url;
@property (strong, nonatomic) SubRestaraunt* subRestaraunt;
@end

@implementation FoodHolder


@end

@implementation VTNSecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"My Activity", @"My Activity");
        self.tabBarItem.image = [UIImage imageNamed:@"alarm"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.totalCaloriesLabel.text = [@0 stringValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.totalCaloriesLabel.text = [self.foodList.totalCalories stringValue];
    [self.FoodListView reloadData];
}

- (IBAction)parseFile:(UIButton *)sender {
    NSError *error = nil;
    NSFileManager* manager = [NSFileManager defaultManager];
    NSArray* files = [manager contentsOfDirectoryAtPath:[[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] path] error:&error];

    for (NSString *fileName in files)
    {
        if ([[fileName.pathExtension lowercaseString] isEqualToString:@"csv"])
        {
            NSURL *csvURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]  URLByAppendingPathComponent:fileName];
            
            NSString* csvString = [NSString stringWithContentsOfURL:csvURL encoding:NSUTF8StringEncoding error:nil];
            NSArray* westEndFoodArray = [csvString csvRows];
            
            NSManagedObjectContext* context = self.managedObjectContext;
            NSEntityDescription *diningEntity = [NSEntityDescription entityForName:@"DiningHall" inManagedObjectContext:context];
            DiningHall* newDiningHall = [NSEntityDescription insertNewObjectForEntityForName:[diningEntity name] inManagedObjectContext:context];
            newDiningHall.name = [fileName stringByDeletingPathExtension];
            
            NSEntityDescription* subDiningEntity = [NSEntityDescription entityForName:@"SubRestaraunt" inManagedObjectContext:context];
            NSString* subRest = nil;
            SubRestaraunt* newSubRest;
            
            for (NSArray* i in westEndFoodArray)
            {
                if ([i count] != 4)
                    continue;
                int calories = [i[2] intValue];
                NSString* name = i[1];
                if ([name isEqualToString:@"Food"])
                    continue;
                NSLog(@"The calories in %@ is %d", name, calories);
                if (![subRest isEqualToString:i[0]])
                {
                    subRest = i[0];
                    newSubRest = [NSEntityDescription insertNewObjectForEntityForName:[subDiningEntity name] inManagedObjectContext:context];
                    newSubRest.name = subRest;
                    newSubRest.diningHall = newDiningHall;
                }
                FoodHolder* temp = [[FoodHolder alloc] init];
                temp.name = name;
                temp.calories = [NSNumber numberWithInt:calories];
                temp.url = i[3];
                temp.subRestaraunt = newSubRest;
                [self insertNewObject:temp];
            }                     

        }
    }    
}

- (void)insertNewObject:(FoodHolder*)sender
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    Food *newFood = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    newFood.name = sender.name;
    newFood.calories = sender.calories;
    newFood.url = sender.url;
    newFood.subRestaraunt = sender.subRestaraunt;
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        [_fetchedResultsController performFetch:nil];
        return _fetchedResultsController;
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
    if ([[aFetchedResultsController fetchedObjects] count] == 0)
    {
        _foodList = [NSEntityDescription insertNewObjectForEntityForName:@"DailyFoodList" inManagedObjectContext:self.managedObjectContext];
        _foodList.totalCalories = @0;
    }
    else
        _foodList = [aFetchedResultsController fetchedObjects][0];
    entity = nil;
    entity = [NSEntityDescription entityForName:@"Food" inManagedObjectContext:self.managedObjectContext];
    fetchRequest = nil;
    fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setFetchBatchSize:20];
    sortDescriptor = nil;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"calories" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    [fetchRequest setEntity:entity];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"foodList == %@", self.foodList];
    [fetchRequest setPredicate:predicate];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"subRestaraunt.diningHall" cacheName:@"dailyFoodCache"];
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FoodCell";
    
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
    
    
    if (!self.detailViewController) {
        self.detailViewController = [[VTNWebViewController alloc] initWithNibName:@"VTNWebView" bundle:nil];
    }
    Food *food = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    [self.detailViewController setFood:food];
    [self.detailViewController setFoodList:self.foodList];
    [self.navigationController pushViewController:self.detailViewController animated:YES];
     
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    NSArray* indexTitles = [self.fetchedResultsController sectionIndexTitles];
    if ([indexTitles count] < section + 1)
        return @"";
    else
        return indexTitles[section];
}


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.FoodListView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.FoodListView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.FoodListView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.FoodListView;
    
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
    [self.FoodListView endUpdates];
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
    cell.detailTextLabel.text = [[object valueForKey:@"calories"] stringValue];
}

@end
