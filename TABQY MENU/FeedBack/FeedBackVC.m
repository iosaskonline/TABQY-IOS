//
//  FeedBackVC.m
//  TABQY MENU
//
//  Created by ASK ONLINE  on 01/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import "FeedBackVC.h"
#import "AppUserObject.h"
#import "ECSServiceClass.h"
#import "UIExtensions.h"
#import "PlaceOrderVC.h"
#import "SearchFoodVC.h"
#import "MBProgressHUD.h"
#import "ECSHelper.h"
#import "FeedbackTableCell.h"
#import "OrderProgressObject.h"
#import "TableListObject.h"
#import "OrderTableCell.h"
#import "QuestionObject.h"
@interface FeedBackVC ()<UITextFieldDelegate>{
    NSString *tableId;
    NSString *orderNum;
}
@property(weak,nonatomic)IBOutlet UIView *viewTop;
@property(weak,nonatomic)IBOutlet UIImageView *restorentBGImage;
@property(strong,nonatomic)NSMutableArray *arrayQues;
@property(strong,nonatomic)NSMutableArray *arraySelected;
@property(strong,nonatomic)NSMutableArray *arraySelectedNo;
@property(weak,nonatomic)IBOutlet UITableView *tblFeedback;
@property (strong, nonatomic) UITextField *txtAnswer;
@property(weak,nonatomic)IBOutlet UITextField *txtName;
@property(weak,nonatomic)IBOutlet UITextField *txtEmail;
@property(weak,nonatomic)IBOutlet UITextField *txtPhone;
@property(strong,nonatomic)IBOutlet UIView *viewtblFooter;
@property(weak,nonatomic)IBOutlet UITextField *txtTableName;
@property(weak,nonatomic)IBOutlet UITextField *txtOrderNum;
@property(strong,nonatomic)NSMutableArray *arrayFeedBackResponse;
@property(strong,nonatomic)NSMutableArray *arrayOrderList;

@property(weak,nonatomic)IBOutlet UITableView *tblAllTable;
@property(weak,nonatomic)IBOutlet UITableView *tblAllOrder;
@property(strong,nonatomic)IBOutlet UIView *viewAllTable;
@property(strong,nonatomic)NSMutableArray *arrayTable;
@property(strong,nonatomic)NSMutableArray *araySelectedType2;;

@end

@implementation FeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayFeedBackResponse=[[NSMutableArray alloc]init];
    self.araySelectedType2=[[NSMutableArray alloc]init];
    [self settingTopView:self.viewTop onController:self andTitle:[NSString stringWithFormat:@"%@ Feedback",self.appUserObject.resturantName] andImg:@"arrow-left.png"];
    
    NSString *imgurl=[NSString stringWithFormat:@"%@%@",RESTORENTBGIMAGE,self.appUserObject.resturantBgImage];
    [self.restorentBGImage ecs_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         // [self.activityProfileImage stopAnimating];
     }];
    // Do any additional setup after loading the view from its nib.
    self.tblFeedback.tableFooterView=self.viewtblFooter;
    self.arraySelected=[[NSMutableArray alloc]init];
    self.arraySelectedNo=[[NSMutableArray alloc]init];
    
    [self startServiceToGetFeedBackQ];
    if (self.orderObj.tableId.length) {
        self.txtTableName.text=self.orderObj.tableName;
        self.txtOrderNum.text=self.orderObj.orderNum;
        tableId=self.orderObj.tableId;
        
        NSLog(@"table %@",self.txtTableName.text);
    }else{
    [self startServiceToGetAllTable];
    }
    self.txtAnswer.delegate=self;
}


-(void)clickToPlaceOrderList:(id)sender{
    PlaceOrderVC *nav=[[PlaceOrderVC alloc]initWithNibName:@"PlaceOrderVC" bundle:nil];
    [self.navigationController pushViewController:nav animated:YES];

}

- (void)clickToOpenSearch:(id)sender{
    
    SearchFoodVC *spl=[[SearchFoodVC alloc ]initWithNibName:@"SearchFoodVC" bundle:nil];
    [self.navigationController pushViewController:spl animated:YES];
    
}

-(void)startServiceToGetFeedBackQ
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToGetFeedBackQ) withObject:nil];
    
    
}

-(void)serviceToGetFeedBackQ
{
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
    
    [class setServiceURL:[NSString stringWithFormat:@"%@feedback_question",SERVERURLPATH]];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                 self.appUserObject.resturantId, @"resturant_id",
                                 nil];
    [class addJson:dict];
    [class setCallback:@selector(callBackServiceToGetFeedBackQ:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToGetFeedBackQ:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
        self.arrayQues=[[NSMutableArray alloc]init];
      NSArray  *arr=[rootDictionary valueForKey:@"question"];
        for (NSDictionary * dictionary in arr)
        {
            QuestionObject  *object=[QuestionObject instanceFromDictionary:dictionary];
            
            [self.arrayQues addObject:object];
        }
        
        [self.tblFeedback reloadData];
   }
    
    else [ECSAlert showAlert:@"Error!"];
    
}

-(void)startServiceToSubmitFeedBack
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToSubmitFeedBack) withObject:nil];
    
    
}

-(void)serviceToSubmitFeedBack
{
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
    /*
     //{"resturant_id": "4","user_id": "23","order_no": "Al Ja-11-1","table_id": "19","name": "jeffi","phone": "85858585858","email": "jeffi@safe.com","feedback_response": [{"resturant_id": "4","order_no": "Al Ja-11-1","question_id": "1","answer": "good","question_type": "1"}, {"resturant_id": "4","order_no": "Al Ja-11-1","question_id": "2","answer": "Yes","question_type": "2"}, {"resturant_id": "4","order_no": "Al Ja-11-1","question_id": "3","answer": "This is good restauant","question_type": "3"}]}
     */
    [class setServiceURL:[NSString stringWithFormat:@"%@feedback_answer",SERVERURLPATH]];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                 self.appUserObject.resturantId, @"resturant_id",
                                 self.appUserObject.user_id,@"user_id",
                                 orderNum,@"order_no",
                                 tableId,@"table_id",
                                self.txtName.text,@"name",
                                self.txtPhone.text,@"phone",
                                self.txtEmail.text,@"email",
                                 self.arrayFeedBackResponse,@"feedback_response",
                                 nil];
    [class addJson:dict];
    [class setCallback:@selector(callBackServiceToSubmitFeedBack:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToSubmitFeedBack:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
       
        [ECSAlert showAlert:[rootDictionary valueForKey:@"msg"]];
    }
    
    else [ECSAlert showAlert:@"Error!"];
    
}



-(void)startServiceToGetAllOrderNum
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToGetAllOrderNum) withObject:nil];
    
    
}

-(void)serviceToGetAllOrderNum
{
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
    /*
    {"user_id": "23","from_date": "2016-11-17","to_date": "2016-11-17"}
     */
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
    [class setCallback:@selector(callBackServiceToGetAllOrderNum:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToGetAllOrderNum:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
        self.arrayOrderList=[[NSMutableArray alloc]init];
        NSArray *arr=[rootDictionary valueForKey:@"order_progess"];
                for (NSDictionary * dictionary in arr)
                {
                    OrderProgressObject  *object=[OrderProgressObject instanceFromDictionary:dictionary];
        
                    [self.arrayOrderList addObject:object];
                }
          [self.tblAllOrder reloadData];
        if (self.arrayOrderList.count) {
            OrderProgressObject * connectionObject = [self.arrayOrderList objectAtIndex:0];
            orderNum=connectionObject.order_no;
            self.txtOrderNum.text=connectionObject.order_no;
        }
        
        
      
    }
    
    else [ECSAlert showAlert:@"Error!"];
    
}







- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==self.tblFeedback) {
        return self.arrayQues.count;
    }else if (tableView==self.tblAllOrder){
        return self.arrayOrderList.count;
    }else
        return self.arrayTable.count;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==self.tblFeedback) {
         return 130;
    }else
    return 40;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (tableView==self.tblFeedback) {
     
        static NSString *CellIdentifier = @"Cell";
        
        
        [self.tblFeedback registerNib:[UINib nibWithNibName:@"FeedbackTableCell" bundle:nil]forCellReuseIdentifier:@"Cell"];
        FeedbackTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.tblFeedback setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        cell.backgroundColor = [UIColor clearColor];
         QuestionObject  *object=[self.arrayQues objectAtIndex:indexPath.row];
       
    [cell.btnRadioYes addTarget:self action:@selector(clickToYes:)forControlEvents:UIControlEventTouchUpInside];
    [cell.btnRadioNo addTarget:self action:@selector(clickToNo:)forControlEvents:UIControlEventTouchUpInside];

    NSDictionary *dict=object.question;
    cell.lblQues.text=[dict valueForKey:@"name"];
    if ([object.question_type isEqualToString:@"2"]) {
        cell.viewRadiotype2.hidden=NO;
        cell.viewtextEntryType.hidden=YES;
    }else if ([object.question_type isEqualToString:@"3"]){
        cell.viewRadiotype2.hidden=YES;
        cell.viewtextEntryType.hidden=NO;
        self.txtAnswer=[[UITextField alloc]initWithFrame:CGRectMake(cell.viewtextEntryType.frame.origin.x+10, cell.viewtextEntryType.frame.origin.y, cell.viewtextEntryType.frame.size.width, cell.viewtextEntryType.frame.size.height)];
        self.txtAnswer.delegate=self;
        object.answer=self.txtAnswer.text;
        [cell.contentView addSubview:self.txtAnswer];
    }else{
         cell.viewtextEntryType.hidden=NO;
        NSArray *items = [[dict valueForKey:@"choices"] componentsSeparatedByString:@","];
        
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, cell.viewtextEntryType.frame.size.width+500, 40)];
        scroll.contentSize = CGSizeMake(cell.viewtextEntryType.frame.size.width+1000, 40);
        scroll.showsHorizontalScrollIndicator = YES;
        
  
        cell.segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
        cell.segmentedControl.frame = CGRectMake(20, 0, cell.viewtextEntryType.frame.size.width+830, 30);
     
        
        
        cell.segmentedControl.backgroundColor=[UIColor whiteColor];
         scroll.backgroundColor=[UIColor whiteColor];
        cell.segmentedControl.selectedSegmentIndex = 0;
        cell.segmentedControl.tintColor=[UIColor clearColor];
     [cell.segmentedControl addTarget:self action:@selector(changeFilter:) forControlEvents:UIControlEventValueChanged];
        NSDictionary *attributes2 = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [UIFont fontWithName:@"Helvetica" size:14], NSFontAttributeName,
                                     [UIColor blackColor], NSForegroundColorAttributeName, nil];
        
        NSString *title = [cell.segmentedControl titleForSegmentAtIndex:cell.segmentedControl.selectedSegmentIndex];
        object.answer=title;
       
        [cell.segmentedControl setTitleTextAttributes:attributes2 forState:UIControlStateNormal];
        [cell.segmentedControl setDividerImage:[UIImage imageNamed:@"radio_icon02.png"] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
      
        
        [cell.segmentedControl setDividerImage:[UIImage imageNamed:@"radio_icon2.png"] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        
        [cell.segmentedControl setContentPositionAdjustment:UIOffsetMake(-10, 0) forSegmentType:UISegmentedControlSegmentAny barMetrics:UIBarMetricsDefault];
        

        [cell.segmentedControl setContentMode:UIViewContentModeLeft];

       
        [scroll addSubview:cell.segmentedControl];

        [cell.viewtextEntryType addSubview:scroll];
        cell.viewRadiotype2.hidden=YES;
        //cell.viewtextEntryType.hidden=YES;
    }
    
   
    
    BOOL flag=   [_arraySelected containsObject:
                  [NSString stringWithFormat:@"%li",indexPath.row]];
  
    if(flag == NO )
    {
        [cell.btnRadioYes setImage:[UIImage imageNamed:@"radio_icon.png"] forState:UIControlStateNormal];
       // [cell.btnRadioNo setImage:[UIImage imageNamed:@"radio_icon01.png"] forState:UIControlStateNormal];
    }
    else {
       // [cell.btnRadioNo setImage:[UIImage imageNamed:@"radio_icon.png"] forState:UIControlStateNormal];
        [cell.btnRadioYes setImage:[UIImage imageNamed:@"radio_icon01.png"] forState:UIControlStateNormal];
       
    }
    
    
    BOOL flag2=   [self.arraySelectedNo containsObject:
                  [NSString stringWithFormat:@"%li",indexPath.row]];
    if(flag2 == NO )
    {
        [cell.btnRadioNo setImage:[UIImage imageNamed:@"radio_icon.png"] forState:UIControlStateNormal];
        //[cell.btnRadioYes setImage:[UIImage imageNamed:@"radio_icon01.png"] forState:UIControlStateNormal];
    }
    else {
         //[cell.btnRadioYes setImage:[UIImage imageNamed:@"radio_icon.png"] forState:UIControlStateNormal];
         [cell.btnRadioNo setImage:[UIImage imageNamed:@"radio_icon01.png"] forState:UIControlStateNormal];
    }
    
    cell.btnRadioYes.tag=indexPath.row;

     cell.btnRadioNo.tag=indexPath.row;
    
        return cell;
    }


    else if (tableView==self.tblAllOrder){
        static NSString *CellIdentifier = @"Cell";
        [self.tblAllOrder registerNib:[UINib nibWithNibName:@"OrderTableCell" bundle:nil]forCellReuseIdentifier:@"Cell"];
        OrderTableCell *cell = [self.tblAllOrder dequeueReusableCellWithIdentifier:CellIdentifier ];
         [self.tblAllOrder setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        cell.lbltableName.text=[NSString stringWithFormat:@"Table %ld",(long)indexPath.row];
        OrderProgressObject * connectionObject = [self.arrayOrderList objectAtIndex:indexPath.row];
        
        cell.lbltableName.text=connectionObject.order_no;
        
        return cell;

    }else{
        static NSString *CellIdentifier = @"Cell";
        [self.tblAllTable registerNib:[UINib nibWithNibName:@"OrderTableCell" bundle:nil]forCellReuseIdentifier:@"Cell"];
        OrderTableCell *cell = [self.tblAllTable dequeueReusableCellWithIdentifier:CellIdentifier ];
         [self.tblAllTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        cell.lbltableName.text=[NSString stringWithFormat:@"Table %ld",(long)indexPath.row];
        TableListObject * connectionObject = [self.arrayTable objectAtIndex:indexPath.row];
        
        cell.lbltableName.text=connectionObject.tableName;
        
        return cell;

    }


}

-(void)changeFilter:(id)sender{
    UISegmentedControl * segmentedControl = (UISegmentedControl *)sender;
  QuestionObject  *object=[self.arrayQues objectAtIndex:4];
    NSString *title = [segmentedControl titleForSegmentAtIndex:segmentedControl.selectedSegmentIndex];
    object.answer=title;
            NSLog(@"selected Index: %ld", (long)segmentedControl.selectedSegmentIndex);
    
   
}



- (IBAction)clickToYes:(id)sender {
    
    UIButton *btn=(UIButton *)sender;
    NSString *strContact=  [NSString stringWithFormat:@"%li",btn.tag];
    BOOL flag=   [self.arraySelected containsObject:strContact];
    
 QuestionObject  *object=[self.arrayQues objectAtIndex:btn.tag];
    if(flag == NO )
    {
    object.answer=@"yes";

        [self.arraySelected addObject:strContact];
         [self.arraySelectedNo removeObject:strContact];
    }
    else {
         object.answer=@"no";

         [self.arraySelectedNo addObject:strContact];
        [self.arraySelected removeObject:strContact];
        
    }
 NSLog(@"araySelectedType2%@",self.araySelectedType2);
    NSLog(@" object.answer =%@", object.answer);
    [self.tblFeedback reloadData];

}

- (IBAction)clickToNo:(id)sender {
    UIButton *btn=(UIButton *)sender;
    NSString *strContact=  [NSString stringWithFormat:@"%li",btn.tag];
    BOOL flag2=   [self.arraySelectedNo containsObject:strContact];
     QuestionObject  *object=[self.arrayQues objectAtIndex:btn.tag];
    if(flag2 == NO )
    {
         object.answer=@"no";
      
          [self.arraySelected removeObject:strContact];
        [self.arraySelectedNo addObject:strContact];
    }
    else {
         object.answer=@"yes";

         [self.arraySelected addObject:strContact];
        [self.arraySelectedNo removeObject:strContact];
    }
     NSLog(@"araySelectedType2%@",self.araySelectedType2);
      NSLog(@" object.answer =%@", object.answer);
    [self.tblFeedback reloadData];
}

-(IBAction)SubmitFeedBack:(id)sender{
    
    
    self.arrayFeedBackResponse=[[NSMutableArray alloc]init];

     for (int i=0; i<self.arrayQues.count; i++) {
                 QuestionObject  *object=[self.arrayQues objectAtIndex:i];
                 NSMutableDictionary  *dictonary=[[NSMutableDictionary alloc]init];
         
                         [dictonary setValue:object.question_id forKey:@"question_id"];
                         [dictonary setValue:object.question_type forKey:@"question_type"];
                         [dictonary setValue:object.answer forKey:@"answer"];
                 [self.arrayFeedBackResponse addObject:dictonary];
                
     }

    
   
    NSLog(@"self.arrayFeedBackResponse %@",self.arrayFeedBackResponse);
   
    [self startServiceToSubmitFeedBack];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==self.tblAllTable) {
        TableListObject * connectionObject = [self.arrayTable objectAtIndex:indexPath.row];
        tableId=connectionObject.tableId;
        self.txtTableName.text=connectionObject.tableName;
        [self startServiceToGetAllOrderNum];
    }else if (tableView==self.tblAllOrder){
        OrderProgressObject * connectionObject = [self.arrayOrderList objectAtIndex:indexPath.row];
        orderNum=connectionObject.order_no;
        self.txtOrderNum.text=connectionObject.order_no;
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
    
    [class setServiceURL:[NSString stringWithFormat:@"%@waiter_progress_table",SERVERURLPATH]];
    
    NSDate *now = [NSDate date];
    NSString *date=[ECSDate getFormattedDateString:now];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                 self.appUserObject.user_id, @"waiter_id",
                                 date,@"from_date",
                                 date,@"to_date",
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
        if (arr.count) {
            
            for (NSDictionary * dictionary in arr)
            {
                TableListObject  *object=[TableListObject instanceFromDictionary:dictionary];
                
                [self.arrayTable addObject:object];
            }
            [self.tblAllTable reloadData];
            TableListObject * connectionObject = [self.arrayTable objectAtIndex:0];
            tableId=connectionObject.tableId;
            self.txtTableName.text=connectionObject.tableName;
            [self startServiceToGetAllOrderNum];
            
        }
       
        
       
    }
    
    else [ECSAlert showAlert:@"Error!"];
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)onChooseTable:(id)sender{
    if (self.orderObj.tableId.length) {
        return;
    }
    self.viewAllTable.hidden=NO;
    self.tblAllTable.hidden=NO;
    self.tblAllOrder.hidden=YES;
    [self.view addSubview:self.viewAllTable];
}
-(IBAction)onChooseOrder:(id)sender{
    if (self.orderObj.tableId.length) {
        return;
    }
    else if (self.arrayOrderList.count) {
        self.viewAllTable.hidden=NO;
        self.tblAllTable.hidden=YES;
        self.tblAllOrder.hidden=NO;
        
        [self.view addSubview:self.viewAllTable];
    }else{
        [ECSToast showToast:@"Please select table first." view:self.view];
    }
    
    
   
}




- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
 //   [self updateTextLabelsWithText: newString];
     QuestionObject  *object=[self.arrayQues objectAtIndex:3];
    if (self.txtAnswer.editing) {
        object.answer=newString;
    }
    
    
    NSLog(@"Changed Str: %@",object.answer);
    
    return YES;
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
