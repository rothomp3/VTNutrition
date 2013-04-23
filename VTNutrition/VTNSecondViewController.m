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
        self.title = NSLocalizedString(@"Second", @"Second");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Food" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"calories" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
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
@end
