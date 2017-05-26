//
//  TableListVC.m
//  TABQY MENU
//
//  Created by ASK ONLINE  on 14/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import "TableListVC.h"
#import "AppUserObject.h"
#import "ECSServiceClass.h"
#import "UIExtensions.h"

#import "FoodObject.h"
#import "ECSHelper.h"

#import "MBProgressHUD.h"
#import "HomeDeliveryVC.h"
#import "PlaceOrderVC.h"
#import "TableItemCell.h"
#import "TableListObject.h"
#import "MenuItemVC.h"
#import "SearchFoodVC.h"
#import "MVYSideMenuController.h"
@interface TableListVC ()
@property(weak,nonatomic)IBOutlet UIView *viewTop;

@property (weak, nonatomic) IBOutlet UICollectionView *menuCollectionView;
@property(weak,nonatomic)IBOutlet UIImageView *restorentBGImage;
@property(strong,nonatomic)NSMutableArray *arrayTable;
@end

@implementation TableListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayTable=[[NSMutableArray alloc]init];
     [self.menuCollectionView  registerNib:[UINib nibWithNibName:@"TableItemCell" bundle:nil]forCellWithReuseIdentifier:@"Cell"];
    // Do any additional setup after loading the view from its nib.
    [self settingTopView:self.viewTop onController:self andTitle:[NSString stringWithFormat:@"%@ Tables",self.appUserObject.resturantName] andImg:@"arrow-left.png"];
    NSString *imgurl=[NSString stringWithFormat:@"%@%@",RESTORENTBGIMAGE,self.appUserObject.resturantBgImage];
    UIImage *img=[UIImage imageWithName:@"restorentgp.jpg"];
    [self.restorentBGImage ecs_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:img options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         // [self.activityProfileImage stopAnimating];
     }];
    [self startServiceToGetAllTable];
    
}



-(void)startServiceToGetAllTable
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToGetAllTable) withObject:nil];
    
    
}

-(void)serviceToGetAllTable
{
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
    
    [class setServiceURL:[NSString stringWithFormat:@"%@table_assign_to_waiter",SERVERURLPATH]];
   
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                 self.appUserObject.user_id, @"user_id",
                                 nil];
    [class addJson:dict];
    [class setCallback:@selector(callBackServiceToGetAllTable:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToGetAllTable:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
        
        NSArray *arr=[rootDictionary valueForKey:@"waitertable"];
         [ECSToast showToast:[rootDictionary valueForKey:@"msg"] view:self.view];
        for (NSDictionary * dictionary in arr)
        {
            TableListObject  *object=[TableListObject instanceFromDictionary:dictionary];
            
            [self.arrayTable addObject:object];
        }

         [self.menuCollectionView reloadData];
    }
   
    else [ECSAlert showAlert:@"Error!"];
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    return self.arrayTable.count;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 20.0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(180, 140);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    TableItemCell *cell =
    (TableItemCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell"
                                                              forIndexPath:indexPath];
    
    
    
    TableListObject * connectionObject = [self.arrayTable objectAtIndex:indexPath.row];
    if ([connectionObject.Booked isEqualToString:@"booked"]) {
        cell.img_view.image = [UIImage imageNamed:@"selected2.png"];

    }else{
    cell.img_view.image = [UIImage imageNamed:@"table_icon12.png"];
    
    }
    cell.lblName.text=connectionObject.tableName;
    
    [cell.lblName setFontKalra:13];
   
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    TableListObject * connectionObject = [self.arrayTable objectAtIndex:indexPath.row];
    if ([connectionObject.Booked isEqualToString:@"booked"]) {
       // cell.img_view.image = [UIImage imageNamed:@"selected2.png"];
     [ECSToast showToast:@"already booked.Please choose another table" view:self.view];
        [self.menuCollectionView reloadData];
        
    }else{
       // cell.img_view.image = [UIImage imageNamed:@"table_icon12.png"];
        MenuItemVC *menuVC=[[MenuItemVC alloc]initWithNibName:@"MenuItemVC" bundle:nil];
        TableListObject * connectionObject = [self.arrayTable objectAtIndex:indexPath.row];
        [ECSUserDefault saveString:connectionObject.tableName ToUserDefaultForKey:@"tablename"];
        [ECSUserDefault saveString:connectionObject.tableId ToUserDefaultForKey:@"tableId"];
        [self.navigationController pushViewController:menuVC animated:YES];
    }
    
    

    
    
}



-(void)clickToPlaceOrderList:(id)sender{
    PlaceOrderVC *nav=[[PlaceOrderVC alloc]initWithNibName:@"PlaceOrderVC" bundle:nil];
    [self.navigationController pushViewController:nav animated:YES];
    
    NSLog(@"placeOrderClicked");
}



- (void)clickToOpenSearch:(id)sender{
    
    SearchFoodVC *spl=[[SearchFoodVC alloc ]initWithNibName:@"SearchFoodVC" bundle:nil];
    [self.navigationController pushViewController:spl animated:YES];
    
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
