//
//  WaiterProfileVC.m
//  TABQY MENU
//
//  Created by ASK ONLINE  on 18/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import "WaiterProfileVC.h"
#import "AppUserObject.h"
#import "UIExtensions.h"
#import "ECSServiceClass.h"
#import "ECSServiceClass.h"
#import "MBProgressHUD.h"
#import "ECSHelper.h"
@interface WaiterProfileVC ()
@property(weak,nonatomic)IBOutlet UIView *viewTop;
@property(weak,nonatomic)IBOutlet UILabel *lblName;
@property(weak,nonatomic)IBOutlet UILabel *lblDesignation;
@property(weak,nonatomic)IBOutlet UILabel *lblCode;
@property(weak,nonatomic)IBOutlet UILabel *lblTotalCost;
@property(weak,nonatomic)IBOutlet UIImageView *imgProfile;
@property(weak,nonatomic)IBOutlet UIImageView *restorentBGImage;

@end

@implementation WaiterProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *scrName=[NSString stringWithFormat:@"%@ Profile",self.appUserObject.resturantName];
    [self settingTopView:self.viewTop onController:self andTitle:scrName andImg:@"arrow-left.png.png"];
   // NSString *imgurl=[NSString stringWithFormat:@"%@%@",RESTORENTBGIMAGE,self.appUserObject.resturantBgImage];
    NSString *imgurl;
    NSString *selectedIp=[ECSUserDefault getStringFromUserDefaultForKey:@"ResetIP"];
    
    if (selectedIp.length) {
        imgurl=[NSString stringWithFormat:@"http://%@%@%@",selectedIp,RESTORENTBGIMAGE,self.appUserObject.resturantBgImage];
    }else{
        imgurl=[NSString stringWithFormat:@"http://%@%@%@",@"tabqy.com",RESTORENTBGIMAGE,self.appUserObject.resturantBgImage];
    }
    [self.restorentBGImage ecs_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         // [self.activityProfileImage stopAnimating];
     }];
    // Do any additional setup after loading the view from its nib.
    
    [self startServiceToGetProfile];
    
    
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)startServiceToGetProfile
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToGetProfile) withObject:nil];
    
    
}

-(void)serviceToGetProfile
{
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
    NSString *selectedIp=[ECSUserDefault getStringFromUserDefaultForKey:@"ResetIP"];
    if (selectedIp.length) {
        [class setServiceURL:[NSString stringWithFormat:@"http://%@%@myprofile",selectedIp,SERVERURLPATH]];
    }else{
        [class setServiceURL:[NSString stringWithFormat:@"http://%@%@myprofile",@"tabqy.com",SERVERURLPATH]];
    }
   // [class setServiceURL:[NSString stringWithFormat:@"%@myprofile",SERVERURLPATH]];
    //{"email":"deepak@askonlinesolutions.com"}
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          self.appUserObject.user_id, @"user_id",
                          nil];
    
    [class addJson:dict];
    [class setCallback:@selector(callBackServiceToGetProfile:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToGetProfile:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
     
        //http://webdevelopmentreviews.net/resturant/assets/uploads/empimage/user119.jpg
        
        NSArray *arr=[rootDictionary valueForKey:@"profile_detail"];
        for (NSDictionary * dictionary in arr)
        {
            NSString *empCode=[dictionary valueForKey:@"emp_code"];
            NSString *empImg=[dictionary valueForKey:@"profile_image"];
            
            NSString *userType=[dictionary valueForKey:@"user_type"];
            
            NSString *userName=[dictionary valueForKey:@"username"];
            
            self.lblName.text=userName;
            self.lblCode.text=empCode;
           
            self.lblDesignation.text=userType;
            //  NSString *imgurl=[NSString stringWithFormat:@"http://tabqy.com/resturant/assets/uploads/empimage/%@",empImg];
            NSString *imgurl;
            NSString *selectedIp=[ECSUserDefault getStringFromUserDefaultForKey:@"ResetIP"];
            
            if (selectedIp.length) {
                imgurl=[NSString stringWithFormat:@"http://%@%@%@",selectedIp,PROFILEIMG,empImg];
            }else{
                imgurl=[NSString stringWithFormat:@"http://%@%@%@",@"tabqy.com",PROFILEIMG,empImg];
            }

            
            
            [self.imgProfile ecs_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {
                 // [self.activityProfileImage stopAnimating];
             }];
        }
        NSString *totalcost=[rootDictionary valueForKey:@"total_cost"];
        self.lblTotalCost.text=[NSString stringWithFormat:@"%@ %.2f",self.appUserObject.resturantCurrency,totalcost.floatValue];
        
           // [ECSAlert showAlert:[rootDictionary objectForKey:@"msg"]];
        
    }
    else [ECSAlert showAlert:@"Server Issue."];
    
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
