//
//  AboutRestaurantVC.m
//  TABQY MENU
//
//  Created by ASK ONLINE  on 24/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import "AboutRestaurantVC.h"
#import "AppUserObject.h"
#import "UIExtensions.h"
#import "ECSServiceClass.h"
#import "MenuItemVC.h"
#import "ECSHelper.h"
#import "SearchFoodVC.h"
#import "MBProgressHUD.h"
@interface AboutRestaurantVC ()
@property(weak,nonatomic)IBOutlet UIView *viewTop;
@property(weak,nonatomic)IBOutlet UIImageView *imglogo;
@property(weak,nonatomic)IBOutlet UIImageView *restorentBGImage;
@end

@implementation AboutRestaurantVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *scrName=[NSString stringWithFormat:@"About %@",self.appUserObject.resturantName];
    [self settingTopView:self.viewTop onController:self andTitle:scrName andImg:@"arrow-left.png"];
    
    NSString *imgurl=[NSString stringWithFormat:@"%@%@",RESTORENTBGIMAGE,self.appUserObject.resturantBgImage];
    [self.restorentBGImage ecs_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         // [self.activityProfileImage stopAnimating];
     }];

    // Do any additional setup after loading the view from its nib.
}
- (void)clickToOpenSearch:(id)sender{
    
    SearchFoodVC *spl=[[SearchFoodVC alloc ]initWithNibName:@"SearchFoodVC" bundle:nil];
    [self.navigationController pushViewController:spl animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
