//
//  AppDelegate.m
//  TABQY MENU
//
//  Created by ASK ONLINE  on 01/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import "AppDelegate.h"
#import "MVYSideMenuOptions.h"
#import "MVYSideMenuController.h"
#import "DS_SideMenuVC.h"
#import "ASK_HomeVC.h"
@interface AppDelegate ()
@property (nonatomic, retain) UIViewController * baseController;
@property (nonatomic, retain) UIViewController * splashScreenViewController;
@property (nonatomic, retain) NSString * launchUrl;
@property (assign) SEL callback;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.launchUrl = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    
    UIViewController *contentVC=[[ASK_HomeVC alloc]initWithNibName:@"ASK_HomeVC" bundle:nil];
    
    UIViewController *menuVC=[[DS_SideMenuVC alloc]initWithNibName:@"DS_SideMenuVC" bundle:nil];
    UINavigationController *contentNavigationController = [[UINavigationController alloc] initWithRootViewController:contentVC];
    [contentNavigationController setNavigationBarHidden:YES];
    
    
    MVYSideMenuOptions *options = [[MVYSideMenuOptions alloc] init];
    options.contentViewScale = 1.0;
    options.contentViewOpacity = 0.05;
    options.shadowOpacity = 0.0;
    self.sideMenuController = [[MVYSideMenuController alloc] initWithMenuViewController:menuVC
                                                                  contentViewController:contentNavigationController
                                                                                options:options];
    self.sideMenuController.menuFrame = CGRectMake(0, 0, 320.0, self.window.bounds.size.height);
    
    
    
    self.navigationController = [[UINavigationController alloc]initWithRootViewController:self.sideMenuController];
    sleep(0.05);
    [self.window setRootViewController:self.navigationController];
    
    //self.navigationController.navigationBar.hidden=YES;
    self.window.rootViewController = self.navigationController;
    [self.navigationController setNavigationBarHidden:YES];
    
    [self.window  makeKeyAndVisible];
    
    
    double delayInSeconds = 1.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        self.locationManager.distanceFilter = 100;
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        
        [self.locationManager startUpdatingLocation];
    });
    
    
       
   
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
