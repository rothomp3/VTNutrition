//
//  VTNSecondViewController.h
//  VTNutrition
//
//  Created by Robert Stephen Thompson on 3/27/13.
//  Copyright (c) 2013 ENGE 1104 W7G4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTNSStringParsingExtensions.h"

@interface VTNSecondViewController : UIViewController <NSFetchedResultsControllerDelegate, UIAlertViewDelegate>
- (IBAction)parseFile:(UIButton *)sender;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
