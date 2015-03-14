//
//  NOSELAppDelegate.m
//  NOCircleSelector
//
//  Created by Natalia Osiecka on 30.9.2014.
//  Copyright (c) 2014 iOskApps. All rights reserved.
//

#import "NOSELAppDelegate.h"
#import "NOSELExampleViewController.h"
#import "NOSELAdvancedExampleViewController.h"

@interface NOSELAppDelegate ()

@end

@implementation NOSELAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // create the window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
    
    // create and push the controller
    UIViewController *viewController = [[NOSELExampleViewController alloc] init];
    UIViewController *easyViewController = [[NOSELAdvancedExampleViewController alloc] init];
    UITabBarController *tabbarController = [[UITabBarController alloc] init];
    [tabbarController setViewControllers:@[viewController, easyViewController]];
    [self.window setRootViewController:tabbarController];
    
    if ([self.window respondsToSelector:@selector(tintColor)]) {
        [self.window setTintColor:[UIColor redColor]];
        [tabbarController.tabBar setAlpha:0.5f];
    }
    
    // finish launching
    return YES;
}

@end
