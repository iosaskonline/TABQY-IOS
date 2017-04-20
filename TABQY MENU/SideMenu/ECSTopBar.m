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
@property (weak, nonatomic) NSString *imagestr;
@property (weak, nonatomic) IBOutlet UIButton *btnRight;
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

    
    //self.lblHeading.textColor=[UIColor blackColor];
         // self.lblHeading.text=@"One";
    
     //[self.lblHeading setFontKalra:22];
        if (self.appUserObject.resturantLogo ==(id)[NSNull null] ||[self.appUserObject.resturantLogo isEqualToString:@""]) {
            NSLog(@"ttt %@",self.appUserObject.resturantLogo);
           // [self.btnEdit setButtonTitle:@"Upload"];
    
        }else{
            NSString *imgurl=[NSString stringWithFormat:@"%@%@",RESTORANTLOGO,self.appUserObject.resturantLogo];
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
   
    
       UIImage *btnImage = [UIImage imageNamed:self.imagestr];
       [self.btnBack setImage:btnImage forState:UIControlStateNormal];
    
    
    if ([self.imagestr isEqualToString:@"menu-icon.png"] ) {
          [self.view setBackgroundColor:[JKSColor  colorwithHexString:self.appUserObject.resturantColor alpha:1.0]];
    }else{
        UIImage *btnImage = [UIImage imageNamed:@"menu-icon.png"];
        [self.btnRight setImage:btnImage forState:UIControlStateNormal];
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
    //[self.navigationController popViewControllerAnimated:YES];
    
    if([self.controller canPerformAction:@selector(openSideMenuButtonClicked:) withSender:sender])
    {
        [self.controller performSelector:@selector(openSideMenuButtonClicked:) withObject:sender];
    }
    else
    {
         
         [self.controller.navigationController popViewControllerAnimated:YES];
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
        
        [self.controller.navigationController popViewControllerAnimated:YES];
    }
}



//-(void)clickToPlaceOrderList:(id)sender{
//    PlaceOrderVC *nav=[[PlaceOrderVC alloc]initWithNibName:@"PlaceOrderVC" bundle:nil];
//    [self.navigationController pushViewController:nav animated:YES];
//    
//    NSLog(@"placeOrderClicked");
//}
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






@end
