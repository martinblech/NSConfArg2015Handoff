//
//  AppDelegate.m
//  NSConfArg2015Handoff
//
//  Created by Martín Blech on 2/4/15.
//  Copyright (c) 2015 Martin Blech. All rights reserved.
//

#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Handoff

- (BOOL)application:(UIApplication *)application willContinueUserActivityWithType:(NSString *)userActivityType
{
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    if ([userActivityType isEqual:@"com.martinblech.NSConfArg2015Handoff.browsing-location"]) {
        tabBarController.selectedIndex = 0;
    } else if ([userActivityType isEqual:@"com.martinblech.NSConfArg2015Handoff.browsing-talks"]){
        tabBarController.selectedIndex = 1;
    }
    [MBProgressHUD showHUDAddedTo:self.window.rootViewController.view animated:YES];
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *))restorationHandler
{
    NSUInteger index = NSNotFound;
    if ([userActivity.activityType isEqual:@"com.martinblech.NSConfArg2015Handoff.browsing-location"]) {
        index = 0;
    } else if ([userActivity.activityType isEqual:@"com.martinblech.NSConfArg2015Handoff.browsing-talks"]){
        index = 1;
    } else if ([userActivity.activityType isEqual:NSUserActivityTypeBrowsingWeb]) {
        NSLog(@"continuing from browser: %@", userActivity.webpageURL);
        NSString *urlString = userActivity.webpageURL.absoluteString;
        if ([urlString hasSuffix:@"#ubicacion"]) {
            NSLog(@"was browsing location");
            index = 0;
        } else if ([urlString hasSuffix:@"#programa"]) {
            NSLog(@"was browsing talks");
            index = 1;
        } else {
            NSLog(@"was browsing something else");
        }
    }
    [MBProgressHUD hideAllHUDsForView:self.window.rootViewController.view animated:YES];
    if (index != NSNotFound) {
        UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
        tabBarController.selectedIndex = index;
        restorationHandler(@[ tabBarController.viewControllers[index] ]);
        return YES;
    }
    return NO;
}

@end
