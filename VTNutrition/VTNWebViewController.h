//
//  VTNWebViewController.h
//  VTNutrition
//
//  Created by Robert Stephen Thompson on 3/27/13.
//  Copyright (c) 2013 ENGE 1104 W7G4. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTNWebViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSURL* url;
@end