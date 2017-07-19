//
//  LoginVC.m
//  TABQY MENU
//
//  Created by ASK ONLINE  on 01/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//
#import "ASK_HomeVC.h"
#import "LoginVC.h"
#import "ECSServiceClass.h"
#import "MBProgressHUD.h"
#import "AppUserObject.h"
#import "ECSHelper.h"
#import "UIExtensions.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "MVYSideMenuController.h"
#import "DS_SideMenuVC.h"
@interface LoginVC ()
{
    NSString *subscriptionKey;
}
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scroll_addContact;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UIView *vwUsername;
@property (weak, nonatomic) IBOutlet UIView *vwpassword;
@property (weak, nonatomic) IBOutlet UILabel *lblPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnSkip;
@property (nonatomic, retain) NSString * prefilledUsername;
@property (strong, nonatomic) IBOutlet UIView *vwForgetUsername;
@property (weak, nonatomic) IBOutlet UIButton *btnForgotPass;
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UIView *viewForgotPassword;
@property (strong, nonatomic) IBOutlet UIView *viewForSelectIp;
@property (weak, nonatomic) IBOutlet UITextField *txtResetIP;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.txtUserName setPadding];
     [self.txtPassword setPadding];
    
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
         [self startServiceToGetSubscription];
    }

}



+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)onClickLogin:(id)sender{
    if (self.txtUserName.text.length==0) {
        [ECSAlert showAlert:@"Please enter username."];
    }else if (self.txtPassword.text.length==0){
        [ECSAlert showAlert:@"Please enter password."];
    }else{
    [self startServiceToLogIn];
    }
    //[self login];
}

-(void)subscriberAlert{
    
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Info"
                                                                              message: @""
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Enter Subscription key";
        textField.textColor = [UIColor blackColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        // textField.borderStyle = UITextBorderStyleBezel;
    }];
    

    [alertController addAction:[UIAlertAction actionWithTitle:@"Subscribe" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * namefield = textfields[0];
        subscriptionKey=namefield.text;
       
        if (subscriptionKey.length)
        {
         
             [self startServiceToGetSubscription];
            
        }else{
        
   [[[UIAlertView alloc] initWithTitle:@"" message:@"Please enter subscription key." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
   
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 0) {
        [self subscriberAlert];
    }
}







-(void)startServiceToGetSubscription
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToGetSubscription) withObject:nil];
    
    
}

-(void)serviceToGetSubscription
{
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
   
        [class setServiceURL:[NSString stringWithFormat:@"%@",SUBSCRIPTION]];
 
    NSUUID *uuid = [NSUUID UUID];
    NSString *uuidString = uuid.UUIDString;
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          subscriptionKey, @"subscription_key",
                          uuidString, @"device_id",
                          nil];
    
    [class addJson:dict];
    [class setCallback:@selector(callBackServiceToGetSubscription:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToGetSubscription:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    
    NSLog(@"rootDictionary %@",rootDictionary);
    if(response.isValid)
    {
        NSString *status=[rootDictionary objectForKey:@"status"];
        if (status.boolValue ==true) {
            [ECSToast showToast:@"Subscribed Successfully " view:self.view];

            [ECSUserDefault saveString:[rootDictionary objectForKey:@"subscription_end_date"] ToUserDefaultForKey:@"subscription_end_date"];
            //{
         //   status = true;
          //  "subscription_end_date" = "2017-07-05";
       // }
            
        }else{
            [ECSToast showToast:[rootDictionary objectForKey:@"msg"] view:self.view];
            [self subscriberAlert];
            //[self resignFirstResponder];
        }
    }
    else{
        [self subscriberAlert];
       // [ECSAlert showAlert:@"Server Issue."];
    }
    
}

-(void)startServiceToLogIn
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToLogin) withObject:nil];
    
    
}

-(void)serviceToLogin
{
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
    NSString *selectedIp=[ECSUserDefault getStringFromUserDefaultForKey:@"ResetIP"];
    if (selectedIp.length) {
        [class setServiceURL:[NSString stringWithFormat:@"http://%@%@login",selectedIp,SERVERURLPATH]];
    }else{
        [class setServiceURL:[NSString stringWithFormat:@"http://%@%@login",@"tabqy.com",SERVERURLPATH]];
    }
    
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          self.txtUserName.text, @"username",
                          self.txtPassword.text, @"password",
                          nil];
    
    [class addJson:dict];
    [class setCallback:@selector(callBackServiceToGetLogin:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToGetLogin:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
        NSString *str=[rootDictionary objectForKey:@"status"];
        if (str.boolValue==true) {
            self.appUserObject = [AppUserObject instanceFromDictionary:[rootDictionary objectForKey:@"user_detail"]];
            if ([self.appUserObject.sidebarColor isEqualToString:@""]||self.appUserObject.sidebarColor==nil) {
                self.appUserObject.sidebarColor=@"#0294A5";
                self.appUserObject.sidebarActiveColor=@"#03353E";
            }
            
            [self.appUserObject saveToUserDefault];
            
            NSString *valueToSave = self.appUserObject.user_id;
            [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"useridsaved"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSLog(@" test==%@ ",self.appUserObject.sidebarColor);
            NSLog(@" testActive==%@ ",self.appUserObject.sidebarActiveColor);
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"LoginUpdate"
             object:  self.appUserObject];
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"LoginUpdateForSidemenu"
             object:  self.appUserObject];
             UIViewController * contentScreen = nil;
             contentScreen = (ASK_HomeVC *) [[ASK_HomeVC alloc]initWithNibName:@"ASK_HomeVC" bundle:nil];
            UIViewController *menuVC=[[DS_SideMenuVC alloc]initWithNibName:@"DS_SideMenuVC" bundle:nil];
                    MVYSideMenuOptions *options = [[MVYSideMenuOptions alloc] init];
                    options.contentViewScale = 1.0;
                    options.contentViewOpacity = 0.05;
                    options.shadowOpacity = 0.0;
            
                    MVYSideMenuController *sideMenuController = [[MVYSideMenuController alloc] initWithMenuViewController:menuVC contentViewController:contentScreen options:options];
                    sideMenuController.menuFrame = CGRectMake(0, 0, 320.0, self.view.bounds.size.height);
                    [self.navigationController pushViewController:sideMenuController animated:NO];
            
 
            
        }else{
            [ECSAlert showAlert:@"Server Error."];
        }
            }
    else [ECSAlert showAlert:@"Server Issue."];

}


-(IBAction)onClickForgotPassword:(id)sender{
    self.viewForgotPassword.hidden=NO;
    self.viewForgotPassword.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.viewForgotPassword];
}

-(IBAction)onClickForChangeIp:(id)sender{
    self.viewForSelectIp.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.txtResetIP.text=[ECSUserDefault getStringFromUserDefaultForKey:@"ResetIP"];
    self.viewForSelectIp.hidden=NO;
    [self.view addSubview:self.viewForSelectIp];
}


-(IBAction)onClickResetIp:(id)sender{
    [self.txtResetIP resignFirstResponder];
   
     [ECSUserDefault saveString:@"tabqy.com" ToUserDefaultForKey:@"ResetIP"];
      self.viewForSelectIp.hidden=YES;
}
-(IBAction)onClicksetIp:(id)sender{
     [self.txtResetIP resignFirstResponder];
     [ECSUserDefault saveString:self.txtResetIP.text ToUserDefaultForKey:@"ResetIP"];
     self.viewForSelectIp.hidden=YES;
}


-(IBAction)onClickSubmitForgotPassword:(id)sender{
    if (![self validateEmail:self.txtEmail.text]){
        
        [ECSAlert showAlert:@"Please enter a valid email address"];
        
    }else{
         [self startServiceToForgotPassword];
    }
   
}

-(BOOL)validateEmail:(NSString *)emailStr
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}
-(void)startServiceToForgotPassword
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToForgotPassword) withObject:nil];
    
}

-(void)serviceToForgotPassword
{
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
    NSString *selectedIp=[ECSUserDefault getStringFromUserDefaultForKey:@"ResetIP"];
    if (selectedIp.length) {
        [class setServiceURL:[NSString stringWithFormat:@"http://%@%@forgetpassword",selectedIp,SERVERURLPATH]];
    }else{
        [class setServiceURL:[NSString stringWithFormat:@"http://%@%@forgetpassword",@"tabqy.com",SERVERURLPATH]];
    }
   // [class setServiceURL:[NSString stringWithFormat:@"%@forgetpassword",SERVERURLPATH]];
    //{"email":"deepak@askonlinesolutions.com"}
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          self.txtEmail.text, @"email",
                          nil];
    
    [class addJson:dict];
    [class setCallback:@selector(callBackServiceToGetForgotPassword:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToGetForgotPassword:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
        
        if ([[rootDictionary objectForKey:@"msg"] isEqualToString:@"Your password has been changed successfully."]) {
         
             self.viewForgotPassword.hidden=YES;
             [ECSAlert showAlert:[rootDictionary objectForKey:@"msg"]];
        }else{
            [ECSAlert showAlert:[rootDictionary objectForKey:@"msg"]];
        }
    }
    else [ECSAlert showAlert:@"Server Issue."];
    
}

-(IBAction)hideForgotView:(id)sender{
    self.viewForSelectIp.hidden=YES;
    self.viewForgotPassword.hidden=YES;
}



@end
