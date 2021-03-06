//
//  ECSTopBar.m
//  TrustYoo
//
//  Created by Developer on 9/9/14.
//  Copyright (c) 2014 Shreesh Garg. All rights reserved.
//

#import "ECSTopBar.h"
#import "UIExtensions.h"
#import "UIAppExtensions.h"
//#import "DS_SearchScreen.h"
//#import "DS_CartScreen.h"
#import "AppUserObject.h"
#import "ECSHelper.h"
#import "ECSServiceClass.h"
#import "PlaceOrderVC.h"
@interface ECSTopBar ()
@property (weak, nonatomic) IBOutlet UILabel *lblHeading;
@property (weak, nonatomic) IBOutlet UIButton *btnCart;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) NSString *imagestr;
@property (strong, nonatomic) IBOutlet UIButton *btnRight;
@property (weak, nonatomic) IBOutlet UIImageView *imgLogo;
- (IBAction)clickToPlaceOrder:(id)sender;
- (IBAction)clickToOpenSearch:(id)sender;
- (IBAction)clickToOpenSideMenu:(id)sender;
@property (nonatomic, retain) UIViewController * controller;
@property (nonatomic, retain) NSString * heading;



@end

@implementation ECSTopBar
-(id)initWithController:(UIViewController *)controller withTitle:(NSString *)headerTitle withImage:(NSString *)imgNamestr
{
    
    self = [self initWithNibName:@"ECSTopBar" bundle:nil];
    self.controller = controller;
   self.heading = headerTitle;
    
    self.imagestr=imgNamestr;
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
    
   
   
         [self.lblHeading setText:self.heading];

        if (self.appUserObject.resturantLogo ==(id)[NSNull null] ||[self.appUserObject.resturantLogo isEqualToString:@""]) {
            NSLog(@"ttt %@",self.appUserObject.resturantLogo);
           // [self.btnEdit setButtonTitle:@"Upload"];
    
        }else{
            NSString *imgurl;
            NSString *selectedIp=[ECSUserDefault getStringFromUserDefaultForKey:@"ResetIP"];
           
            if (selectedIp.length) {
                imgurl=[NSString stringWithFormat:@"http://%@%@%@",selectedIp,RESTORANTLOGO,self.appUserObject.resturantLogo];
            }else{
                imgurl=[NSString stringWithFormat:@"http://%@%@%@",@"tabqy.com",RESTORANTLOGO,self.appUserObject.resturantLogo];
            }
            
        [self.imgLogo ecs_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {
                // [self.activityProfileImage stopAnimating];
             }];
          
            
        }
    if (self.heading.length) {
         [self.lblHeading setText:self.heading];
    }else{
         [self.lblHeading setText:self.appUserObject.resturantName];
    }
   
    
    NSString *string = self.heading;
    if ([string containsString:@"Search Food"]) {
        self.btnCart.hidden=YES;
    }
    
    if ([self.imagestr isEqualToString:@"nav_header_icon.png"] ) {
       // self.btnBack.hidden=YES;
        UIImage *btnImage = [UIImage imageNamed:self.imagestr];
        [self.btnMenu setImage:btnImage forState:UIControlStateNormal];
        
          [self.view setBackgroundColor:[JKSColor  colorwithHexString:self.appUserObject.resturantColor alpha:1.0]];
    }else{
        UIImage *btnImage = [UIImage imageNamed:@"icon_order_online.png"];
        [self.btnRight setImage:btnImage forState:UIControlStateNormal];
        
        if ([string containsString:@"Place Order"]||[string containsString:@"Order Progress"]||[string containsString:@"Order Histry"]||[string containsString:@"Tables"]||[string containsString:@"About"]||[string containsString:@"Feedback"]||[string containsString:@"Profile"]) {
            self.btnRight.hidden=YES;
            self.btnCart.frame=CGRectMake(self.btnCart.frame.origin.x+100, self.btnCart.frame.origin.y, self.btnCart.frame.size.width, self.btnCart.frame.size.height);
        }else{
             self.btnCart.frame=CGRectMake(self.btnCart.frame.origin.x, self.btnCart.frame.origin.y, self.btnCart.frame.size.width, self.btnCart.frame.size.height);
            self.btnRight.hidden=NO;
        }
//home develiry
        if ([string containsString:@"Print"]||[string containsString:@"home develiry"]) {
            self.btnRight.hidden=YES;
            self.btnCart.hidden=YES;
        }
        
    [self.view setBackgroundColor:[JKSColor  colorwithHexString:self.appUserObject.resturantColor alpha:1.0]];
    }
 
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickToOpenSideMenu:(id)sender
{
    //[self.delegate addClubsToBounce:self.arraySelectedClubs];
   // [self.navigationController popViewControllerAnimated:YES];
    
    if([self.controller canPerformAction:@selector(openSideMenuButtonClicked:) withSender:sender])
    {
        [self.controller performSelector:@selector(openSideMenuButtonClicked:) withObject:sender];
    }
    else
    {
       
        
         
         [self.controller.navigationController popViewControllerAnimated:NO];
    }
}




- (IBAction)clickToPlaceOrder:(id)sender
{
    //[self.delegate addClubsToBounce:self.arraySelectedClubs];
    //[self.navigationController popViewControllerAnimated:YES];
    
    if([self.controller canPerformAction:@selector(clickToPlaceOrderList:) withSender:sender])
    {
        [self.controller performSelector:@selector(clickToPlaceOrderList:) withObject:sender];
    }
    else
    {
       
      //  [self.controller.navigationController popViewControllerAnimated:YES];
    }
}


- (IBAction)clickToOpenSearch:(id)sender
{
    //[self.delegate addClubsToBounce:self.arraySelectedClubs];
    //[self.navigationController popViewControllerAnimated:YES];
    
    if([self.controller canPerformAction:@selector(clickToOpenSearch:) withSender:sender])
    {
        [self.controller performSelector:@selector(clickToOpenSearch:) withObject:sender];
    }
    else
    {
        
        [self.controller.navigationController popViewControllerAnimated:YES];
    }
}


- (IBAction)clickToBack:(id)sender
{
    //[self.delegate addClubsToBounce:self.arraySelectedClubs];
    //[self.navigationController popViewControllerAnimated:YES];
    
    if([self.controller canPerformAction:@selector(clickTobackVC:) withSender:sender])
    {
        [self.controller performSelector:@selector(clickTobackVC:) withObject:sender];
    }
    else
    {
        
        [self.controller.navigationController popViewControllerAnimated:NO];
    }
}




@end
