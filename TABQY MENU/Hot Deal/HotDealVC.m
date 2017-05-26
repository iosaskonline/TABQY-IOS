//
//  HotDealVC.m
//  TABQY MENU
//
//  Created by ASK ONLINE  on 01/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import "HotDealVC.h"
#import "AppUserObject.h"
#import "ECSServiceClass.h"
#import "UIExtensions.h"
#import "MBProgressHUD.h"
#import "HotDealTableCell.h"
#import "FoodObject.h"
#import "ECSHelper.h"
#import "PlaceOrderVC.h"
#import "TableAssociatedCell.h"
#import "AssociatedFoodObject.h"
#import "SearchFoodVC.h"
#import "FoodDetailVC.h"
#import "MVYSideMenuController.h"
@interface HotDealVC ()
{
       NSString *foodIdSelected;
}
@property(weak,nonatomic)IBOutlet UIView *viewTop;
@property(weak,nonatomic)IBOutlet UIImageView *restorentBGImage;
@property(weak,nonatomic)IBOutlet UITableView *tblFood;
@property(weak,nonatomic) NSString *cusineId;
@property(strong,nonatomic) NSMutableArray *arrayFood;
@property(strong,nonatomic) NSMutableArray *arraySelected;
@property(strong,nonatomic) NSMutableArray *arraySelectedfoodSave;
@property(strong,nonatomic)NSMutableArray *arraySelectedfoodIdsSave;
@property(strong,nonatomic)IBOutlet UIView *viewAssociatedItem;
@property(weak,nonatomic)IBOutlet UITableView *tblAssociatedItems;
@property(strong,nonatomic)IBOutlet NSMutableArray *arrayAssociated;
@property(strong,nonatomic)IBOutlet NSMutableArray *arraySelectedAssociatedItem;
@end

@implementation HotDealVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayFood=[[NSMutableArray alloc]init];
    self.arraySelectedfoodSave=[[NSMutableArray alloc]init];
    self.arraySelectedfoodIdsSave=[[NSMutableArray alloc]init];
    
    self.arrayAssociated=[[NSMutableArray alloc]init];
    self.arraySelectedAssociatedItem=[[NSMutableArray alloc]init];
      [self settingTopView:self.viewTop onController:self andTitle:[NSString stringWithFormat:@"%@ Hot Deal",self.appUserObject.resturantName] andImg:@"arrow-left.png"];
    
    NSString *imgurl=[NSString stringWithFormat:@"%@%@",RESTORENTBGIMAGE,self.appUserObject.resturantBgImage];
    [self.restorentBGImage ecs_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         // [self.activityProfileImage stopAnimating];
     }];
    // Do any additional setup after loading the view from its nib.
    
    [self startServiceToHotDeal];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView==self.tblAssociatedItems) {
        
        return self.arrayAssociated.count;
        
    }else
        return self.arrayFood.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 180;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==self.tblFood) {
     
    static NSString *CellIdentifier = @"Cell";
    
    
    [self.tblFood registerNib:[UINib nibWithNibName:@"HotDealTableCell" bundle:nil]forCellReuseIdentifier:@"Cell"];
    HotDealTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.tblFood setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    cell.backgroundColor = [UIColor clearColor];
    FoodObject *object=[self.arrayFood objectAtIndex:indexPath.row];
    
    NSString *key=[NSString stringWithFormat:@"placeOrder%ld",(long)[object.foodId integerValue]];
    NSData *data=[ECSUserDefault getObjectFromUserDefaultForKey:key];
    if (data.length) {
        FoodObject *obj=[NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([obj.foodId isEqualToString:object.foodId]) {
            object=obj;
        }
    }

    
    cell.lblFoodName.text=object.foodName;
    
    NSString *strimage = object.foodImage;
    NSString *imgurl=[NSString stringWithFormat:@"%@%@",FOODIMAGE,object.foodImage];
    
    if ([strimage isKindOfClass:[NSNull class]]) {
        cell.imgFood.image = [UIImage imageNamed:@"Pasted image.png"];
        
    }
    else if([strimage isEqualToString:@""] ){
        cell.imgFood.image = [UIImage imageNamed:@"Pasted image.png"];
    }
    else{
         [cell.activityInd startAnimating];
        [cell.imgFood ecs_setImageWithURL:[NSURL URLWithString:[imgurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"User-image.png"] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [cell.activityInd stopAnimating];
        }];
        
    }
    cell.lblFoodprice.text=[NSString stringWithFormat:@"%@ %@",self.appUserObject.resturantCurrency,object.price];
    cell.lbldescription.text=[NSString stringWithFormat:@"%@",object.foodDescription];
    
    
    [cell.btnAdd addTarget:self action:@selector(clickToAdd:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnDelete addTarget:self action:@selector(clickToSubt:) forControlEvents:UIControlEventTouchUpInside];
    
    BOOL flag=   [_arraySelected containsObject:
                  [NSString stringWithFormat:@"%li",indexPath.row]];
    
 
    if(flag == NO )
    {

        [cell.btnCheck setImage:[UIImage imageNamed:@"tick_icon_unselected.png"] forState:UIControlStateNormal];
       
    }
    else {
        
        [cell.btnCheck setImage:[UIImage imageNamed:@"tick_icon.png"] forState:UIControlStateNormal];
        
    }
    cell.btnAdd.tag=indexPath.row;
    cell.btnDelete.tag=indexPath.row;
    if (object.foodCount.length) {
        cell.lblCount.text=object.foodCount;
        if ([cell.lblCount.text isEqualToString:@"0"]) {
        [cell.btnCheck setImage:[UIImage imageNamed:@"tick_icon_unselected.png"] forState:UIControlStateNormal];
        }else
         [cell.btnCheck setImage:[UIImage imageNamed:@"tick_icon.png"] forState:UIControlStateNormal];
    }else{
        
        cell.lblCount.text=@"0";
    }

    return cell;
}
    else  {
        static NSString *CellIdentifier = @"Cell";
        
        
        [self.tblAssociatedItems registerNib:[UINib nibWithNibName:@"TableAssociatedCell" bundle:nil]forCellReuseIdentifier:@"Cell"];
        TableAssociatedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.tblAssociatedItems setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        cell.backgroundColor = [UIColor clearColor];
        AssociatedFoodObject *object=[self.arrayAssociated objectAtIndex:indexPath.row];
        
        cell.lblName.text=object.associatedFoodName;
        
        NSString *strimage = object.associatedFoodimage;
        NSString *imgurl=[NSString stringWithFormat:@"%@%@",FOODIMAGE,object.associatedFoodimage];
        
        if ([strimage isKindOfClass:[NSNull class]]) {
            cell.img_view.image = [UIImage imageNamed:@"Pasted image.png"];
            
        }
        else if([strimage isEqualToString:@""] ){
            cell.img_view.image = [UIImage imageNamed:@"Pasted image.png"];
        }
        else{
             [cell.activityInd startAnimating];
            [cell.img_view ecs_setImageWithURL:[NSURL URLWithString:[imgurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"User-image.png"] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                 [cell.activityInd stopAnimating];
            }];
            
        }
        cell.lblPrice.text=[NSString stringWithFormat:@"%@ %@",self.appUserObject.resturantCurrency,object.associatedFoodPrice];
        
        cell.lblDiscription.text=[NSString stringWithFormat:@"%@",object.assoFoodDiscription];
        
        [cell.btnCheck addTarget:self action:@selector(clickToAddAssocitedFood:) forControlEvents:UIControlEventTouchUpInside];
        BOOL flag=   [self.arraySelectedAssociatedItem containsObject:
                      [NSString stringWithFormat:@"%li",indexPath.row]];
        
        if(flag == NO )
        {
            [cell.btnCheck setImage:[UIImage imageNamed:@"tick_icon_unselected.png"] forState:UIControlStateNormal];
        }
        else {
            [cell.btnCheck setImage:[UIImage imageNamed:@"tick_icon.png"] forState:UIControlStateNormal];
        }
        
        cell.btnCheck.tag=indexPath.row;
    
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    FoodObject*obj=[self.arrayFood objectAtIndex:indexPath.row];
    FoodDetailVC *nav=[[FoodDetailVC alloc]initWithNibName:@"FoodDetailVC" bundle:nil];
    nav.foodId=obj.foodId;
    [self.navigationController pushViewController:nav animated:YES];
    
    
}


-(void)startServiceToHotDeal
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToHotDeal) withObject:nil];
    
    
}

-(void)serviceToHotDeal
{
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
    
    [class setServiceURL:[NSString stringWithFormat:@"%@hotdeals",SERVERURLPATH]];
    //{"resturant_id":"9","cusinie_id":"10","foodtype_id":"33","menu_id":"17"}
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          self.appUserObject.resturantId, @"resturant_id",
                          nil];
    
    [class addJson:dict];
    [class setCallback:@selector(callBackServiceToHotDeal:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToHotDeal:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
        self.arrayFood=[[NSMutableArray alloc]init];
        NSArray *arr=[rootDictionary valueForKey:@"hotdeals"];
        for (NSDictionary * dictionary in arr)
        {
            
            FoodObject  *object=[FoodObject instanceFromDictionary:dictionary];
            
            [self.arrayFood addObject:object];
            
        }
        
        
        //[arrayfoodType addObjectsFromArray:arrayfoodType];
        [self.tblFood reloadData];
        if ([[rootDictionary objectForKey:@"msg"] isEqualToString:@"Hot Deals not found!"]) {
            
            self.tblFood.hidden=YES;
            
            // [ECSAlert showAlert:[rootDictionary objectForKey:@"msg"]];
            [ECSToast showToast:[rootDictionary objectForKey:@"msg"] view:self.view];
            
        }else{
            _arraySelected=[[NSMutableArray alloc]init];
            self.tblFood.hidden=NO;
            //  [ECSAlert showAlert:[rootDictionary objectForKey:@"msg"]];
        }
    }
    else [ECSAlert showAlert:@"Error!"];
    
}

- (IBAction)clickToAdd:(id)sender {
    

    
    self.arrayAssociated=[[NSMutableArray alloc]init];
    UIButton *btn=(UIButton *)sender;
    NSString *strContact=  [NSString stringWithFormat:@"%li",btn.tag];
    NSString *strFromInt = [NSString stringWithFormat:@"%d",1];
    
    
    [_arraySelected addObject:strContact];
    FoodObject *object=[self.arrayFood objectAtIndex:btn.tag];
    foodIdSelected=object.foodId;
    NSInteger a=[object.foodCount intValue];
    NSInteger b=[strFromInt intValue];
    NSInteger c=a+b;
    NSString *st = [NSString stringWithFormat:@"%ld", (long)c];
    object.foodCount= st;
    
    
    for (NSDictionary * dictionary in object.associatedFood)
    {
        
        AssociatedFoodObject  *associatedFoodObject=[AssociatedFoodObject instanceFromDictionary:dictionary];
        
        [self.arrayAssociated addObject:associatedFoodObject];
        
        // NSLog(@"associated %@",self.arrayAssociated);
    }
    if (self.arrayAssociated.count) {
        
        if (c>1) {
            self.viewAssociatedItem.hidden=YES;
        }else{
            self.viewAssociatedItem.hidden=NO;
            [self.view addSubview:self.viewAssociatedItem];
        }
        
    }else{
        self.viewAssociatedItem.hidden=YES;
    }
    
    // NSLog(@"_arraySelected %@",_arraySelected);
    
    [self.tblFood reloadData];
    [self.tblAssociatedItems reloadData];
    
    
}
-(void)clickToAddAssocitedFood:(id)sender{
    
    UIButton *btn=(UIButton *)sender;
    NSString *strContact=  [NSString stringWithFormat:@"%li",btn.tag];
    BOOL flag=   [self.arraySelectedAssociatedItem containsObject:strContact];
    
    //  NSString *strFromInt = [NSString stringWithFormat:@"%d",1];
    AssociatedFoodObject *object=[self.arrayAssociated objectAtIndex:btn.tag];
    if(flag == NO )
    {
        
        
        
        NSString *strForKey=[NSString stringWithFormat:@"placeOrderWithAssociatedFood%ld%ld",(long)[foodIdSelected integerValue],(long)[object.associatedFoodId integerValue]];
        [[NSUserDefaults standardUserDefaults]setObject:@"selected" forKey:strForKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self.arraySelectedAssociatedItem addObject:strContact];
    }
    else {
        
        
        NSString *strForKey=[NSString stringWithFormat:@"placeOrderWithAssociatedFood%ld%ld",(long)[foodIdSelected integerValue],(long)[object.associatedFoodId integerValue]];
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:strForKey];
        [self.arraySelectedAssociatedItem removeObject:strContact];
        
        
        
    }
    NSLog(@"_arraySelected %@",_arraySelected);
    
    [self.tblAssociatedItems reloadData];
    
    
}


- (IBAction)clickToSubt:(id)sender {
    
    UIButton *btn=(UIButton *)sender;
    NSString *strContact=  [NSString stringWithFormat:@"%li",btn.tag];
    BOOL flag=   [_arraySelected containsObject:strContact];
    
    NSString *strFromInt = [NSString stringWithFormat:@"%d",1];
    
    //    if(flag == NO )
    //    {
    
    FoodObject *object=[self.arrayFood objectAtIndex:btn.tag];
    // NSString *itemcount = [NSString stringWithFormat:@"%@",strFromInt];
    // object.foodCount= strFromInt;
    NSInteger a=[object.foodCount intValue];
    NSInteger b=[strFromInt intValue];
    NSInteger c=a-b;
    NSString *st = [NSString stringWithFormat:@"%ld", (long)c];
    if (c<=0) {
        [_arraySelected removeObject:strContact];
        object.foodCount= @"0";
    }else{
        object.foodCount= st;
    }
    
    NSLog(@"_arraySelected %@",_arraySelected);
    
    [self.tblFood reloadData];
}


-(void)clickToPlaceOrderList:(id)sender{
    PlaceOrderVC *nav=[[PlaceOrderVC alloc]initWithNibName:@"PlaceOrderVC" bundle:nil];
   
    NSArray *array=[[NSSet setWithArray:self.arraySelected] allObjects];
    for (int i=0; i<array.count; i++) {
        NSString *abc=[array objectAtIndex:i];
        FoodObject *object=[self.arrayFood objectAtIndex:[abc integerValue]];
        [self.arraySelectedfoodSave addObject:object];
          [self.arraySelectedfoodIdsSave addObject:object.foodId];
        NSData * data = [NSKeyedArchiver archivedDataWithRootObject:object];
        NSString *strForKey=[NSString stringWithFormat:@"placeOrder%ld",(long)[object.foodId integerValue]];
        [[NSUserDefaults standardUserDefaults]setObject:data forKey:strForKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }
    NSMutableArray *oldFoodIdArr=[[NSUserDefaults standardUserDefaults]objectForKey:@"oldFoodId"];
    [self saveFoodIdwithOldfoodIdList:oldFoodIdArr];
    
  //  nav.savedArray=self.arraySelectedfoodSave;
   
    
    [self.navigationController pushViewController:nav animated:YES];
    
   
}
-(void)saveFoodIdwithOldfoodIdList:(NSArray *)oldFoodIdsArr{
    NSLog(@" self.arraySelectedfoodIdsSave %@" ,self.arraySelectedfoodIdsSave);
    
    [self.arraySelectedfoodIdsSave  addObjectsFromArray:oldFoodIdsArr];
    [[NSUserDefaults standardUserDefaults]setObject:self.arraySelectedfoodIdsSave  forKey:@"oldFoodId"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self.arraySelectedfoodIdsSave removeAllObjects];
}

-(IBAction)onClickCancel:(id)sender{
    self.viewAssociatedItem.hidden=YES;
}

-(IBAction)onClickAdd:(id)sender{
    self.viewAssociatedItem.hidden=YES;
}


- (void)clickToOpenSearch:(id)sender{
    
    SearchFoodVC *spl=[[SearchFoodVC alloc ]initWithNibName:@"SearchFoodVC" bundle:nil];
    [self.navigationController pushViewController:spl animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
