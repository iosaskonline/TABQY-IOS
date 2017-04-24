//
//  OrderProgressVC.m
//  TABQY MENU
//
//  Created by ASK ONLINE  on 01/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import "OrderProgressVC.h"
#import "AppUserObject.h"
#import "UIExtensions.h"
#import "ECSServiceClass.h"
#import "MBProgressHUD.h"
#import "ECSHelper.h"
#import "OrderInProgressCell.h"
#import "OrderProgressObject.h"
#import "TableListObject.h"
#import "SegmentedCell.h"
#import "PlaceOrderVC.h"
#import "SearchFoodVC.h"
@interface OrderProgressVC ()
{
    NSIndexPath *inxPath;
    NSString *tableId;
}
@property (nonatomic) NSInteger selectedIndex;

@property(weak,nonatomic)IBOutlet UIView *viewTop;
@property(weak,nonatomic)IBOutlet UIImageView *restorentBGImage;
@property(weak,nonatomic)IBOutlet UITableView *tblProgress;
@property(strong,nonatomic)NSMutableArray *arrayCompletedOrder;
@property(strong,nonatomic)NSMutableArray *arrayOrderProgress;
@property(strong,nonatomic)NSMutableArray *arraySelectedTable;
@property(strong,nonatomic)NSMutableArray *arraySelectedIndex;

@property (weak, nonatomic) IBOutlet UICollectionView *segmentedCollectionView;

@end

@implementation OrderProgressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arraySelectedTable=[[NSMutableArray alloc]init];
     self.arraySelectedIndex=[[NSMutableArray alloc]init];
     [self.segmentedCollectionView  registerNib:[UINib nibWithNibName:@"SegmentedCell" bundle:nil]forCellWithReuseIdentifier:@"Cell"];
       [self settingTopView:self.viewTop onController:self andTitle:[NSString stringWithFormat:@"%@ Order Progress",self.appUserObject.resturantName] andImg:@"arrow-left.png"];
    NSString *imgurl=[NSString stringWithFormat:@"%@%@",RESTORENTBGIMAGE,self.appUserObject.resturantBgImage];
    [self.restorentBGImage ecs_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         // [self.activityProfileImage stopAnimating];
     }];
   
//    for (int i=0; i<500; i++) {
//        
//        NSString *key=[NSString stringWithFormat:@"GetSelectedTable%d",i];
//        NSData *data=[ECSUserDefault getObjectFromUserDefaultForKey:key];
//        if (data) {
//            
//            TableListObject *obj=[NSKeyedUnarchiver unarchiveObjectWithData:data];
//            [self.arraySelectedTable addObject:obj];
//        }
//        
//    }
//      [self.segmentedCollectionView setPagingEnabled:YES];
//    [self.arraySelectedIndex addObject:@"0"];
//     NSLog(@"Selected Tables%@",self.arraySelectedTable);
//    [self.segmentedCollectionView reloadData];
   
    [self startServiceToGetOrdertable];
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    return self.arraySelectedTable.count;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 5.0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    SegmentedCell *cell =
    (SegmentedCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell"
                                                               forIndexPath:indexPath];
    
    
    TableListObject * connectionObject = [self.arraySelectedTable objectAtIndex:indexPath.row];
    
    [cell.lblFoodType setText:connectionObject.tableName];
    
    BOOL flag=   [self.arraySelectedIndex containsObject:
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
    return CGSizeMake(170, 45);
}

-(void)collectionView:(UICollectionView *)cv didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
    TableListObject * connectionObject = [self.arraySelectedTable objectAtIndex:indexPath.row];
    tableId=connectionObject.tableId;
    
    NSLog(@"indexpath %ld",(long)indexPath.row);
    
    self.selectedIndex = indexPath.row;
    
    if (self.selectedIndex > 0 && self.selectedIndex < self.arraySelectedTable.count - 1) {
        
        [self.segmentedCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        
    }else{
        NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
        
        [self.segmentedCollectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    }
    
    
    NSString *strContact=  [NSString stringWithFormat:@"%li",indexPath.row];
    BOOL flag=   [self.arraySelectedIndex containsObject:strContact];
    
    self.arraySelectedIndex=[[NSMutableArray alloc]init];
    
    if(flag == NO )
    {
        [self.arraySelectedIndex addObject:strContact];
    }else{
        [self.arraySelectedIndex addObject:strContact];
    }
    
    
    [self.segmentedCollectionView reloadData];
    
    
    
    if (tableId) {
         [self startServiceToGetOrderInProgressByTable];
    }else{
          [self startServiceToGetOrderInProgress];
    }
   
    
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
    [self.segmentedCollectionView scrollToItemAtIndexPath:inxPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    
}














-(void)startServiceToGetOrderInProgress
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToGetOrderInProgress) withObject:nil];
    
    
}

-(void)serviceToGetOrderInProgress
{
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
    //{"user_id": "23","from_date": "2016-11-17","to_date": "2016-11-17"}
    [class setServiceURL:[NSString stringWithFormat:@"%@order_in_progess_list_home_delivery",SERVERURLPATH]];
    NSDate *now = [NSDate date];
    NSString *date=[ECSDate getFormattedDateString:now];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                 self.appUserObject.user_id, @"user_id",
                                 date,@"from_date",
                                 date,@"to_date",
                                 nil];
    
    
    
    [class addJson:dict];
    [class setCallback:@selector(callBackServiceToGetOrderInProgress:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToGetOrderInProgress:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
        
        self.arrayOrderProgress=[[NSMutableArray alloc]init];
       
        NSArray *arr=[rootDictionary valueForKey:@"order_progess"];
        for (NSDictionary * dictionary in arr)
        {
            
            OrderProgressObject  *object=[OrderProgressObject instanceFromDictionary:dictionary];
            
                [self.arrayOrderProgress addObject:object];
            
        
        }
        NSLog(@"arrayCompletedOrder=%@",self.arrayCompletedOrder);
        NSLog(@"arrayOrderProgress=%@",self.arrayOrderProgress);
        [self.tblProgress reloadData];
    }
    
    else [ECSAlert showAlert:@"Error!"];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
        return self.arrayOrderProgress.count;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 70;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    
    [self.tblProgress registerNib:[UINib nibWithNibName:@"OrderInProgressCell" bundle:nil]forCellReuseIdentifier:@"Cell"];
    OrderInProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.tblProgress setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    cell.backgroundColor = [UIColor clearColor];
    OrderProgressObject *object;
        object=[self.arrayOrderProgress objectAtIndex:indexPath.row];
        
    cell.lblwaiterName.text=object.waiter_name;
    cell.lblOrderTime.text=object.order_time;
    cell.lblOrderDate.text=object.order_date;
    cell.lblOrderNo.text=object.order_no;
        
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startServiceToGetOrderInProgressByTable
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToGetOrderInProgressByTable) withObject:nil];
    
    
}

-(void)serviceToGetOrderInProgressByTable
{
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
    //{"user_id": "23","from_date": "2016-11-17","to_date": "2016-11-17"}
    [class setServiceURL:[NSString stringWithFormat:@"%@order_in_progess_list_by_table",SERVERURLPATH]];
    NSDate *now = [NSDate date];
    NSString *date=[ECSDate getFormattedDateString:now];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                 self.appUserObject.user_id, @"user_id",
                                 tableId,@"table_id",
                                 date,@"from_date",
                                 date,@"to_date",
                                 nil];
    
    [class addJson:dict];
    [class setCallback:@selector(callBackServiceToGetOrderInProgressByTable:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToGetOrderInProgressByTable:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
        
        self.arrayOrderProgress=[[NSMutableArray alloc]init];
        // self.arrayCompletedOrder=[[NSMutableArray alloc]init];
        NSArray *arr=[rootDictionary valueForKey:@"order_progess"];
        for (NSDictionary * dictionary in arr)
        {
            
            OrderProgressObject  *object=[OrderProgressObject instanceFromDictionary:dictionary];
            
            [self.arrayOrderProgress addObject:object];
            
            
            
            
            
        }
        NSLog(@"arrayCompletedOrder=%@",self.arrayCompletedOrder);
        NSLog(@"arrayOrderProgress=%@",self.arrayOrderProgress);
        [self.tblProgress reloadData];
    }
    
    else [ECSAlert showAlert:@"Error!"];
    
}


-(void)startServiceToGetOrdertable
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToGetOrdertable) withObject:nil];
    
    
}
-(void)serviceToGetOrdertable
{
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
    //{"user_id": "23","from_date": "2016-11-17","to_date": "2016-11-17"}
    [class setServiceURL:[NSString stringWithFormat:@"%@waiter_progress_table",SERVERURLPATH]];
    NSDate *now = [NSDate date];
    NSString *date=[ECSDate getFormattedDateString:now];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                 self.appUserObject.user_id, @"waiter_id",
                                 date,@"from_date",
                                 date,@"to_date",
                                 nil];
    
    [class addJson:dict];
    [class setCallback:@selector(callBackServiceToGetOrdertable:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToGetOrdertable:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
          [self.arraySelectedIndex addObject:@"0"];
        self.arrayOrderProgress=[[NSMutableArray alloc]init];
       
        NSArray *arr=[rootDictionary valueForKey:@"waitertable"];
            for (NSDictionary * dictionary in arr)
            {
                
                TableListObject  *object=[ TableListObject instanceFromDictionary:dictionary];
                
                [self.arraySelectedTable addObject:object];
                
                
                
            }
        
       
        
        
            TableListObject *homeDelivery=[[TableListObject alloc]init];
            homeDelivery.tableName=@"home Delivery";
            homeDelivery.tableId=nil;
            homeDelivery.restaurentId=@"home Delivery";
            [self.arraySelectedTable addObject:homeDelivery];
            if (self.arraySelectedTable.count>1) {
                TableListObject * connectionObject = [self.arraySelectedTable objectAtIndex:0];
                if (connectionObject.tableId) {
                    tableId=connectionObject.tableId;
                    [self startServiceToGetOrderInProgressByTable];
                }
            }else{
                [self startServiceToGetOrderInProgress];
            }

        NSLog(@"arrayCompletedOrder=%@",self.arrayCompletedOrder);
        NSLog(@"arrayOrderProgress=%@",self.arrayOrderProgress);
        [self.segmentedCollectionView reloadData];
    }
    
    else [ECSAlert showAlert:@"Error!"];
    
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
@end
