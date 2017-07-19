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
#import "TPKeyboardAvoidingScrollView.h"
#import "ReletedItemCell.h"
#import "PlaceOrderVC.h"
#import "MVYSideMenuController.h"
@interface AboutRestaurantVC ()
@property(weak,nonatomic)IBOutlet UIView *viewTop;
@property(weak,nonatomic)IBOutlet UIImageView *imglogo;
@property(weak,nonatomic)IBOutlet UIImageView *restorentBGImage;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scroll_addContact;
@property(strong,nonatomic)NSMutableArray *arrayMenu;

@property(weak,nonatomic)IBOutlet UILabel *lblPrice;
@property(weak,nonatomic)IBOutlet UILabel *lblCategory;
@property(weak,nonatomic)IBOutlet UIImageView *imgRestorent;
@property(weak,nonatomic)IBOutlet UITextView *txtDiscription;
@property(weak,nonatomic)IBOutlet UILabel *lblName;
@property(weak,nonatomic)IBOutlet UILabel *lblAssociate;

@property(strong,nonatomic)NSMutableArray *arrayRelatedItems;
@property (weak, nonatomic) IBOutlet UICollectionView *segmentedCollectionView;

@end

@implementation AboutRestaurantVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *scrName=[NSString stringWithFormat:@"About %@",self.appUserObject.resturantName];
    [self settingTopView:self.viewTop onController:self andTitle:scrName andImg:@"arrow-left.png"];
    
   // NSString *imgurl=[NSString stringWithFormat:@"%@%@",RESTORENTBGIMAGE,self.appUserObject.resturantBgImage];
    NSString *imgurl;
    NSString *selectedIp=[ECSUserDefault getStringFromUserDefaultForKey:@"ResetIP"];
    
    if (selectedIp.length) {
        imgurl=[NSString stringWithFormat:@"http://%@%@%@",selectedIp,RESTORENTBGIMAGE,self.appUserObject.resturantBgImage];
    }else{
        imgurl=[NSString stringWithFormat:@"http://%@%@%@",@"tabqy.com",RESTORENTBGIMAGE,self.appUserObject.resturantBgImage];
    }
    UIImage *img=[UIImage imageWithName:@"restorentgp.jpg"];
    [self.restorentBGImage ecs_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:img options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         // [self.activityProfileImage stopAnimating];
     }];
    
    [self.segmentedCollectionView  registerNib:[UINib nibWithNibName:@"ReletedItemCell" bundle:nil]forCellWithReuseIdentifier:@"Cell"];
     [self startServiceToAboutRestorant];
    
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

-(void)startServiceToAboutRestorant
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToAboutRestorant) withObject:nil];
    
    
}

-(void)serviceToAboutRestorant
{
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
    NSString *selectedIp=[ECSUserDefault getStringFromUserDefaultForKey:@"ResetIP"];
    if (selectedIp.length) {
        [class setServiceURL:[NSString stringWithFormat:@"http://%@%@about_restaurant",selectedIp,SERVERURLPATH]];
    }else{
        [class setServiceURL:[NSString stringWithFormat:@"http://%@%@about_restaurant",@"tabqy.com",SERVERURLPATH]];
    }
    //[class setServiceURL:[NSString stringWithFormat:@"%@about_restaurant",SERVERURLPATH]];
    //{"resturant_id":"8","food_name":"sa"}
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                 self.appUserObject.resturantId, @"resturant_id",
                                 nil];
    [class addJson:dict];
    [class setCallback:@selector(callBackServiceToAboutRestorant:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToAboutRestorant:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
        self.arrayMenu=[[NSMutableArray alloc]init];
       self.arrayMenu=[rootDictionary valueForKey:@"our_team"];
        NSArray *arr=[rootDictionary valueForKey:@"about_restaurant"];
        NSDictionary *dict=[arr objectAtIndex:0];
        self.txtDiscription.text=[dict valueForKey:@"description"];
        
       // NSString *imgurl=[NSString stringWithFormat:@"%@%@",RESTAURANTIMG,[dict valueForKey:@"restaurant_image"]];
        NSString *imgurl;
        NSString *selectedIp=[ECSUserDefault getStringFromUserDefaultForKey:@"ResetIP"];
        
        if (selectedIp.length) {
            imgurl=[NSString stringWithFormat:@"http://%@%@%@",selectedIp,RESTAURANTIMG,[dict valueForKey:@"restaurant_image"]];
        }else{
            imgurl=[NSString stringWithFormat:@"http://%@%@%@",@"tabqy.com",RESTAURANTIMG,[dict valueForKey:@"restaurant_image"]];
        }
        
        [self.imgRestorent ecs_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             // [self.activityProfileImage stopAnimating];
         }];

        [self.segmentedCollectionView reloadData];
    }
   
    else  [ECSAlert showAlert:@"Server Issue."];
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    return self.arrayMenu.count;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 5.0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    ReletedItemCell *cell =
    (ReletedItemCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell"
                                                                 forIndexPath:indexPath];
    
    NSDictionary *dict=[self.arrayMenu objectAtIndex:indexPath.row];
    //FoodRelatedItemObject * connectionObject = [self.arrayRelatedItems objectAtIndex:indexPath.row];
    
    [cell.lblName setText:[dict valueForKey:@"username"]];
   // NSString *imgurl=[NSString stringWithFormat:@"%@%@",TEAMIMG,[dict valueForKey:@"profile_image"]];
    NSString *imgurl;
    NSString *selectedIp=[ECSUserDefault getStringFromUserDefaultForKey:@"ResetIP"];
    
    if (selectedIp.length) {
        imgurl=[NSString stringWithFormat:@"http://%@%@%@",selectedIp,TEAMIMG,[dict valueForKey:@"profile_image"]];
    }else{
        imgurl=[NSString stringWithFormat:@"http://%@%@%@",@"tabqy.com",TEAMIMG,[dict valueForKey:@"profile_image"]];
    }

    [cell.img_view ecs_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         // [self.activityProfileImage stopAnimating];
     }];
    cell.lblPrice.text=@"Waiter";
   
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(350, 200);
}

-(void)collectionView:(UICollectionView *)cv didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
    
    
}

-(void)clickToPlaceOrderList:(id)sender{
    PlaceOrderVC *nav=[[PlaceOrderVC alloc]initWithNibName:@"PlaceOrderVC" bundle:nil];
    
    
    
    [self.navigationController pushViewController:nav animated:YES];
    
    
}
//-(void)openSideMenuButtonClicked:(UIButton *)sender{
//    
//    MVYSideMenuController *sideMenuController = [self sideMenuController];
//    //  DS_SideMenuVC * vc = (DS_SideMenuVC *)sideMenuController.menuViewController;
//    NSLog(@" test==%@ ",self.appUserObject.sidebarColor);
//    NSLog(@" testActive==%@ ",self.appUserObject.sidebarActiveColor);
//    if (sideMenuController) {
//        
//        [sideMenuController openMenu];
//    }
//    
//}

@end
