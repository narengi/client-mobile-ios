//
//  AppDelegate.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 11/2/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

{
    id services_;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"Farsi" forKey:@"Language"];
    [GMSServices provideAPIKey:@"AIzaSyA4nLUSU6-DrxN51XV06Vhmojw6SosMFoI"];
    [self initNavigationBarTheme];
    
    [SVProgressHUD setFont:[UIFont fontWithName:@"IRANSansMobileFaNum" size:11]];
    [SVProgressHUD setBackgroundColor:RGB(248, 248, 248, 1)];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"fuckingLoginedOrNOT"];
    


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



-(void)initNavigationBarTheme{
    
    [[UINavigationBar appearance] setBarTintColor: [UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor blackColor], NSForegroundColorAttributeName,
      [UIFont fontWithName:@"IRANSansMobileFaNum-Medium" size:15.0], NSFontAttributeName,nil]];
    
   
    
}

@end
