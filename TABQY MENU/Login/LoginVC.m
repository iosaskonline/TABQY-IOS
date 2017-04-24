//
//  LoginVC.m
//  TABQY MENU
//
//  Created by ASK ONLINE  on 01/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import "LoginVC.h"
#import "ECSServiceClass.h"
#import "MBProgressHUD.h"
#import "AppUserObject.h"
#import "ECSHelper.h"
#import "UIExtensions.h"
#import "TPKeyboardAvoidingScrollView.h"
@interface LoginVC ()
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

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.txtUserName setPadding];
     [self.txtPassword setPadding];
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)onClickLogin:(id)sender{
    [self startServiceToLogIn];
    //[self login];
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
    
    [class setServiceURL:[NSString stringWithFormat:@"%@login",SERVERURLPATH]];
    
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
        
        if ([[rootDictionary objectForKey:@"msg"] isEqualToString:@"Successfully LoggedIn"]) {
            self.appUserObject = [AppUserObject instanceFromDictionary:[rootDictionary objectForKey:@"user_detail"]];
            
            [self.appUserObject saveToUserDefault];
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"LoginUpdate"
             object:  self.appUserObject];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [ECSAlert showAlert:[rootDictionary objectForKey:@"msg"]];
        }
            }
    else [ECSAlert showAlert:@"Error!"];

}


-(IBAction)onClickForgotPassword:(id)sender{
    self.viewForgotPassword.hidden=NO;
    [self.view addSubview:self.viewForgotPassword];
}

-(IBAction)onClickSubmitForgotPassword:(id)sender{
    
    [self startServiceToForgotPassword];
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
    
    [class setServiceURL:[NSString stringWithFormat:@"%@forgetpassword",SERVERURLPATH]];
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
          self.viewForgotPassword.hidden=YES;
        if ([[rootDictionary objectForKey:@"msg"] isEqualToString:@"Successfully LoggedIn"]) {
         
            
            
        }else{
            [ECSAlert showAlert:[rootDictionary objectForKey:@"msg"]];
        }
    }
    else [ECSAlert showAlert:@"Error!"];
    
}





@end
