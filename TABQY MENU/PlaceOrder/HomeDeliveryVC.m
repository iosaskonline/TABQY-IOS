//
//  HomeDeliveryVC.m
//  TABQY MENU
//
//  Created by ASK ONLINE  on 14/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import "HomeDeliveryVC.h"
#import "ECSHelper.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "MBProgressHUD.h"
#import "AppUserObject.h"
#import "ECSServiceClass.h"
#import "UIExtensions.h"
@interface HomeDeliveryVC ()
@property(weak,nonatomic)IBOutlet UIView *viewTop;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scroll_addContact;
@property(weak,nonatomic)IBOutlet UIImageView *restorentBGImage;
@property(weak,nonatomic)IBOutlet UITextField *txtOrderId;
@property(weak,nonatomic)IBOutlet UITextField *txtDate;
@property(weak,nonatomic)IBOutlet UITextField *txtTime;
@property(weak,nonatomic)IBOutlet UITextField *txtCusName;
@property(weak,nonatomic)IBOutlet UITextField *txtCusPh;
@property(weak,nonatomic)IBOutlet UITextField *txtCusAdd;
@property(weak,nonatomic)IBOutlet UITextField *txtTotalCast;


@end

@implementation HomeDeliveryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingTopView:self.viewTop onController:self andTitle:[NSString stringWithFormat:@"%@ Home Delivery",self.appUserObject.resturantName] andImg:@"arrow-left.png"];
    NSString *imgurl=[NSString stringWithFormat:@"%@%@",RESTORENTBGIMAGE,self.appUserObject.resturantBgImage];
    [self.restorentBGImage ecs_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         // [self.activityProfileImage stopAnimating];
     }];
    
    // self.scroll_addContact.contentSize = CGSizeMake(self.scroll_addContact.frame.size.width, 1000);
    
    
    NSLog(@"dict %@",_dict);
    self.txtDate.text=[_dict valueForKey:@"order_date"];
    self.txtTime.text=[self.dict valueForKey:@"order_time"];
    self.txtOrderId.text=[self.dict valueForKey:@"order_no"];
    self.txtTotalCast.text=[self.dict valueForKey:@"total_cost"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(IBAction)onClickSubmitHomeDeliveryOrder:(id)sender{
    if (self.txtCusName.text.length<=0) {
           [ECSToast showToast:@"Please enter customer name." view:self.view];
    }else if(self.txtCusAdd.text.length<=0){
         [ECSToast showToast:@"Please enter customer address." view:self.view];
    }
    else if( !(self.txtCusPh.text.length==10)){
        [ECSToast showToast:@"Please enter customer  valid Ph. number." view:self.view];
    }else
    [self startServiceToGetCustomerDetail];
    
}

-(void)startServiceToGetCustomerDetail
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToGetCustomerDetail) withObject:nil];
    
    
}

-(void)serviceToGetCustomerDetail
{
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
    
    [class setServiceURL:[NSString stringWithFormat:@"%@customer_information",SERVERURLPATH]];
   
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                 self.txtOrderId.text, @"order_no",
                                 self.txtDate.text, @"order_date",
                                 self.txtTime.text, @"order_time",
                                 self.txtCusName.text, @"customer_name",
                                 self.txtCusAdd.text, @"customer_address",
                                 self.txtCusPh.text, @"phone_no",
                                 self.txtTotalCast.text, @"totalcost",
                                 nil];
    
    
    
    [class addJson:dict];
    [class setCallback:@selector(callBackServiceToGetCustomerDetail:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToGetCustomerDetail:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
        [self removeAllSaveData];
        [ECSToast showToast:[rootDictionary valueForKey:@"msg"] view:self.view];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else [ECSAlert showAlert:@"Error!"];
    
}
-(void)removeAllSaveData{
    NSMutableArray *oldFoodid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"oldFoodId"] mutableCopy];
    NSArray *ooldFoodid = [[NSSet setWithArray:oldFoodid] allObjects];
    for (int i=0; i<ooldFoodid.count; i++) {
        NSString *key=[NSString stringWithFormat:@"placeOrder%@",[ooldFoodid objectAtIndex:i]];
        [ECSUserDefault RemoveObjectFromUserDefaultForKey:key];
    }
    [ECSUserDefault RemoveObjectFromUserDefaultForKey:@"oldFoodId"];
    
}


@end
