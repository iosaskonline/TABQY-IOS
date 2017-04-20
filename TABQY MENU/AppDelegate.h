//
//  AppDelegate.h
//  TABQY MENU
//
//  Created by ASK ONLINE  on 01/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ASK_HomeVC.h"
#import <MapKit/MapKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
@class MVYSideMenuController;
@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

-(void)getCurrentLocation:(UIViewController *)controller withCallback:(SEL)callBack;

@property (strong, nonatomic) UIWindow *window;
@property(strong, nonatomic)  MVYSideMenuController *sideMenuController;
@property (strong, nonatomic) id observer;

@property (nonatomic, retain) NSString * appUserCity;
@property (nonatomic, retain) NSString * appUserState;

@property (nonatomic, retain) UINavigationController * navigationController;
@property (strong,nonatomic)  ASK_HomeVC *ceterViewController;


@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *currentLocationPoint;
@property (nonatomic, retain) NSString * currentCity;
@end
