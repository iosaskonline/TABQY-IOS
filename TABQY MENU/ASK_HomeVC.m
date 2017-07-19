//
//  ASK_HomeVC.m
//  TABQY MENU
//
//  Created by ASK ONLINE  on 01/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import "ASK_HomeVC.h"

#import "MVYSideMenuController.h"
#import "DS_SideMenuVC.h"
#import "LoginVC.h"
 #import "AppUserObject.h"
#import "UIExtensions.h"
#import "ECSServiceClass.h"
#import "MenuItemVC.h"
#import "ECSHelper.h"
#import "UIExtensions.h"
#import "MBProgressHUD.h"
#import "OrderHistryVC.h"
#import "OrderProgressVC.h"
#import "HotDealVC.h"
#import "FeedBackVC.h"
#import "TodaySplVC.h"
#import "PlaceOrderVC.h"
#import "SearchFoodVC.h"
#import "CompleteOrderVC.h"
@interface ASK_HomeVC (){
    NSString *restaurentId;
   
}
@property(strong,nonatomic)IBOutlet UIButton *btnMenu;
@property(strong,nonatomic)IBOutlet UIButton *btnSpl;
@property(strong,nonatomic)IBOutlet UIButton *btnHotDeal;
@property(strong,nonatomic)IBOutlet UIButton *btnOrderInProgress;
@property(strong,nonatomic)IBOutlet UIButton *btnorderHistry;
@property(strong,nonatomic)IBOutlet UIButton *btnfeedback;
@property(weak,nonatomic)IBOutlet UIView *viewTop;
@property(weak,nonatomic)IBOutlet UIImageView *imglogo;
@property(weak,nonatomic)IBOutlet UIImageView *restorentBGImage;
@property(weak,nonatomic)IBOutlet UILabel *lblHeader;
@end

@implementation ASK_HomeVC

- (void)viewDidLoad {
       [super viewDidLoad];
    if (self.appUserObject==nil) {
        LoginVC *login=[[LoginVC alloc]initWithNibName:@"LoginVC" bundle:nil];
        [self.navigationController pushViewController:login animated:NO];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateAction:)
                                                 name:@"LoginUpdate"
                                               object:nil];
     NSString *scrName=[NSString stringWithFormat:@"%@ Dashbord",self.appUserObject.resturantName];
  [self settingTopView:self.viewTop onController:self andTitle:scrName andImg:@"nav_header_icon.png"];
    //@"restorentgp.jpg"
    UIImage *img=[UIImage imageWithName:@"restorentgp.jpg"];
   // NSString *imgurl=[NSString stringWithFormat:@"%@%@",RESTORENTBGIMAGE,self.appUserObject.resturantBgImage];
    NSString *imgurl;
    NSString *selectedIp=[ECSUserDefault getStringFromUserDefaultForKey:@"ResetIP"];
    
    if (selectedIp.length) {
        imgurl=[NSString stringWithFormat:@"http://%@%@%@",selectedIp,RESTORENTBGIMAGE,self.appUserObject.resturantBgImage];
    }else{
        imgurl=[NSString stringWithFormat:@"http://%@%@%@",@"tabqy.com",RESTORENTBGIMAGE,self.appUserObject.resturantBgImage];
    }
    
    [self.restorentBGImage ecs_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:img options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         
     }];
    
    NSString *endDate=[ECSUserDefault getStringFromUserDefaultForKey:@"subscription_end_date"];
    NSLog(@"endDate %@",endDate);
    
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:endDate];
    
    
    NSInteger t=[ECSDate daysBetweenDate:[NSDate date] andDate:date];
    NSLog(@"jhfewijdf %ld",(long)t);
    if (t>0) {
        NSLog(@"already subscribed");
    }else{
        if (self.appUserObject.resturantId) {
          
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Info"
                                                            message:@"Subscription Expired!"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Ok", nil];
        [alertView show];
//
        }
    }

}
- (void)updateAction:(NSNotification *) notification
{
    //NSLog(@"fdgfgrf%@",notification.object);
    AppUserObject *userData=notification.object;
    NSString *scrName=[NSString stringWithFormat:@"%@ Dashbord",userData.resturantName];
    [self settingTopView:self.viewTop onController:self andTitle:scrName andImg:@"nav_header_icon.png"];

    if (userData.resturantBgImage ==(id)[NSNull null] ||[userData.resturantBgImage isEqualToString:@""]) {
        NSLog(@"ttt %@",self.appUserObject.resturantLogo);
        
        
    }else{
        //NSString *imgurl=[NSString stringWithFormat:@"%@%@",RESTORENTBGIMAGE,userData.resturantBgImage];
        NSString *imgurl;
        NSString *selectedIp=[ECSUserDefault getStringFromUserDefaultForKey:@"ResetIP"];
        
        if (selectedIp.length) {
            imgurl=[NSString stringWithFormat:@"http://%@%@%@",selectedIp,RESTORENTBGIMAGE,userData.resturantBgImage];
        }else{
            imgurl=[NSString stringWithFormat:@"http://%@%@%@",@"tabqy.com",RESTORENTBGIMAGE,userData.resturantBgImage];
        }
        [self.restorentBGImage ecs_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             // [self.activityProfileImage stopAnimating];
         }];
        
        
    }
    if (userData.resturantId) {
        restaurentId=userData.resturantId;
        [self startServiceToGetTaxType];
    }
    
    
   
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 0) {
        LoginVC *login=[[LoginVC alloc]initWithNibName:@"LoginVC" bundle:nil];
        [self.navigationController pushViewController:login animated:NO];
    }
}
-(void)viewWillAppear:(BOOL)animated{
       [self.btnfeedback setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
     [self.btnorderHistry setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
     [self.btnOrderInProgress setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
     [self.btnHotDeal setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
     [self.btnSpl setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
     [self.btnMenu setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickToOpenMenu:(id)sender {
    
   
    MVYSideMenuController *sideMenuController = [self sideMenuController];
  //  DS_SideMenuVC * vc = (DS_SideMenuVC *)sideMenuController.menuViewController;
    
    if (sideMenuController) {
        [sideMenuController openMenu];
    }
    
}
-(void)openSideMenuButtonClicked:(UIButton *)sender{
  
    MVYSideMenuController *sideMenuController = [self sideMenuController];
    //  DS_SideMenuVC * vc = (DS_SideMenuVC *)sideMenuController.menuViewController;
    NSLog(@" test==%@ ",self.appUserObject.sidebarColor);
    NSLog(@" testActive==%@ ",self.appUserObject.sidebarActiveColor);
    if (sideMenuController) {
    
         [sideMenuController openMenu];
    }
    
}

-(IBAction)onclickMenu:(id)sender{
    self.btnMenu.hidden=NO;
     [self.btnMenu setBackgroundImage:[UIImage imageNamed:@"dashboard_hover_Icon.png"] forState:UIControlStateNormal];
    MenuItemVC *menuVC=[[MenuItemVC alloc]initWithNibName:@"MenuItemVC" bundle:nil];
    [self.navigationController pushViewController:menuVC animated:YES];
}


-(IBAction)onclickTodaySpl:(id)sender{
    self.btnSpl.hidden=NO;
    [self.btnSpl setBackgroundImage:[UIImage imageNamed:@"dashboard_hover_Icon.png"] forState:UIControlStateNormal];
    TodaySplVC *spl=[[TodaySplVC alloc ]initWithNibName:@"TodaySplVC" bundle:nil];
    [self.navigationController pushViewController:spl animated:YES];
}
-(IBAction)onclickHotDeal:(id)sender{
    self.btnHotDeal.hidden=NO;
    [self.btnHotDeal setBackgroundImage:[UIImage imageNamed:@"dashboard_hover_Icon.png"] forState:UIControlStateNormal];
    
    HotDealVC *spl=[[HotDealVC alloc ]initWithNibName:@"HotDealVC" bundle:nil];
    [self.navigationController pushViewController:spl animated:YES];
    
}
-(IBAction)onclickOrderProgress:(id)sender{
    self.btnOrderInProgress.hidden=NO;
    [self.btnOrderInProgress setBackgroundImage:[UIImage imageNamed:@"dashboard_hover_Icon.png"] forState:UIControlStateNormal];
    
    OrderProgressVC *spl=[[OrderProgressVC alloc ]initWithNibName:@"OrderProgressVC" bundle:nil];
    [self.navigationController pushViewController:spl animated:YES];
}
-(IBAction)onclickOrderHistry:(id)sender{
    self.btnorderHistry.hidden=NO;
    [self.btnorderHistry setBackgroundImage:[UIImage imageNamed:@"dashboard_hover_Icon.png"] forState:UIControlStateNormal];
    
    OrderHistryVC *spl=[[OrderHistryVC alloc ]initWithNibName:@"OrderHistryVC" bundle:nil];
    [self.navigationController pushViewController:spl animated:YES];
}
-(IBAction)onclickFeedBack:(id)sender{
    
    self.btnfeedback.hidden=NO;
    [self.btnfeedback setBackgroundImage:[UIImage imageNamed:@"dashboard_hover_Icon.png"] forState:UIControlStateNormal];
    
    FeedBackVC *spl=[[FeedBackVC alloc ]initWithNibName:@"FeedBackVC" bundle:nil];
    [self.navigationController pushViewController:spl animated:YES];
}


-(void)clickToPlaceOrderList:(id)sender{

    UIViewController *nav=nil;
    NSString *orderNum=[ECSUserDefault getStringFromUserDefaultForKey:@"orderNum"];
    if (orderNum.length>1) {
        CompleteOrderVC *new=[[CompleteOrderVC alloc]init];
        nav = new;
        
        new.selectedOrder=orderNum;
        
    }else{
        nav=[[PlaceOrderVC alloc]initWithNibName:@"PlaceOrderVC" bundle:nil];
    }
    
    
    
    [self.navigationController pushViewController:nav animated:YES];
    
    

}


-(void)startServiceToGetTaxType
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToGetTaxType) withObject:nil];
    
    
}

-(void)serviceToGetTaxType
{
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
    NSString *selectedIp=[ECSUserDefault getStringFromUserDefaultForKey:@"ResetIP"];
    if (selectedIp.length) {
        [class setServiceURL:[NSString stringWithFormat:@"http://%@%@tax_management",selectedIp,SERVERURLPATH]];
    }else{
        [class setServiceURL:[NSString stringWithFormat:@"http://%@%@tax_management",@"tabqy.com",SERVERURLPATH]];
    }
   // [class setServiceURL:[NSString stringWithFormat:@"%@tax_management",SERVERURLPATH]];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          restaurentId, @"resturant_id",
                          nil];
    
    [class addJson:dict];
    [class setCallback:@selector(callBackServiceToGetTaxType:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToGetTaxType:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {

       
        NSArray *arr=[rootDictionary valueForKey:@"tax_type"];
        [[NSUserDefaults standardUserDefaults]setObject:arr forKey:@"tax_type"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        for (NSDictionary * dictionary in arr)
        {
            NSString *taxName=[dictionary valueForKey:@"tax_name"];
            NSString *taxValue=[dictionary valueForKey:@"tax_value"];
            
            
            [[NSUserDefaults standardUserDefaults]setObject:taxName forKey:@"tax_name"];
             [[NSUserDefaults standardUserDefaults]setObject:taxValue forKey:@"tax_value"];
            [[NSUserDefaults standardUserDefaults]synchronize];

        }

    }
    else [ECSAlert showAlert:@"Server Issue."];
    
}




- (void)clickToOpenSearch:(id)sender{
    
    SearchFoodVC *spl=[[SearchFoodVC alloc ]initWithNibName:@"SearchFoodVC" bundle:nil];
    [self.navigationController pushViewController:spl animated:YES];

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
