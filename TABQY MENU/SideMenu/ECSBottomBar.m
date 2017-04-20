//
//  ECSBottomBar.m
//  TrustYoo
//
//  Created by Developer on 9/4/14.
//  Copyright (c) 2014 Shreesh Garg. All rights reserved.
//

#define COLOR_SELECTED_GREEN [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]


#import "ECSBottomBar.h"
#import "UIExtensions.h"
#import "ECSHelper.h"
#import "ECSAppHelper.h"
//#import "DS_HomeScreen.h"
//#import "DS_RegisterScreen.h"
//#import "DS_NotificationScreen.h"
//#import "DS_NewDealScreen.h"
//#import "DS_AccountScreen.h"
//#import "DS_LoginScreen.h"
//#import "AppUserObject.h"
#import "DS_SideMenuVC.h"



@interface ECSBottomBar ()
@property (nonatomic, retain) NSString *index;
@property (nonatomic, retain) UIViewController *controller;
@property (weak, nonatomic) IBOutlet UIButton *btnHome;
@property (weak, nonatomic) IBOutlet UIButton *btnNotification;
@property (weak, nonatomic) IBOutlet UIButton *btnAccount;
@property (weak, nonatomic) IBOutlet UIButton *btnNewDeals;


@property (weak, nonatomic) IBOutlet UILabel *lblHome;
@property (weak, nonatomic) IBOutlet UILabel *lblNotification;
@property (weak, nonatomic) IBOutlet UILabel *lblAccount;
@property (weak, nonatomic) IBOutlet UILabel *lblNewDeals;


//@property (strong, nonatomic) DS_HomeScreen  *homeScreen;
//@property (strong, nonatomic) DS_LoginScreen  *registrationScreen;
//@property (strong, nonatomic) DS_AccountScreen  *accountScreen;
//@property (strong, nonatomic) DS_NotificationScreen  *notificationScreen;
//@property (strong, nonatomic) DS_NewDealScreen  *dealScreen;



- (IBAction)clickForHome:(id)sender;
- (IBAction)clickForNotification:(id)sender;
- (IBAction)clickForAccount:(id)sender;
- (IBAction)clickForNewDeals:(id)sender;



@end

@implementation ECSBottomBar
-(id)initWithController:(UIViewController *)control andActiveStatus:(NSString *)ind
{
    self=[self initWithNibName:@"ECSBottomBar" bundle:nil];
    self.controller=control;
    self.index=ind;
    return self;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    //UIColor * selectedColor = [UIColor blackColor];
    
    UIColor * selectedColor = [UIColor colorWithR:200 G:200 B:200];
    
    
   
    if(self.index.integerValue == 1)
    {
        [self.btnHome setBackgroundColor:selectedColor];
    }
    else if(self.index.integerValue == 2)
    {
        [self.btnNotification setBackgroundColor:selectedColor];
    }
    else if(self.index.integerValue == 3)
    {
      [self.btnAccount setBackgroundColor:selectedColor];
    }
    else if(self.index.integerValue == 4)
    {
       [self.btnNewDeals setBackgroundColor:selectedColor];
    }
    
}


-(void)viewDidAppear:(BOOL)animated
{

    
}


-(void)makeBottomButtonResizable
{
    UIImage * active = [UIImage imageWithName:@"btm_home.png"];
   
    
     self.btnAccount.imageEdgeInsets = UIEdgeInsetsMake(0, (self.btnAccount.frame.size.width - active.size.width)/2, 0, (self.btnAccount.frame.size.width - active.size.width)/2);
     self.btnHome.imageEdgeInsets = UIEdgeInsetsMake(0, (self.btnHome.frame.size.width - active.size.width)/2, 0, (self.btnHome.frame.size.width - active.size.width)/2);
    
     self.btnNotification.imageEdgeInsets = UIEdgeInsetsMake(0, (self.btnNotification.frame.size.width - active.size.width)/2, 0, (self.btnNotification.frame.size.width - active.size.width)/2);
     self.btnNewDeals.imageEdgeInsets = UIEdgeInsetsMake(0, (self.btnNewDeals.frame.size.width - active.size.width)/2, 0, (self.btnNewDeals.frame.size.width - active.size.width)/2);
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)clickForHome:(id)sender
{
    if([self.controller canPerformAction:@selector(homeClicked:) withSender:sender])
    {
        [self.controller performSelector:@selector(homeClicked:) withObject:sender];
    }
    else
    {
//        self.homeScreen = [[DS_HomeScreen alloc]initWithNibName:@"DS_HomeScreen" bundle:nil];
//         UIViewController *menuVC=[[DS_SideMenuVC alloc]initWithNibName:@"DS_SideMenuVC" bundle:nil];
//        [ECSAppHelper setRootViewController:self.homeScreen withLeftController:menuVC];
    
    }


}
- (IBAction)clickForNotification:(id)sender{

    
    return;
    if([self.controller canPerformAction:@selector(notificationClicked:) withSender:sender])
    {
        [self.controller performSelector:@selector(notificationClicked:) withObject:sender];
   
    }
    else
    {
//        self.notificationScreen= [[DS_NotificationScreen alloc]initWithNibName:@"DS_NotificationScreen" bundle:nil];
//        [ECSAppHelper setRootViewController:self.notificationScreen withLeftController:nil];
//   
        
    }

}
- (IBAction)clickForAccount:(id)sender{


    if([self.controller canPerformAction:@selector(accountClicked:) withSender:sender])
    {
        [self.controller performSelector:@selector(accountClicked:) withObject:sender];

    }
    else
    {
        
//        if([AppUserObject getFromUserDefault] == nil)
//        {
////            DS_AccountScreen * accountScreen = [[DS_AccountScreen alloc]initWithNibName:@"DS_AccountScreen" bundle:nil];
////            self.registrationScreen = [[DS_LoginScreen alloc]initWithAfterLoginController:accountScreen andMenuViewController:nil];
////            [ECSAppHelper setRootViewController:self.registrationScreen withLeftController:nil];
////
//        
//        }
//        else
//        {
//        //accountScreen
//            
////            self.accountScreen = [[DS_AccountScreen alloc]initWithNibName:@"DS_AccountScreen" bundle:nil];
////            [ECSAppHelper setRootViewController:self.accountScreen withLeftController:nil];
////        
//        
//        }
        
    }
}
- (IBAction)clickForNewDeals:(id)sender{



    if([self.controller canPerformAction:@selector(dealsClicked:) withSender:sender])
    {
        [self.controller performSelector:@selector(dealsClicked:) withObject:sender];

    }
    else
    {
        UIViewController *menuVC=[[DS_SideMenuVC alloc]initWithNibName:@"DS_SideMenuVC" bundle:nil];
//        self.dealScreen = [[DS_NewDealScreen alloc]initWithNibName:@"DS_NewDealScreen" bundle:nil];
//        [ECSAppHelper setRootViewController:self.dealScreen withLeftController:menuVC];
//
    }
}


// Dummy Methods

-(void)homeClicked:(id)sender{};
-(void)notificationClicked:(id)sender{};
-(void)accountClicked:(id)sender{};
-(void)dealsClicked:(id)sender{};






@end
