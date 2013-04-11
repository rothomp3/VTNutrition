//
//  VTNSecondViewController.m
//  VTNutrition
//
//  Created by Robert Stephen Thompson on 3/27/13.
//  Copyright (c) 2013 ENGE 1104 W7G4. All rights reserved.
//

#import "VTNSecondViewController.h"

@interface VTNSecondViewController ()

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
    NSURL *csvURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]  URLByAppendingPathComponent:@"WestEnd.csv"];
    NSString* csvString = [NSString stringWithContentsOfURL:csvURL encoding:NSUTF8StringEncoding error:nil];
    NSArray* westEndFoodArray = [csvString csvRows];
    
    for (NSArray* i in westEndFoodArray)
    {
        int calories = [i[2] intValue];
        NSString* name = i[1];
        
        NSLog(@"The calories in %@ is %d", name, calories);
    }
}
@end
