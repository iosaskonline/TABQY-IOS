//
//  ECSBaseViewController.m
//  TrustYoo
//
//  Created by Developer on 9/5/14.
//  Copyright (c) 2014 Shreesh Garg. All rights reserved.
//

#import "ECSBaseViewController.h"
//#import "Reachability.h"
#import "AppUserObject.h"
#import "ECSBottomBar.h"
#import "UIExtensions.h"
#import "ECSTopBar.h"
#import "ECSHelper.h"
@interface ECSBaseViewController ()
-(void)reachabilityChanged:(NSNotification*)note;
//@property(strong) Reachability * internetConnectionReach;
@end

@implementation ECSBaseViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)settingTopView:(UIView *)view onController:(UIViewController *)controller andTitle:(NSString *)title andImg:(NSString *)imgName
{
    self.topBar = (ECSTopBar *)[[ECSTopBar alloc]initWithController:controller withTitle:title withImage:imgName ];
    
    [view addSubview:self.topBar.view];
}

//-(void)settingTopView:(UIView *)view onController:(UIViewController *)controller andTitle:(NSString *)title
//{
//    self.topBar = (ECSTopBar *)[[ECSTopBar alloc]initWithController:controller withTitle:title];
//    
//    [view addSubview:self.topBar.view];
//}
//
//-(void)settingTopView:(UIView *)view onController:(UIViewController *)controller andTitle:(NSString *)headerTitle withButton:(BOOL)isVisible withButtonTitle:(NSString *)buttonTitle withButtonImage:(NSString *)buttonBackgroundImage withoutBackButton:(BOOL)isHidden
//{
//    self.topBar = (ECSTopBar *)[[ECSTopBar alloc]initWithController:controller withTitle:headerTitle withButton:isVisible withButtonTitle:buttonTitle withButtonImage:buttonBackgroundImage withoutBackButton:isHidden];
//    
//    [view addSubview:self.topBar.view];
//}
//

-(void)settingTabView:(UIView *)view onController:(UIViewController *)controller andActiveIndex:(NSString *)index
{
    self.bottomBar = [[ECSBottomBar alloc]initWithController:controller andActiveStatus:index];
    [view addSubview:self.bottomBar.view];
}


//-(void)viewDidAppear:(BOOL)animated
//{
//
//    [super viewDidAppear:animated];
//    [self.bottomBar makeBottomButtonResizable];
//    if([self canPerformAction:@selector(keyboardWillShow:) withSender:nil])
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    
//    if([self canPerformAction:@selector(keyboardWillHide:) withSender:nil])
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//}
//
//
//-(void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//     [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//     [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//
//}



- (void)viewDidLoad
{
    
    [super viewDidLoad];
    //[[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor colorWithR:17 G:50 B:95]];
    self.screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
    self.appUserObject = [AppUserObject getFromUserDefault];
   // self.appUserDetail=[UsersDetails getFromUserDefault];
    self.pageNumber = 1;
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithHexString:@"1ba8e2"]];

    [self setNeedsStatusBarAppearanceUpdate];
    
    
//#ifdef CHE
//    self.appMode = CHEApp;
//#elif SEADRAGONS
//    self.appMode = SEADRAGONSApp;
//#elif NCS
//    self.appMode = NCSApp;
//#elif Norwood
//    self.appMode = NorwoodApp;
//#elif CSYS
//    self.appMode = CSYSApp;
//#endif
//    
    
    
    
}

//-(void)registerInternetNotifier
//{
//    self.isNetAvailable = YES;
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(reachabilityChanged:)
//                                                 name:kReachabilityChangedNotification
//                                               object:nil];
//    self.internetConnectionReach = [Reachability reachabilityForInternetConnection];
//    __weak __block typeof(self) weakself = self;
//    
//    self.internetConnectionReach.reachableBlock = ^(Reachability * reachability)
//    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            weakself.isNetAvailable = YES;
//        });
//    };
//    
//    self.internetConnectionReach.unreachableBlock = ^(Reachability * reachability)
//    {
//        weakself.isNetAvailable = NO;
//    };
//    [self.internetConnectionReach startNotifier];
//}
//
//
//-(void)reachabilityChanged:(NSNotification*)note
//{
//    Reachability * reach = [note object];
//    if (reach == self.internetConnectionReach)
//    {
//        if([reach isReachable])
//        {
//            // Reachable
//            self.isNetAvailable = YES;
//        
//        }
//        else
//        {
//            [self showNoInternetMessage];
//            self.isNetAvailable = NO;
//        }
//    }
//    
//}


-(void)showNoInternetMessage
{
    //[[iToast makeText:@"Unable to connect to server.Please check your network connection."]show];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
