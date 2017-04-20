//
//  ECSBaseViewController.h
//  TrustYoo
//
//  Created by Developer on 9/5/14.
//  Copyright (c) 2014 Shreesh Garg. All rights reserved.
//


//typedef enum
//{
//   NoApp, CHEApp, SEADRAGONSApp,NCSApp,NorwoodApp,CSYSApp
//
//}AppMode;



#import <UIKit/UIKit.h>
@class AppUserObject;
@class ECSBottomBar;
@class ECSTopBar;
@class AllMessage;
@class UsersDetails;
@interface ECSBaseViewController : UIViewController


@property float screenWidth;
@property float screenHeight;
@property BOOL isNetAvailable;
@property NSInteger pageSize;
@property NSInteger  pageNumber;
@property NSInteger  totalPages;
@property (nonatomic, retain) ECSTopBar * topBar;
@property (nonatomic, retain) ECSBottomBar * bottomBar;
@property (nonatomic, retain) AppUserObject * appUserObject;
@property (nonatomic, retain) UsersDetails * appUserDetail;
//@property AppMode appMode;

-(void)settingTopView:(UIView *)view onController:(UIViewController *)controller andTitle:(NSString *)title;
-(void)showNoInternetMessage;
-(void)settingTabView:(UIView *)view onController:(UIViewController *)controller andActiveIndex:(NSString *)index;
-(void)settingTopView:(UIView *)view onController:(UIViewController *)controller andTitle:(NSString *)title andImg:(NSString *)imgName;


@end
