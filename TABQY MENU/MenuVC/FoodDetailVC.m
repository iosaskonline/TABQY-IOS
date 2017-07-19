//
//  FoodDetailVC.m
//  TABQY MENU
//
//  Created by ASK ONLINE  on 07/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import "FoodDetailVC.h"
#import "AppUserObject.h"
#import "ECSHelper.h"
#import "ECSServiceClass.h"

#import "UIExtensions.h"
#import "MBProgressHUD.h"
#import "FoodDetailObject.h"
#import "FoodRelatedItemObject.h"
#import "ReletedItemCell.h"
#import "SearchFoodVC.h"
#import "AssociatedFoodObject.h"
#import "CompleteOrderVC.h"
#import "PlaceOrderVC.h"
@interface FoodDetailVC ()
@property(weak,nonatomic)IBOutlet UIView *viewTop;
@property(weak,nonatomic)IBOutlet UIImageView *restorentBGImage;
@property(weak,nonatomic)IBOutlet UILabel *lblPrice;
@property(weak,nonatomic)IBOutlet UILabel *lblCategory;
@property(weak,nonatomic)IBOutlet UIImageView *imgRestorent;
@property(weak,nonatomic)IBOutlet UITextView *txtDiscription;
@property(weak,nonatomic)IBOutlet UILabel *lblName;
@property(weak,nonatomic)IBOutlet UILabel *lblAssociate;

@property(strong,nonatomic)NSMutableArray *arrayRelatedItems;
@property (weak, nonatomic) IBOutlet UICollectionView *segmentedCollectionView;

@end

@implementation FoodDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingTopView:self.viewTop onController:self andTitle:[NSString stringWithFormat:@"%@ FoodDetail",self.appUserObject.resturantName] andImg:@"arrow-left.png"];
     [self.segmentedCollectionView  registerNib:[UINib nibWithNibName:@"ReletedItemCell" bundle:nil]forCellWithReuseIdentifier:@"Cell"];
  //  NSString *imgurl=[NSString stringWithFormat:@"%@%@",RESTORENTBGIMAGE,self.appUserObject.resturantBgImage];
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
    
    [self startServiceToGetFoodDetails];
}



-(void)startServiceToGetFoodDetails
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToGetFoodDetails) withObject:nil];
    
    
}

-(void)serviceToGetFoodDetails
{
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
    NSString *selectedIp=[ECSUserDefault getStringFromUserDefaultForKey:@"ResetIP"];
    if (selectedIp.length) {
        [class setServiceURL:[NSString stringWithFormat:@"http://%@%@fooddetails",selectedIp,SERVERURLPATH]];
    }else{
        [class setServiceURL:[NSString stringWithFormat:@"http://%@%@fooddetails",@"tabqy.com",SERVERURLPATH]];
    }
   // [class setServiceURL:[NSString stringWithFormat:@"%@fooddetails",SERVERURLPATH]];
    //{"food_id": "25"}
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          self.foodId, @"food_id",
                          nil];
    
    [class addJson:dict];
    [class setCallback:@selector(callBackServiceToGetFoodDetails:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToGetFoodDetails:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
        self.arrayRelatedItems=[[NSMutableArray alloc]init];
        NSArray *arr=[rootDictionary valueForKey:@"relateditems"];
        for (NSDictionary * dictionary in arr)
        {
            
            FoodRelatedItemObject  *object=[FoodRelatedItemObject instanceFromDictionary:dictionary];
            
            [self.arrayRelatedItems addObject:object];
            
        }
       
        NSArray *arrDetail=[rootDictionary valueForKey:@"fooddetail"];
        for (NSDictionary * dictionary in arrDetail)
        {
            
            FoodDetailObject  *objectDetail=[FoodDetailObject instanceFromDictionary:dictionary];
            self.lblName.text=objectDetail.foodName ;
           // NSString *imgurl=[NSString stringWithFormat:@"%@%@",FOODIMAGE,objectDetail.foodImage];
            NSString *imgurl;
            NSString *selectedIp=[ECSUserDefault getStringFromUserDefaultForKey:@"ResetIP"];
            
            if (selectedIp.length) {
                imgurl=[NSString stringWithFormat:@"http://%@%@%@",selectedIp,FOODIMAGE,objectDetail.foodImage];
            }else{
                imgurl=[NSString stringWithFormat:@"http://%@%@%@",@"tabqy.com",FOODIMAGE,objectDetail.foodImage];
            }
            [self.imgRestorent ecs_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {
                 // [self.activityProfileImage stopAnimating];
             }];
            self.imgRestorent.contentMode=UIViewContentModeScaleAspectFit;
            self.txtDiscription.text=objectDetail.foodDescription;
              self.lblPrice.text=[NSString stringWithFormat:@"%@%@",self.appUserObject.resturantCurrency,objectDetail.price];
             self.lblCategory.text=objectDetail.foodcategory;
            NSString *associatedFoods;
            for (NSDictionary * dictionary in objectDetail.associatedFood)
            {
                AssociatedFoodObject  *associatedFoodObject=[AssociatedFoodObject instanceFromDictionary:dictionary];
                associatedFoods=[NSString stringWithFormat:@"%@,%@",associatedFoods,associatedFoodObject.associatedFoodName];
               
            }
            associatedFoods = [associatedFoods stringByReplacingOccurrencesOfString:@"(null),"
                                                 withString:@""];
             NSLog( @"associatedFoods %@",associatedFoods);
            self.lblAssociate.text=associatedFoods;
        }
       
        [self.segmentedCollectionView reloadData];
        if ([[rootDictionary objectForKey:@"msg"] isEqualToString:@"Foodtype not found!"]) {
            
                      [ECSAlert showAlert:[rootDictionary objectForKey:@"msg"]];
            
            
        }else{
           
            
            //
            //  [ECSAlert showAlert:[rootDictionary objectForKey:@"msg"]];
        }
    }
    else [ECSAlert showAlert:@"Server Issue."];
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    return self.arrayRelatedItems.count;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 5.0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    ReletedItemCell *cell =
    (ReletedItemCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell"
                                                               forIndexPath:indexPath];
    
    
    FoodRelatedItemObject * connectionObject = [self.arrayRelatedItems objectAtIndex:indexPath.row];
    
    [cell.lblName setText:connectionObject.name];
   // NSString *imgurl=[NSString stringWithFormat:@"%@%@",FOODIMAGE,connectionObject.food_image];
    
    NSString *imgurl;
    NSString *selectedIp=[ECSUserDefault getStringFromUserDefaultForKey:@"ResetIP"];
    
    if (selectedIp.length) {
        imgurl=[NSString stringWithFormat:@"http://%@%@%@",selectedIp,FOODIMAGE,connectionObject.food_image];
    }else{
        imgurl=[NSString stringWithFormat:@"http://%@%@%@",@"tabqy.com",FOODIMAGE,connectionObject.food_image];
    }
    [cell.img_view ecs_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         // [self.activityProfileImage stopAnimating];
     }];
     cell.img_view.contentMode=UIViewContentModeScaleAspectFit;
    cell.lblPrice.text=[NSString stringWithFormat:@"%@%@",self.appUserObject.resturantCurrency,connectionObject.price];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(350, 200);
}

-(void)collectionView:(UICollectionView *)cv didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
   
    FoodRelatedItemObject * connectionObject = [self.arrayRelatedItems objectAtIndex:indexPath.row];


    
    
    self.foodId=connectionObject.food_id;
    
    [self startServiceToGetFoodDetails];
}

- (void)clickToOpenSearch:(id)sender{
    
    SearchFoodVC *spl=[[SearchFoodVC alloc ]initWithNibName:@"SearchFoodVC" bundle:nil];
    [self.navigationController pushViewController:spl animated:YES];
    
}


-(void)clickToPlaceOrderList:(id)sender{
    //    PlaceOrderVC *nav=[[PlaceOrderVC alloc]initWithNibName:@"PlaceOrderVC" bundle:nil];
    //
    //
    //
    //    [self.navigationController pushViewController:nav animated:YES];
    
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
