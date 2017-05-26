//
//  MenuCousineVC.m
//  TABQY MENU
//
//  Created by ASK ONLINE  on 04/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import "MenuCousineVC.h"
#import "ECSServiceClass.h"
#import "AppUserObject.h"
#import "ECSHelper.h"
#import "MenuItemCell.h"
#import "MenuLink.h"
#import "UIExtensions.h"
#import "MBProgressHUD.h"
#import "CousineObject.h"
#import "TableCousineCell.h"
#import "SegmentedCell.h"
#import "FoodTypeObject.h"
#import "MenuFoodCell.h"
#import "FoodObject.h"
#import "FoodDetailVC.h"
#import "PlaceOrderVC.h"
#import "AssociatedFoodObject.h"
#import "TableAssociatedCell.h"
#import "CompleteOrderVC.h"
#import "SearchFoodVC.h"
#import "MVYSideMenuController.h"
@interface MenuCousineVC ()
{
    NSMutableArray *arrayCusine;
    NSMutableArray *arrayfoodType;
    NSIndexPath *inxPath;
    NSString *foodTypeId;
    NSString *foodIdSelected;
}
@property (nonatomic) NSInteger selectedIndex;
@property(weak,nonatomic)IBOutlet UIView *viewTop;
@property(strong,nonatomic) NSMutableArray *arraySelected;
@property(strong,nonatomic) NSMutableArray *arraySelectedCosine;
@property(strong,nonatomic) NSMutableArray *arraySelectedfoodType;
@property(strong,nonatomic) NSMutableArray *arraySelectedfoodSave;
@property(strong,nonatomic) NSMutableArray *arraySelectedfoodIdsSave;
@property(strong,nonatomic) NSMutableArray *arrayAssociated;
@property(strong,nonatomic) NSMutableArray *arraySelectedAssociatedItem;
@property(weak,nonatomic)IBOutlet UIImageView *menuImage;
@property(weak,nonatomic)IBOutlet UIImageView *headerImage;
@property(weak,nonatomic)IBOutlet UILabel *lblHeader;
@property(weak,nonatomic)IBOutlet UILabel *lblMenuname;
@property(weak,nonatomic)IBOutlet UITableView *tblCousine;
@property(weak,nonatomic)IBOutlet UITableView *tblFood;
@property(weak,nonatomic)IBOutlet UITableView *tblAssociatedItems;
@property(weak,nonatomic) NSString *cusineId;
@property(strong,nonatomic) NSMutableArray *arrayFood;
@property (weak, nonatomic) IBOutlet UICollectionView *segmentedCollectionView;
@property(weak,nonatomic)IBOutlet UIImageView *restorentBGImage;
@property(weak,nonatomic)IBOutlet UIImageView *restorentBGImage2;


@property(strong,nonatomic)IBOutlet UIView *viewAssociatedItem;
@end

@implementation MenuCousineVC


- (void)viewDidLoad {
    [super viewDidLoad];
     self.segmentedCollectionView.hidden=YES;
     self.tblFood.hidden=YES;
    arrayCusine=[[NSMutableArray alloc]init];
    arrayfoodType=[[NSMutableArray alloc]init];
    self.arraySelected=[[NSMutableArray alloc]init];
    self.arraySelectedCosine=[[NSMutableArray alloc]init];
    self.arraySelectedfoodType=[[NSMutableArray alloc]init];
    self.arraySelectedfoodSave=[[NSMutableArray alloc]init];
    self.arraySelectedfoodIdsSave=[[NSMutableArray alloc]init];
    self.arrayAssociated=[[NSMutableArray alloc]init];
    self.arraySelectedAssociatedItem=[[NSMutableArray alloc]init];

     [self settingTopView:self.viewTop onController:self andTitle:[NSString stringWithFormat:@"%@ OrderList",self.appUserObject.resturantName] andImg:@"arrow-left.png"];
     [self.lblHeader setText:[NSString stringWithFormat:@"%@ Order List",self.appUserObject.resturantName]];
    self.lblMenuname.text=self.menuName;
    [self.segmentedCollectionView  registerNib:[UINib nibWithNibName:@"SegmentedCell" bundle:nil]forCellWithReuseIdentifier:@"Cell"];
    if (self.appUserObject.resturantMenuImage ==(id)[NSNull null] ||[self.appUserObject.resturantMenuImage isEqualToString:@""]) {
        NSLog(@"ttt %@",self.appUserObject.resturantMenuImage);
      
        
    }else{
       
        NSString *imgurl=[NSString stringWithFormat:@"%@%@",CousineImage,self.appUserObject.resturantMenuImage];
        [self.menuImage ecs_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             // [self.activityProfileImage stopAnimating];
         }];
        
        
    }
    if (self.appUserObject.resturantLogo ==(id)[NSNull null] ||[self.appUserObject.resturantLogo isEqualToString:@""]) {
        NSLog(@"ttt %@",self.appUserObject.resturantLogo);
            }else{
        NSString *imgurl=[NSString stringWithFormat:@"%@%@",RESTORANTLOGO,self.appUserObject.resturantLogo];
        [self.headerImage ecs_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             // [self.activityProfileImage stopAnimating];
         }];
        
        
    }
    
    NSString *imgurl=[NSString stringWithFormat:@"%@%@",RESTORENTBGIMAGE,self.appUserObject.resturantBgImage];
    [self.restorentBGImage ecs_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         // [self.activityProfileImage stopAnimating];
     }];
    [self.restorentBGImage2 ecs_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         // [self.activityProfileImage stopAnimating];
     }];
    [self.segmentedCollectionView setPagingEnabled:YES];
    
  // [self startServiceToGetCousine];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
   
        return arrayfoodType.count;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 5.0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    SegmentedCell *cell =
    (SegmentedCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell"
                                                                forIndexPath:indexPath];

  
        FoodTypeObject * connectionObject = [arrayfoodType objectAtIndex:indexPath.row];
    
        [cell.lblFoodType setText:connectionObject.FoodName];
    
         BOOL flag=   [self.arraySelectedfoodType containsObject:
                  [NSString stringWithFormat:@"%li",indexPath.row]];
    
    
    
    
    
    if(flag == NO )
    {
    
    cell.viewBg.backgroundColor=[JKSColor colorwithHexString:self.appUserObject.sidebarColor alpha:1.0];
      
        
    }
    else {
    cell.viewBg.backgroundColor=[JKSColor colorwithHexString:self.appUserObject.sidebarActiveColor alpha:1.0];
        
    }
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(230, 50);
}

-(void)collectionView:(UICollectionView *)cv didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
   
    FoodTypeObject * connectionObject = [arrayfoodType objectAtIndex:indexPath.row];
    foodTypeId=connectionObject.foodId;
    
    NSLog(@"indexpath %ld",(long)indexPath.row);

     self.selectedIndex = indexPath.row;
  
    if (self.selectedIndex > 0 && self.selectedIndex < arrayfoodType.count - 1) {
        
        [self.segmentedCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        
    }else{
        NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
        
        [self.segmentedCollectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    }
    
    
    NSString *strContact=  [NSString stringWithFormat:@"%li",indexPath.row];
    BOOL flag=   [self.arraySelectedCosine containsObject:strContact];
    
    self.arraySelectedfoodType=[[NSMutableArray alloc]init];
    
    if(flag == NO )
    {
        [self.arraySelectedfoodType addObject:strContact];
    }else{
        [self.arraySelectedfoodType addObject:strContact];
    }
   
    
    [self.segmentedCollectionView reloadData];

    
    
    
    [self startServiceToGetFood];
    
}


- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (self.isScrollingRemote)
//        return;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.selectedIndex inSection:0];
    UICollectionViewCell *cell = [self.segmentedCollectionView cellForItemAtIndexPath:indexPath];
//    CGRect frame = [cell convertRect:cell.bounds toView:self];
//    self.imgSelectedTab.frame = frame;
//    
//    self.isLastCollectionScroll = YES;
}

- (void) reloadWithSelectedIndex:(NSInteger)itemIndex {
    self.selectedIndex = itemIndex;
    [self.segmentedCollectionView reloadData];
//    self.lastScrollingValue = 0;
//    self.isScrollingRemote = NO;
}





-(void)viewWillAppear:(BOOL)animated{
    [self.view layoutIfNeeded];
    arrayCusine=[[NSMutableArray alloc]init];
    arrayfoodType=[[NSMutableArray alloc]init];
    self.arraySelected=[[NSMutableArray alloc]init];
    self.arraySelectedCosine=[[NSMutableArray alloc]init];
    self.arraySelectedfoodType=[[NSMutableArray alloc]init];
    self.arraySelectedfoodSave=[[NSMutableArray alloc]init];
    self.arraySelectedfoodIdsSave=[[NSMutableArray alloc]init];
    self.arrayAssociated=[[NSMutableArray alloc]init];
    self.arraySelectedAssociatedItem=[[NSMutableArray alloc]init];
     [self startServiceToGetCousine];
      [self.segmentedCollectionView scrollToItemAtIndexPath:inxPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];

}

-(void)startServiceToGetCousine
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToGetCousine) withObject:nil];
    
    
}

-(void)serviceToGetCousine
{
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
    
    [class setServiceURL:[NSString stringWithFormat:@"%@cusinie",SERVERURLPATH]];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                         self.appUserObject.resturantId, @"resturant_id",
                         
                          nil];
    
    [class addJson:dict];
    [class setCallback:@selector(callBackServiceToGetCousine:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToGetCousine:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
        arrayCusine=[[NSMutableArray alloc]init];

        NSArray *arr=[rootDictionary valueForKey:@"cusinie"];
        for (NSDictionary * dictionary in arr)
        {
            
            CousineObject  *object=[CousineObject instanceFromDictionary:dictionary];
            
            [arrayCusine addObject:object];
          
        }
        
         [self.arraySelectedCosine addObject:@"0"];
       [self.tblCousine reloadData];
        CousineObject * object = [arrayCusine objectAtIndex:0];
        self.cusineId=object.cusineId;
        [self startServiceToGetFoodtype];
        
       // [self startServiceToGetFoodtype];
        if ([[rootDictionary objectForKey:@"msg"] isEqualToString:@"Successfully LoggedIn"]) {
                    
           
            
          //  [self.navigationController popViewControllerAnimated:YES];
            
            
        }else{
          //  [ECSAlert showAlert:[rootDictionary objectForKey:@"msg"]];
        }
    }
    else [ECSAlert showAlert:@"Error!"];
    
}

-(void)startServiceToGetFoodtype
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToGetFoodtype) withObject:nil];
    
    
}

-(void)serviceToGetFoodtype
{
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
    
    [class setServiceURL:[NSString stringWithFormat:@"%@foodtype",SERVERURLPATH]];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          self.appUserObject.resturantId, @"resturant_id",
                          self.cusineId,@"cusinie_id",
                          nil];
    
    [class addJson:dict];
    [class setCallback:@selector(callBackServiceToGetFoodtype:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToGetFoodtype:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
 
        arrayfoodType=[[NSMutableArray alloc]init];
        NSArray *arr=[rootDictionary valueForKey:@"foodtype"];
        for (NSDictionary * dictionary in arr)
        {
            
            FoodTypeObject  *object=[FoodTypeObject instanceFromDictionary:dictionary];
            
            [arrayfoodType addObject:object];
            
        }
       // [arrayfoodType addObjectsFromArray:arrayfoodType];
            [self.arraySelectedfoodType addObject:@"0"];
        [self.segmentedCollectionView reloadData];
      
        if ([[rootDictionary objectForKey:@"msg"] isEqualToString:@"Foodtype not found!"]) {
            
            self.segmentedCollectionView.hidden=YES;
            self.tblFood.hidden=YES;
          [ECSAlert showAlert:[rootDictionary objectForKey:@"msg"]];
            
            
        }else{
             self.segmentedCollectionView.hidden=NO;
             self.tblFood.hidden=NO;
           
            FoodTypeObject * connectionObject = [arrayfoodType objectAtIndex:0];
            foodTypeId=connectionObject.foodId;
            [self startServiceToGetFood];
            self.arraySelectedfoodType=[[NSMutableArray alloc]init];
             [self.arraySelectedfoodType addObject:@"0"];
            
          //
            //  [ECSAlert showAlert:[rootDictionary objectForKey:@"msg"]];
        }
    }
    else [ECSAlert showAlert:@"Error!"];
    
}

-(void)startServiceToGetFood
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToGetFood) withObject:nil];
    
    
}

-(void)serviceToGetFood
{
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
    
    [class setServiceURL:[NSString stringWithFormat:@"%@food",SERVERURLPATH]];
   
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          self.appUserObject.resturantId, @"resturant_id",
                          self.cusineId,@"cusinie_id",
                          foodTypeId, @"foodtype_id",
                          self.menuId,@"menu_id",
                          nil];
    
    [class addJson:dict];
    [class setCallback:@selector(callBackServiceToGetFood:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToGetFood:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
        self.arrayFood=[[NSMutableArray alloc]init];
          self.arraySelectedfoodIdsSave=[[NSMutableArray alloc]init];
        NSArray *arr=[rootDictionary valueForKey:@"food"];
        for (NSDictionary * dictionary in arr)
        {
            
            FoodObject  *object=[FoodObject instanceFromDictionary:dictionary];
            
            [self.arrayFood addObject:object];
               }
   
        [self.tblFood reloadData];
        if ([[rootDictionary objectForKey:@"msg"] isEqualToString:@"Food not found!"]) {
            
            self.tblFood.hidden=YES;
            [ECSToast showToast:[rootDictionary objectForKey:@"msg"] view:self.view];
            
        }else{
              _arraySelected=[[NSMutableArray alloc]init];
            self.tblFood.hidden=NO;
            //  [ECSAlert showAlert:[rootDictionary objectForKey:@"msg"]];
        }
    }
    else [ECSAlert showAlert:@"Error!"];
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_tblFood) {
         return self.arrayFood.count;
    }
   else if (tableView==self.tblAssociatedItems) {
        return self.arrayAssociated.count;
    }
    else
    return arrayCusine.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==_tblFood) {
        return 170;
    }
   else if (tableView==self.tblAssociatedItems) {
        return 160;
    }
    else
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_tblFood) {
        static NSString *CellIdentifier = @"Cell";
        
        
        [self.tblFood registerNib:[UINib nibWithNibName:@"MenuFoodCell" bundle:nil]forCellReuseIdentifier:@"Cell"];
        MenuFoodCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
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
            
            [cell.imgFood ecs_setImageWithURL:[NSURL URLWithString:[imgurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"User-image.png"] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
            
        }
        cell.lblFoodprice.text=[NSString stringWithFormat:@"%@ %@",self.appUserObject.resturantCurrency,object.price];
        cell.lbldescription.text=[NSString stringWithFormat:@"%@",object.foodDescription];
        
        
        [cell.btnAdd addTarget:self action:@selector(clickToAdd:) forControlEvents:UIControlEventTouchUpInside];
          [cell.btnDelete addTarget:self action:@selector(clickToSubt:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.btnCheck addTarget:self action:@selector(clickToaddInCart:) forControlEvents:UIControlEventTouchUpInside];
        

        
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
        cell.btnCheck.tag=indexPath.row;
        if (object.foodCount.length) {
             cell.lblCount.text=object.foodCount;
            if ([cell.lblCount.text isEqualToString:@"0"]) {
            [cell.btnCheck setImage:[UIImage imageNamed:@"tick_icon_unselected.png"] forState:UIControlStateNormal];
            }else
             [cell.btnCheck setImage:[UIImage imageNamed:@"tick_icon.png"] forState:UIControlStateNormal];
        }
        
        else{
            
             cell.lblCount.text=@"0";
        }
       
        
        
        
        return cell;
    }
    
    
    
    
    else if (tableView==self.tblAssociatedItems) {
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
    
    
    
    else{
        
    static NSString *CellIdentifier = @"TableCousineCell";
    [self.tblCousine registerNib:[UINib nibWithNibName:@"TableCousineCell" bundle:nil]forCellReuseIdentifier:@"TableCousineCell"];
    TableCousineCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.tblCousine setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    cell.backgroundColor = [UIColor clearColor];
    CousineObject *object=[arrayCusine objectAtIndex:indexPath.row];
    cell.lblCusineName.text=object.cusineName;
   cell.selectionStyle = UITableViewCellSelectionStyleGray;
        BOOL flag=   [self.arraySelectedCosine containsObject:
                      [NSString stringWithFormat:@"%li",indexPath.row]];
  
        if(flag == NO )
        {

            cell.viewCusine.backgroundColor=[JKSColor colorwithHexString:self.appUserObject.sidebarColor alpha:1.0];
            
            
        }
        else {
            cell.viewCusine.backgroundColor=[JKSColor colorwithHexString:self.appUserObject.sidebarActiveColor alpha:1.0];
            
        }
      
    
       
    return cell;
    }
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
    
   
        [self.arraySelectedfoodSave addObject:object];
        [self.arraySelectedfoodIdsSave addObject:object.foodId];
        NSData * data = [NSKeyedArchiver archivedDataWithRootObject:object];
        
        NSString *strForKey=[NSString stringWithFormat:@"placeOrder%ld",(long)[object.foodId integerValue]];
        [[NSUserDefaults standardUserDefaults]setObject:data forKey:strForKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
  
    NSMutableArray *oldFoodIdArr=[[NSUserDefaults standardUserDefaults]objectForKey:@"oldFoodId"];
   NSArray *uniquearray = [[NSSet setWithArray:oldFoodIdArr] allObjects];

    [self saveFoodIdwithOldfoodIdList:uniquearray];
    
//        [[NSUserDefaults standardUserDefaults]setObject:self.arraySelectedfoodIdsSave  forKey:@"oldFoodId"];
//        [[NSUserDefaults standardUserDefaults]synchronize];
    
   
    
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


- (IBAction)clickToaddInCart:(id)sender {
    
    UIButton *btn=(UIButton *)sender;
    NSString *strContact=  [NSString stringWithFormat:@"%li",btn.tag];
    BOOL flag=   [self.arraySelected containsObject:strContact];
    
  //  AssociatedFoodObject *object=[self.arrayAssociated objectAtIndex:btn.tag];
    if(flag == NO )
    {
//        NSArray *array=[[NSSet setWithArray:self.arraySelected] allObjects];
//        for (int i=0; i<array.count; i++) {
//            NSString *abc=[array objectAtIndex:i];
            FoodObject *object=[self.arrayFood objectAtIndex:btn.tag];
        
        if (object.foodCount==0) {
            object.foodCount=@"1";
            //[ECSToast showToast:@"Please add number of item First" view:self.view];
        }else{
            [self.arraySelectedfoodSave addObject:object];
            [self.arraySelectedfoodIdsSave addObject:object.foodId];
            NSData * data = [NSKeyedArchiver archivedDataWithRootObject:object];
            
            NSString *strForKey=[NSString stringWithFormat:@"placeOrder%ld",(long)[object.foodId integerValue]];
            [[NSUserDefaults standardUserDefaults]setObject:data forKey:strForKey];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
       // }
        
//        NSMutableArray *oldFoodIdArr=[[NSUserDefaults standardUserDefaults]objectForKey:@"oldFoodId"];
//        [self saveFoodIdwithOldfoodIdList:oldFoodIdArr];
     
        [[NSUserDefaults standardUserDefaults]setObject:self.arraySelectedfoodIdsSave  forKey:@"oldFoodId"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        }
        
        [self.arraySelected addObject:strContact];
    }
    else {
        

        FoodObject *object=[self.arrayFood objectAtIndex:btn.tag];

        object.foodCount= @"0";
        
        NSString *strForKey=[NSString stringWithFormat:@"placeOrder%ld",[object.foodId integerValue]];
        
        for (NSDictionary * dictionary in object.associatedFood)
        {
            
            AssociatedFoodObject  *associatedFoodObject=[AssociatedFoodObject instanceFromDictionary:dictionary];
            NSString *strForKeyAsso=[NSString stringWithFormat:@"placeOrderWithAssociatedFood%ld%ld",(long)[object.foodId integerValue],(long)[associatedFoodObject.associatedFoodId integerValue]];
            
            
            [ECSUserDefault RemoveObjectFromUserDefaultForKey:strForKeyAsso];
            
        }
        
        [ECSUserDefault RemoveObjectFromUserDefaultForKey:strForKey];
        

        [self.arraySelected removeObject:strContact];
        
        
        
    }
    
    NSLog(@"_arraySelected %@",_arraySelected);
    
    [self.tblFood reloadData];
}
-(void)clickToRemove:(id)sender{
    UIButton *btn=(UIButton *)sender;
    
    
}


- (IBAction)clickToSubt:(id)sender {
    
    UIButton *btn=(UIButton *)sender;
    NSString *strContact=  [NSString stringWithFormat:@"%li",btn.tag];
      NSString *strFromInt = [NSString stringWithFormat:@"%d",1];
        FoodObject *object=[self.arrayFood objectAtIndex:btn.tag];
    
        NSInteger a=[object.foodCount intValue];
        NSInteger b=[strFromInt intValue];
        NSInteger c=a-b;
        NSString *st = [NSString stringWithFormat:@"%ld", (long)c];
        if (c<=0) {
            [_arraySelected removeObject:strContact];
             object.foodCount= @"0";
            
            NSString *strForKey=[NSString stringWithFormat:@"placeOrder%ld",[object.foodId integerValue]];
            
            for (NSDictionary * dictionary in object.associatedFood)
            {
                
                AssociatedFoodObject  *associatedFoodObject=[AssociatedFoodObject instanceFromDictionary:dictionary];
                NSString *strForKeyAsso=[NSString stringWithFormat:@"placeOrderWithAssociatedFood%ld%ld",(long)[object.foodId integerValue],(long)[associatedFoodObject.associatedFoodId integerValue]];
                
                
                [ECSUserDefault RemoveObjectFromUserDefaultForKey:strForKeyAsso];
                
            }
            
            [ECSUserDefault RemoveObjectFromUserDefaultForKey:strForKey];
            
        }else{
        object.foodCount= st;
            [self.arraySelectedfoodSave addObject:object];
            [self.arraySelectedfoodIdsSave addObject:object.foodId];
            NSData * data = [NSKeyedArchiver archivedDataWithRootObject:object];
            
            NSString *strForKey=[NSString stringWithFormat:@"placeOrder%ld",(long)[object.foodId integerValue]];
            [[NSUserDefaults standardUserDefaults]setObject:data forKey:strForKey];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }

    NSLog(@"_arraySelected %@",_arraySelected);
    
    [self.tblFood reloadData];
}



- (IBAction)clickToCosine:(id)sender {
    
   // UIButton *btn=(UIButton *)sender;
   }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (tableView==self.tblCousine) {
        NSString *strContact=  [NSString stringWithFormat:@"%li",indexPath.row];
        BOOL flag=   [self.arraySelectedCosine containsObject:strContact];
        
        self.arraySelectedCosine=[[NSMutableArray alloc]init];
        
        if(flag == NO )
        {
            
            CousineObject * object = [arrayCusine objectAtIndex:indexPath.row];
            self.cusineId=object.cusineId;
            [self startServiceToGetFoodtype];
            [self.arraySelectedCosine addObject:strContact];
        }else{
            [self.arraySelectedCosine addObject:strContact];
        }
        
        
        [self.tblCousine reloadData];

    }
    
    else if (tableView==self.tblAssociatedItems){
        
    }
    else{
        FoodObject*obj=[_arrayFood objectAtIndex:indexPath.row];
        FoodDetailVC *nav=[[FoodDetailVC alloc]initWithNibName:@"FoodDetailVC" bundle:nil];
        nav.foodId=obj.foodId;
        [self.navigationController pushViewController:nav animated:YES];
    }
   
    
    
    
    
}

-(void)clickToPlaceOrderList:(id)sender{
    UIViewController *nav=nil;
    if (self.addMoreSel.length>1) {
        // nav=[[CompleteOrderVC alloc]initWithNibName:@"CompleteOrderVC" bundle:nil];
        CompleteOrderVC *new=[[CompleteOrderVC alloc]init];
        nav = new;
        
        new.selectedOrder=self.addMoreSel;
    }else{
      // nav=[[PlaceOrderVC alloc]initWithNibName:@"PlaceOrderVC" bundle:nil];
        nav = (PlaceOrderVC *) [[PlaceOrderVC alloc]initWithNibName:@"PlaceOrderVC" bundle:nil];
    }
    
  
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
   // nav.savedArray=self.arraySelectedfoodSave;

    [self.navigationController pushViewController:nav animated:YES];
    
   
}
- (void)clickToOpenSearch:(id)sender{
    
    SearchFoodVC *spl=[[SearchFoodVC alloc ]initWithNibName:@"SearchFoodVC" bundle:nil];
    [self.navigationController pushViewController:spl animated:YES];
    
}

-(void)saveFoodIdwithOldfoodIdList:(NSArray *)oldFoodIdsArr{
      NSLog(@" self.arraySelectedfoodIdsSave %@" ,self.arraySelectedfoodIdsSave);
    
    [self.arraySelectedfoodIdsSave  addObjectsFromArray:oldFoodIdsArr];
    [[NSUserDefaults standardUserDefaults]setObject:self.arraySelectedfoodIdsSave  forKey:@"oldFoodId"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    // [self.arraySelectedfoodIdsSave removeAllObjects];
}

-(IBAction)onClickCancel:(id)sender{
       self.viewAssociatedItem.hidden=YES;
}

-(IBAction)onClickAdd:(id)sender{
    self.viewAssociatedItem.hidden=YES;
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
-(IBAction)onClickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
