//
//  DS_SideMenuVC.m
//  DSale_Sale
//
//  Created by Daksha_Mac4 on 1/3/16.
//  Copyright © 2016 Daksha_Mac4. All rights reserved.
//

#import "DS_SideMenuVC.h"
#import "DS_SidemenuCell.h"
#import "AppUserObject.h"
#import "MVYSideMenuController.h"
#import "LoginVC.h"
#import "MenuItemObject.h"
#import "MenuItemVC.h"
#import "HotDealVC.h"
#import "OrderHistryVC.h"
#import "OrderProgressVC.h"
#import "ASK_HomeVC.h"
#import "FeedBackVC.h"
#import "TodaySplVC.h"
#import "TableListVC.h"
#import "WaiterProfileVC.h"
#import "ECSHelper.h"
#import "AboutRestaurantVC.h"
@interface DS_SideMenuVC ()<UITableViewDelegate,UITableViewDataSource>

{
    BOOL ischecked;
    NSMutableArray *imgArrayList;
    NSString *selectedcell;
    NSArray *itemArray;
    NSMutableArray *selectedIndex;
    
    NSString *sideBarColor;
    NSString *sideBarActiveColor;
}
//@property (weak, nonatomic) IBOutlet UICollectionView *Contacts_CollectionView;

@property (strong, nonatomic) NSMutableArray *slidemenuArray;
@property (nonatomic, strong) NSMutableArray* dataArray1;
@property (nonatomic, strong) NSMutableArray* headers;
//@property (nonatomic, retain) CH_HomeVC * homeScreen;
@property(strong,nonatomic)IBOutlet UIView *viewHighlighted;
@property(strong,nonatomic)IBOutlet UIView *viewReplace;
@property(strong,nonatomic)IBOutlet UIView *viewFooter;
@property(strong,nonatomic)IBOutlet UIView *viewHeader;
@property(strong,nonatomic)IBOutlet UIView *viewAlert;
@property(strong,nonatomic)IBOutlet UILabel *lblHighlighted;
@property(strong,nonatomic)IBOutlet UILabel *lblGotit;
@property(strong,nonatomic)IBOutlet UIButton *btnGotit;;
@property(strong,nonatomic)IBOutlet UIImageView *imgPlaceholder;;
//@property(strong,nonatomic)IBOutlet UIScrollView *tutScroll;
@property(strong,nonatomic)IBOutlet UILabel *lblHeader;
@property(strong,nonatomic)IBOutlet UILabel *lblAlert;
- (IBAction)clickToCrsoss:(id)sender;
@property NSInteger selectedHeaderIndex;

@end

@implementation DS_SideMenuVC





- (void)viewDidLoad {
    // [self.sideMenuTable tableViewScrollToBottomAnimated:NO];
    self.slidemenuArray=[[NSMutableArray alloc]init];
    imgArrayList=[[NSMutableArray alloc]init];
    
    
    MenuItemObject *table=[[MenuItemObject alloc]init];
    table.name=@"Table";
    table.image=@"table_icon.png";
    
    MenuItemObject *dashbord=[[MenuItemObject alloc]init];
    dashbord.name=@"Dashbord";
    dashbord.image=@"dashboard_icon_menu.png";
    
    MenuItemObject *menu=[[MenuItemObject alloc]init];
    menu.name=@"Menu";
    menu.image=@"menu_icon.png";
    
    MenuItemObject *spl=[[MenuItemObject alloc]init];
    spl.name=@"Today’s Special";
    spl.image=@"today's_special_icon.png";
    
    
    MenuItemObject *hDeal=[[MenuItemObject alloc]init];
    hDeal.name=@"Hot Deal";
    hDeal.image=@"hot_deals_icon.png";
    
    MenuItemObject *orderProgress=[[MenuItemObject alloc]init];
    orderProgress.name=@"Order in Progress";
    orderProgress.image=@"order_in_progress_icon.png";
    
    MenuItemObject *oHistry=[[MenuItemObject alloc]init];
    oHistry.name=@"Order Histry";
    oHistry.image=@"order_history_icon.png";
    
    MenuItemObject *feedBack=[[MenuItemObject alloc]init];
    feedBack.name=@"FeedBack";
    feedBack.image=@"feedback_icon.png";
    
    MenuItemObject *about=[[MenuItemObject alloc]init];
    about.name=@"About Restaurant";
    about.image=@"about_restaurant_icon.png";
    
    
    MenuItemObject *profile=[[MenuItemObject alloc]init];
    profile.name=@"My Profile";
    profile.image=@"my_profile_icon.png";
    
    MenuItemObject *logout=[[MenuItemObject alloc]init];
    logout.name=@"Logout";
    logout.image=@"log_out_icon.png";

   itemArray = [NSArray arrayWithObjects:table, dashbord,menu,spl,hDeal,orderProgress,oHistry,feedBack,about,profile,logout, nil];

    [imgArrayList addObject:@"table_icon_hover-1.png"];
    [imgArrayList addObject:@"dashboard_icon_hover.png"];
    [imgArrayList addObject:@"menu_icon_hover.png"];
    [imgArrayList addObject:@"today's_special_hover.png"];//
    [imgArrayList addObject:@"hot_deals_hover.png"];//
    [imgArrayList addObject:@"order_in_progress_hover.png"];
    [imgArrayList addObject:@"order_history_hover.png"];//
    [imgArrayList addObject:@"feedback_hover.png"];//
    [imgArrayList addObject:@"about_restaurant_icon_hover-1.png"];
    [imgArrayList addObject:@"my_profile_icon_hover-1.png"];
    [imgArrayList addObject:@"log_out_icon_hover-1.png"];

    self.sideMenuTable.delegate=self;
    self.sideMenuTable.dataSource=self;
    [super viewDidLoad];
    
    sideBarColor=self.appUserObject.sidebarColor;
    sideBarActiveColor=self.appUserObject.sidebarActiveColor;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateActionSideMenu:)
                                                 name:@"LoginUpdateForSidemenu"
                                               object:nil];
   
}



- (void)updateActionSideMenu:(NSNotification *) notification
{
    //NSLog(@"fdgfgrf%@",notification.object);
    AppUserObject *userData=notification.object;
   // NSString *scrName=[NSString stringWithFormat:@"%@ Dashbord",userData.resturantName];
    
    NSLog(@" test==%@ ",userData.sidebarColor);
    NSLog(@" testActive==%@ ",userData.sidebarActiveColor);
    sideBarColor=userData.sidebarColor;
    sideBarActiveColor=userData.sidebarActiveColor;
    [self.sideMenuTable reloadData];
   // [JKSColor colorwithHexString:userData.sidebarActiveColor alpha:1.0];
    
  }








- (void)scrollToBottom
{
    [self.sideMenuTable setContentOffset:CGPointMake(0, 430)];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    NSLog(@"screenSize %f",screenSize.height);
    if (screenSize.height >= 736){
        [self.sideMenuTable setContentOffset:CGPointMake(0, 360)];
    }
    
    if (screenSize.height == 568){
        [self.sideMenuTable setContentOffset:CGPointMake(0, 520)];
    }
}
- (void)scrollToBottom1
{ if(self.appUserObject==nil){
    [self.sideMenuTable setContentOffset:CGPointMake(0, 0)];
}else{
    [self.sideMenuTable setContentOffset:CGPointMake(0, 0)];
}
}
-(void)gestureHandlerMethod:(UITapGestureRecognizer*)sender {
    
    self.viewHighlighted.hidden=YES;
    // self.viewHighletedSecond.hidden=YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    //self.view.frame=CGRectMake(0, 0, 290, self.view.frame.size.height);
}
-(void)viewWillAppear:(BOOL)animated {
    
    
    NSLog(@"CAll API view will appear");
}

- (void)receiveAppName:(NSNotification *) notification
{
   

}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return itemArray.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"DS_SidemenuCell";

    
    [self.sideMenuTable registerNib:[UINib nibWithNibName:@"DS_SidemenuCell" bundle:nil]forCellReuseIdentifier:@"DS_SidemenuCell"];
    DS_SidemenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.sideMenuTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    cell.backgroundColor = [UIColor clearColor];
    MenuItemObject *obj=[itemArray objectAtIndex:indexPath.row];
    cell.lbl_sidemenuLabel.text=obj.name;
    [cell.imgCatergory setImage:[UIImage imageNamed:obj.image]];
    
    
    
    BOOL flag=   [selectedIndex containsObject:
                  [NSString stringWithFormat:@"%li",indexPath.row]];
    
    
    
    
    
    if(flag == NO )
    {
        [cell.imgCatergory setImage:[UIImage imageNamed:obj.image]];
        cell.lbl_sidemenuLabel.textColor=[UIColor whiteColor];
        cell.backgroundColor=[JKSColor colorwithHexString:sideBarColor alpha:1.0];
    }
    else {
        
        
          [cell.imgCatergory setImage:[UIImage imageNamed:[imgArrayList objectAtIndex:indexPath.row]]];
       //  cell.lbl_sidemenuLabel.textColor=[JKSColor colorwithHexString:self.appUserObject.sidebarActiveColor alpha:1.0];
         cell.backgroundColor=[JKSColor colorwithHexString:sideBarActiveColor alpha:1.0];
    }
    
   // cell.btnCheck.tag=indexPath.row;

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    selectedIndex =[[NSMutableArray alloc]init];
       UIViewController * contentScreen = nil;
    NSString *strContact=[NSString stringWithFormat:@"%li",indexPath.row];
   // MenuItemObject * connectionObject = [itemArray objectAtIndex:indexPath.row];;
    BOOL flag=   [selectedIndex containsObject:strContact];
   // NSString *contactId=connectionObject.image;
    if(flag == NO )
    {
        
      //  [btn setImage:[UIImage imageNamed:@"checked-icon.png"] forState:UIControlStateNormal];
        [selectedIndex addObject:strContact];
       
    }
    else {
        
       
    
        [selectedIndex removeObject:strContact];
               //[_arraySelected removeObject:strContact];
    }

    [self.sideMenuTable reloadData];
//    {
//        
    
        [self.sideMenuController closeMenu];
    if (indexPath.row==0) {
        contentScreen = (TableListVC *) [[TableListVC alloc]initWithNibName:@"TableListVC" bundle:nil];
       
    }else if (indexPath.row==1){
        [ECSUserDefault saveString:@"" ToUserDefaultForKey:@"tablename"];
        [ECSUserDefault saveString:@"" ToUserDefaultForKey:@"tableId"];
    }else if (indexPath.row==2){
          contentScreen = (MenuItemVC *) [[MenuItemVC alloc]initWithNibName:@"MenuItemVC" bundle:nil];
    }else if (indexPath.row==3){
         contentScreen = (TodaySplVC *) [[TodaySplVC alloc]initWithNibName:@"TodaySplVC" bundle:nil];
    }else if (indexPath.row==4){
        contentScreen = (HotDealVC *) [[HotDealVC alloc]initWithNibName:@"HotDealVC" bundle:nil];
    }else if (indexPath.row==5){
        contentScreen = (OrderProgressVC *) [[OrderProgressVC alloc]initWithNibName:@"OrderProgressVC" bundle:nil];
    }else if (indexPath.row==6){
        contentScreen = (OrderHistryVC *) [[OrderHistryVC alloc]initWithNibName:@"OrderHistryVC" bundle:nil];
    }else if (indexPath.row==7){
        contentScreen = (FeedBackVC *) [[FeedBackVC alloc]initWithNibName:@"FeedBackVC" bundle:nil];
    }else if (indexPath.row==8){
        contentScreen = (AboutRestaurantVC *) [[AboutRestaurantVC alloc]initWithNibName:@"AboutRestaurantVC" bundle:nil];
    }else if (indexPath.row==9){
        contentScreen = (WaiterProfileVC *) [[WaiterProfileVC alloc]initWithNibName:@"WaiterProfileVC" bundle:nil];
    }
    else{
        [AppUserObject removeFromUserDefault];
    
        contentScreen = (LoginVC *) [[LoginVC alloc]initWithNibName:@"LoginVC" bundle:nil];
       
    }
    
    if(contentScreen){
        [self.sideMenuController.navigationController pushViewController:contentScreen animated:NO];
        
    }


}


@end

