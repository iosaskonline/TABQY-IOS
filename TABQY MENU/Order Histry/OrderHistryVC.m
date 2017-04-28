//
//  OrderHistryVC.m
//  TABQY MENU
//
//  Created by ASK ONLINE  on 01/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import "OrderHistryVC.h"
#import "AppUserObject.h"
#import "ECSServiceClass.h"
#import "UIExtensions.h"
#import "ECSHelper.h"
#import "MBProgressHUD.h"
#import "OrderHistryObject.h"
#import "OrderHistoryTableCell.h"
#import "TableListObject.h"
#import "OrderTableCell.h"
#import "CompleteOrderVC.h"
#import "PlaceOrderVC.h"
#import "SearchFoodVC.h"
#import "FeedBackVC.h"
@interface OrderHistryVC ()
{
    NSString *tbleId;
}
@property(weak,nonatomic)IBOutlet UIView *viewTop;
@property(weak,nonatomic)IBOutlet UIImageView *restorentBGImage;
@property(weak,nonatomic)IBOutlet UITextField *fromDate;
@property(weak,nonatomic)IBOutlet UITextField *toDate;
@property(weak,nonatomic)IBOutlet UITableView *tblHistory;
@property(weak,nonatomic)IBOutlet UITextField *txtTableName;
@property(strong,nonatomic)NSMutableArray *arrayCompletedOrder;
@property(strong,nonatomic)NSMutableArray *arrayOrderProgress;
@property(strong,nonatomic)NSMutableArray *arrayTable;
@property(strong,nonatomic)IBOutlet UIView *viewSectionHeader;
@property(strong,nonatomic)IBOutlet UIView *vietableHeader;


@property (strong, nonatomic) IBOutlet UIDatePicker *pickerStartTime;
@property (strong, nonatomic) IBOutlet UIDatePicker *pickerEndTime;

@property(weak,nonatomic)IBOutlet UITableView *tblAllTable;
@property(strong,nonatomic)IBOutlet UIView *viewAllTable;
@end

@implementation OrderHistryVC

- (void)viewDidLoad {
    [super viewDidLoad];
     [self settingTopView:self.viewTop onController:self andTitle:[NSString stringWithFormat:@"%@ Order Histry",self.appUserObject.resturantName] andImg:@"arrow-left.png"];
    NSString *imgurl=[NSString stringWithFormat:@"%@%@",RESTORENTBGIMAGE,self.appUserObject.resturantBgImage];
    [self.restorentBGImage ecs_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         // [self.activityProfileImage stopAnimating];
     }];
    // Do any additional setup after loading the view from its nib.
     NSDate *now = [NSDate date];
     NSString *date=[ECSDate getFormattedDateString:now];
    self.fromDate.text=date;
    self.toDate.text=date;
    self.tblHistory.tableHeaderView=self.vietableHeader;
    [self.fromDate setNumberKeybord:self withLeftTitle:@"Clear" andRightTitle:@"Done"];
    [self.toDate setNumberKeybord:self withLeftTitle:@"Clear" andRightTitle:@"Done"];
    self.pickerStartTime.date = [ECSDate dateAfterHours:0 fromDate:[NSDate date]];
    self.pickerEndTime.date = [ECSDate dateAfterMins:0 fromDate:self.pickerStartTime.date];
    
    [self.fromDate setText:[ECSDate getStringFromDate:self.pickerStartTime.date inFormat:@"yyyy-MM-dd"]];
    [self.toDate setText:[ECSDate getStringFromDate:self.pickerEndTime.date inFormat:@"yyyy-MM-dd"]];
    
    [self.fromDate setInputView:self.pickerStartTime];
    [self.toDate setInputView:self.pickerEndTime];
    [self startServiceToGetOrderHistory];
    [self startServiceToGetAllTable];
}



-(void)startServiceToGetOrderHistory
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToGetOrderHistory) withObject:nil];
    
    
}

-(void)serviceToGetOrderHistory
{
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
    //{"from_date": "2016-11-17","to_date": "2016-11-17"} or{"table_id":"9"} or {"table_id": "9","from_date": "2016-11-17","to_date": "2016-11-17"} or {"type": "1","from_date": "2016-11-26","to_date": "2016-12-12"}
    [class setServiceURL:[NSString stringWithFormat:@"%@order_history",SERVERURLPATH]];
    NSDate *now = [NSDate date];
    NSString *date=[ECSDate getFormattedDateString:now];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                 date,@"from_date",
                                 date,@"to_date",
                                 tbleId,@"table_id",
                                 nil];
    
    
    
    [class addJson:dict];
    [class setCallback:@selector(callBackServiceToGetOrderHistory:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToGetOrderHistory:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
        
        
        if ([[rootDictionary objectForKey:@"msg"] isEqualToString:@"Record not requried"]) {
           // [ECSAlert showAlert:@"Record not found"];
            [ECSToast showToast:@"Record not found" view:self.view];
            self.tblHistory.hidden=YES;
        }else{
            
            self.arrayOrderProgress=[[NSMutableArray alloc]init];
            self.arrayCompletedOrder=[[NSMutableArray alloc]init];
            NSArray *arr=[rootDictionary valueForKey:@"order_history"];
            for (NSDictionary * dictionary in arr)
            {
                
                OrderHistryObject  *object=[OrderHistryObject instanceFromDictionary:dictionary];
                if ([object.orderSatatus isEqualToString:@"1"]) {
                    [self.arrayCompletedOrder addObject:object];
                }else{
                    [self.arrayOrderProgress addObject:object];
                }
                
            }
            
        self.tblHistory.hidden=NO;
        [self.tblHistory reloadData];
        }
    }
    else [ECSAlert showAlert:@"Error!"];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView==self.tblHistory) {
         return 2 ;
    }else
        return 1;
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView==self.tblHistory) {
    
    if (section==0)
    {
        return [self.arrayOrderProgress count];
    }
    else{
        return [self.arrayCompletedOrder count];
    }
    }else return self.arrayTable.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==self.tblAllTable) {
        return 40;
    }else
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }else
    return 120.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView==self.tblHistory) {

    if (section==0) {
         return self.viewSectionHeader;
    }else
    return self.viewSectionHeader;
    }else{
        return 0;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.tblHistory) {
        
    static NSString *CellIdentifier = @"Cell";
    
    
  [self.tblHistory registerNib:[UINib nibWithNibName:@"OrderHistoryTableCell" bundle:nil]forCellReuseIdentifier:@"Cell"];
    OrderHistoryTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.tblHistory setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    cell.backgroundColor = [UIColor clearColor];
    OrderHistryObject *object;
        [cell.btnDetail addTarget:self action:@selector(clickToshowDetail:) forControlEvents:UIControlEventTouchUpInside];
       // [cell.btnFeedback addTarget:self action:@selector(clickToFeedback:) forControlEvents:UIControlEventTouchUpInside];


    if (indexPath.section==0) {
        // cell.btnFeedback.hidden=YES;
         cell.btnDetail.hidden=NO;
         object=[self.arrayOrderProgress objectAtIndex:indexPath.row];
    [cell.btnFeedback addTarget:self action:@selector(clickToFeedback:) forControlEvents:UIControlEventTouchUpInside];
    }else{
         object=[self.arrayCompletedOrder objectAtIndex:indexPath.row];
          cell.btnFeedback.hidden=NO;
        cell.btnDetail.hidden=YES;
 [cell.btnFeedback addTarget:self action:@selector(clickToFeedbackFromComplete:) forControlEvents:UIControlEventTouchUpInside];
    }
   
    cell.lbldate.text=object.orderDate;
    cell.lblvalue.text=object.orderValue;
    cell.lblOrderTime.text=object.ordrTime;
    cell.lbltablename.text=object.tableName;
    if ([cell.lbltablename.text isEqualToString:@""]) {
        cell.lbltablename.text=@"Home Delivery";
    }
    cell.lblwaitername.text=object.waiterName;
        cell.btnDetail.tag=indexPath.row;
         cell.btnFeedback.tag=indexPath.row;
    return cell;
    }else{
        static NSString *CellIdentifier = @"Cell";
        [self.tblAllTable registerNib:[UINib nibWithNibName:@"OrderTableCell" bundle:nil]forCellReuseIdentifier:@"Cell"];
        OrderTableCell *cell = [self.tblAllTable dequeueReusableCellWithIdentifier:CellIdentifier ];
        
        cell.lbltableName.text=[NSString stringWithFormat:@"Table %ld",(long)indexPath.row];
        TableListObject * connectionObject = [self.arrayTable objectAtIndex:indexPath.row];
        
        cell.lbltableName.text=connectionObject.tableName;
        
        return cell;
    }

    }

-(void)clickToshowDetail:(id)sender{
    UIButton *btn=(UIButton *)sender;
    OrderHistryObject *object=[self.arrayOrderProgress objectAtIndex:btn.tag];
    //NSString *ordernum=object.orderNum;
    CompleteOrderVC *nav=[[CompleteOrderVC alloc]initWithNibName:@"CompleteOrderVC" bundle:nil];
    nav.orderObj=object;
    [self.navigationController pushViewController:nav animated:YES];
}

-(void)clickToFeedback:(id)sender{
    UIButton *btn=(UIButton *)sender;
    OrderHistryObject *object=[self.arrayOrderProgress objectAtIndex:btn.tag];
    
    FeedBackVC *nav=[[FeedBackVC alloc]initWithNibName:@"FeedBackVC" bundle:nil];
    nav.orderObj=object;
    [self.navigationController pushViewController:nav animated:YES];
}

-(void)clickToFeedbackFromComplete:(id)sender{
    UIButton *btn=(UIButton *)sender;
    OrderHistryObject *object=[self.arrayCompletedOrder objectAtIndex:btn.tag];

    FeedBackVC *nav=[[FeedBackVC alloc]initWithNibName:@"FeedBackVC" bundle:nil];
    nav.orderObj=object;
    [self.navigationController pushViewController:nav animated:YES];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==self.tblAllTable) {
        TableListObject * connectionObject = [self.arrayTable objectAtIndex:indexPath.row];
    
        tbleId=connectionObject.tableId;
        self.txtTableName.text=connectionObject.tableName;
        // tbleId=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    }
    
    self.viewAllTable.hidden=YES;
   // [self startServiceToSubmitFoodOrder];
    
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
        self.arrayTable=[[NSMutableArray alloc]init];
        NSArray *arr=[rootDictionary valueForKey:@"waitertable"];
        for (NSDictionary * dictionary in arr)
        {
            TableListObject  *object=[TableListObject instanceFromDictionary:dictionary];
            
            [self.arrayTable addObject:object];
        }
        
        [self.tblAllTable reloadData];
    }
    
    else [ECSAlert showAlert:@"Error!"];
    
}

-(IBAction)onChooseTable:(id)sender{
    self.viewAllTable.hidden=NO;
    [self.view addSubview:self.viewAllTable];
}

-(IBAction)onClickGo:(id)sender{
    [self startServiceToGetOrderHistory];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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



- (IBAction)clickToSetStartTime:(id)sender {
    
    
    [self.fromDate setText:[ECSDate getStringFromDate:self.pickerStartTime.date inFormat:@"yyyy-MM-dd"]];
    
}


- (IBAction)clickToSetEndTime:(id)sender {
    
    [self.toDate setText:[ECSDate getStringFromDate:self.pickerEndTime.date inFormat:@"yyyy-MM-dd"]];
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
     if(self.fromDate == textField)
    {
        //         [self resignTextResponder];
        [self.fromDate setText:[ECSDate getStringFromDate:self.pickerStartTime.date inFormat:@"yyyy-MM-dd"]];
        
        //        [self.pickerStartTime setHidden:NO];
        //        return NO;
        
    }
    else if(self.toDate == textField)
    {
        //         [self resignTextResponder];
        [self.toDate setText:[ECSDate getStringFromDate:self.pickerEndTime.date inFormat:@"yyyy-MM-dd"]];
        
        //        [self.pickerStartTime setHidden:NO];
        //        return NO;
        
    }
    return YES;
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    return YES;
}

-(void)dismissKeyboardDiscardingValue:(UITextField *)textF
{
    
//    if(textF == self.txtEnds || textF == self.txtStart)
//        [textF setText:@""];
    
    [textF resignFirstResponder];
    
    
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
