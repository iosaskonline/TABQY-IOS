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
#import "MVYSideMenuController.h"
#import "QuestionObject.h"
@interface FeedBackVC ()<UITextFieldDelegate>{
    NSString *tableId;
    NSString *orderNum;
}
@property(weak,nonatomic)IBOutlet UIView *viewTop;
@property(strong,nonatomic)IBOutlet UIView *viewSuccess;

@property(weak,nonatomic)IBOutlet UIImageView *restorentBGImage;
@property(weak,nonatomic)IBOutlet UIImageView *restorentBGImage2;
@property(weak,nonatomic)IBOutlet UIImageView *restorentBGImage3;
@property(weak,nonatomic)IBOutlet UIImageView *imgTable;
@property(weak,nonatomic)IBOutlet UILabel *lblSelectTable;
@property(weak,nonatomic)IBOutlet UILabel *lblSelectorder;


@property(strong,nonatomic)NSMutableArray *arrayQues;
@property(strong,nonatomic)NSMutableArray *arraySelected;
@property(strong,nonatomic)NSMutableArray *arraySelectedNo;
@property(weak,nonatomic)IBOutlet UITableView *tblFeedback;

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
    
    [self.restorentBGImage2 ecs_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         // [self.activityProfileImage stopAnimating];
     }];
    
    [self.restorentBGImage3 ecs_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         // [self.activityProfileImage stopAnimating];
     }];
    // Do any additional setup after loading the view from its nib.
    self.tblFeedback.tableFooterView=self.viewtblFooter;
    self.arraySelected=[[NSMutableArray alloc]init];
    self.arraySelectedNo=[[NSMutableArray alloc]init];
    
    [self startServiceToGetFeedBackQ];
    NSString *tableName=[ECSUserDefault getStringFromUserDefaultForKey:@"tablename"];
    NSString *tableid=[ECSUserDefault getStringFromUserDefaultForKey:@"tableId"];
    NSString *orderNumb=[ECSUserDefault getStringFromUserDefaultForKey:@"orderNum"];
    if (self.orderObj.tableId.length) {
        self.txtTableName.text=self.orderObj.tableName;
        self.txtOrderNum.text=self.orderObj.orderNum;
        tableId=self.orderObj.tableId;
        
        NSLog(@"table %@",self.txtTableName.text);
         NSLog(@"self.txtOrderNum %@",self.txtOrderNum);
    }else if(orderNumb.length){
          self.txtOrderNum.text=orderNumb;
        self.txtTableName.text=tableName;
        tableId=tableid;
    }else
    {
    [self startServiceToGetAllTable];
    }
    [self.tblFeedback setContentInset:UIEdgeInsetsMake(1, 0, 350, 0)];
[_txtName setDelegate:self];
    [_txtEmail setDelegate:self];
  [_txtPhone setDelegate:self];
   // self.txtAnswer.delegate=self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNavigateToRootVC:)
                                                 name:@"NavigateToRootVC"
                                               object:nil];
}
- (void) receiveNavigateToRootVC:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    if ([[notification name] isEqualToString:@"NavigateToRootVC"])
        NSLog (@"Successfully received the test notification!");
    [ECSUserDefault saveString:@"" ToUserDefaultForKey:@"tablename"];
    [ECSUserDefault saveString:@"" ToUserDefaultForKey:@"tableId"];
    [ECSUserDefault saveString:@"" ToUserDefaultForKey:@"orderNum"];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    NSString *selectedIp=[ECSUserDefault getStringFromUserDefaultForKey:@"ResetIP"];
    if (selectedIp.length) {
        [class setServiceURL:[NSString stringWithFormat:@"http://%@%@feedback_question",selectedIp,SERVERURLPATH]];
    }else{
        [class setServiceURL:[NSString stringWithFormat:@"http://%@%@feedback_question",@"tabqy.com",SERVERURLPATH]];
    }
   // [class setServiceURL:[NSString stringWithFormat:@"%@feedback_question",SERVERURLPATH]];
    
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
    
    else [ECSAlert showAlert:@"Server Issue."];
    
}
- (void)openSideMenuButtonClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NavigateToRootVC" object:nil];
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
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
    
    NSString *selectedIp=[ECSUserDefault getStringFromUserDefaultForKey:@"ResetIP"];
    if (selectedIp.length) {
        [class setServiceURL:[NSString stringWithFormat:@"http://%@%@feedback_answer",selectedIp,SERVERURLPATH]];
    }else{
        [class setServiceURL:[NSString stringWithFormat:@"http://%@%@feedback_answer",@"tabqy.com",SERVERURLPATH]];
    }
    //[class setServiceURL:[NSString stringWithFormat:@"%@feedback_answer",SERVERURLPATH]];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                 self.appUserObject.resturantId, @"resturant_id",
                                 self.appUserObject.user_id,@"user_id",
                                 self.txtOrderNum.text,@"order_no",
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
        if ([[rootDictionary objectForKey:@"msg"] isEqualToString:@"Feedback Successfully"]) {
              [self resignFirstResponder];
            [self.view endEditing:YES];
            self.viewSuccess.hidden=NO;
            self.viewSuccess.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:self.viewSuccess];
        }else{
        [ECSAlert showAlert:[rootDictionary valueForKey:@"msg"]];
        }
    }
    
    else [ECSAlert showAlert:@"Server Issue."];
    
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
    
    NSString *selectedIp=[ECSUserDefault getStringFromUserDefaultForKey:@"ResetIP"];
    if (selectedIp.length) {
        [class setServiceURL:[NSString stringWithFormat:@"http://%@%@order_in_progess_list_by_table",selectedIp,SERVERURLPATH]];
    }else{
        [class setServiceURL:[NSString stringWithFormat:@"http://%@%@order_in_progess_list_by_table",@"tabqy.com",SERVERURLPATH]];
    }
   // [class setServiceURL:[NSString stringWithFormat:@"%@order_in_progess_list_by_table",SERVERURLPATH]];
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
    
    else [ECSAlert showAlert:@"Server Issue."];
    
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
         return 133;
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
      //  UITextField *txtAnswer;

    [cell.btnRadioYes addTarget:self action:@selector(clickToYes:)forControlEvents:UIControlEventTouchUpInside];
    [cell.btnRadioNo addTarget:self action:@selector(clickToNo:)forControlEvents:UIControlEventTouchUpInside];

    NSDictionary *dict=object.question;
    cell.lblQues.text=[dict valueForKey:@"name"];
    if ([object.question_type isEqualToString:@"2"]) {
        cell.viewRadiotype2.hidden=NO;
        cell.viewtextEntryType.hidden=YES;
      
        cell.txtAnswer.hidden=YES;
    }else if ([object.question_type isEqualToString:@"3"]){
         cell.txtAnswer.hidden=NO;
        cell.viewRadiotype2.hidden=YES;
        cell.viewtextEntryType.hidden=YES;
//               txtAnswer=[[UITextField alloc]initWithFrame:CGRectMake(cell.viewtextEntryType.frame.origin.x+10, cell.viewtextEntryType.frame.origin.y, cell.viewtextEntryType.frame.size.width, cell.viewtextEntryType.frame.size.height)];
        cell.txtAnswer.delegate=self;
        //cell.txtAnswer.backgroundColor=[UIColor grayColor];
        object.answer=cell.txtAnswer.text;
        [cell.contentView addSubview:cell.txtAnswer];
    }else{
         cell.txtAnswer.hidden=YES;
        cell.viewRadiotype2.hidden=YES;
        
         cell.viewtextEntryType.hidden=NO;
        NSArray *items = [[dict valueForKey:@"choices"] componentsSeparatedByString:@","];
        
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, self.tblFeedback.frame.size.width-30, 40)];
       
        scroll.showsHorizontalScrollIndicator = YES;
        UISegmentedControl *segmentedControl;
//                 if (items.count>15) {
//            
//             scroll.contentSize = CGSizeMake(cell.viewtextEntryType.frame.size.width+2500, 40);
//             segmentedControl.frame = CGRectMake(20, 0, cell.viewtextEntryType.frame.size.width+2030, 35);
//            [segmentedControl setContentPositionAdjustment:UIOffsetMake(0, 0) forSegmentType:UISegmentedControlSegmentAny barMetrics:UIBarMetricsDefault];
//        }else if (items.count>10){
//            
//             scroll.contentSize = CGSizeMake(cell.viewtextEntryType.frame.size.width+2000, 40);
//             segmentedControl.frame = CGRectMake(20, 0, cell.viewtextEntryType.frame.size.width+1030, 35);
//            [segmentedControl setContentPositionAdjustment:UIOffsetMake(0, 0) forSegmentType:UISegmentedControlSegmentAny barMetrics:UIBarMetricsDefault];
//        }else if (items.count>5){
//            
//             scroll.contentSize = CGSizeMake(cell.viewtextEntryType.frame.size.width+1000, 40);
//             segmentedControl.frame = CGRectMake(0, 0, cell.viewtextEntryType.frame.size.width+530, 35);
//            [segmentedControl setContentPositionAdjustment:UIOffsetMake(0, 0) forSegmentType:UISegmentedControlSegmentAny barMetrics:UIBarMetricsDefault];
//        }else if (items.count<5){
//            
//            scroll.contentSize = CGSizeMake(cell.viewtextEntryType.frame.size.width+10, 40);
//             segmentedControl.frame = CGRectMake(0, 0, cell.viewtextEntryType.frame.size.width+830, 35);
//        }
        segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
        for (int i=0; i<items.count; i++) {
            scroll.contentSize = CGSizeMake(200 +i*200, 40);
        segmentedControl.frame = CGRectMake(0, 0, 200 +i*200, 32);
        }
       
        

        
        
        segmentedControl.backgroundColor=[UIColor whiteColor];
         scroll.backgroundColor=[UIColor whiteColor];
        segmentedControl.selectedSegmentIndex = 0;
        segmentedControl.tintColor=[UIColor clearColor];
     [segmentedControl addTarget:self action:@selector(changeFilter:) forControlEvents:UIControlEventValueChanged];
        NSDictionary *attributes2 = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [UIFont fontWithName:@"Helvetica" size:14], NSFontAttributeName,
                                     [UIColor blackColor], NSForegroundColorAttributeName, nil];
        
        NSString *title = [segmentedControl titleForSegmentAtIndex:segmentedControl.selectedSegmentIndex];
        object.answer=title;
       
        [segmentedControl setTitleTextAttributes:attributes2 forState:UIControlStateNormal];
        [segmentedControl setDividerImage:[UIImage imageNamed:@"radio_icon02.png"] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
      
        
        [segmentedControl setDividerImage:[UIImage imageNamed:@"radio_icon2.png"] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        
        
        

        [segmentedControl setContentMode:UIViewContentModeLeft];

       
        [scroll addSubview:segmentedControl];

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
-(BOOL)validateEmail:(NSString *)emailStr
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}
-(IBAction)SubmitFeedBack:(id)sender{
    if (self.txtName.text.length==0) {
         [ECSAlert showAlert:@"Please enter Name."];
    }else if (self.txtPhone.text.length==0){
         [ECSAlert showAlert:@"Please enter valid Phone no."];
    }
    

   
    else{
    self.arrayFeedBackResponse=[[NSMutableArray alloc]init];

     for (int i=0; i<self.arrayQues.count; i++) {
                 QuestionObject  *object=[self.arrayQues objectAtIndex:i];
                 NSMutableDictionary  *dictonary=[[NSMutableDictionary alloc]init];
         
                         [dictonary setValue:object.question_id forKey:@"question_id"];
                         [dictonary setValue:object.question_type forKey:@"question_type"];
                         [dictonary setValue:object.answer forKey:@"answer"];
                 [self.arrayFeedBackResponse addObject:dictonary];
                
     }
    [self resignFirstResponder];
    NSLog(@"self.arrayFeedBackResponse %@",self.arrayFeedBackResponse);
   
    [self startServiceToSubmitFeedBack];
    }
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
    NSString *selectedIp=[ECSUserDefault getStringFromUserDefaultForKey:@"ResetIP"];
    if (selectedIp.length) {
        [class setServiceURL:[NSString stringWithFormat:@"http://%@%@waiter_progress_table",selectedIp,SERVERURLPATH]];
    }else{
        [class setServiceURL:[NSString stringWithFormat:@"http://%@%@waiter_progress_table",@"tabqy.com",SERVERURLPATH]];
    }
   // [class setServiceURL:[NSString stringWithFormat:@"%@waiter_progress_table",SERVERURLPATH]];
    
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
        if ([[rootDictionary objectForKey:@"waitertable"] isKindOfClass:[NSNull class]]) {
            
        }else{
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
       
        
       
    }
    
    else [ECSAlert showAlert:@"Server Issue."];
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)onChooseTable:(id)sender{
    if (self.orderObj.tableId.length) {
        return;
    }else{
        if (_arrayTable.count) {
            self.imgTable.hidden=NO;
            self.lblSelectTable.hidden=NO;
            self.lblSelectorder.hidden=YES;
            self.viewAllTable.hidden=NO;
            self.tblAllTable.hidden=NO;
            self.tblAllOrder.hidden=YES;
            [self.view addSubview:self.viewAllTable];
        }else{
            [ECSToast showToast:@"No table found!" view:self.view];
        }
    }
}
-(IBAction)onChooseOrder:(id)sender{
    if (self.orderObj.tableId.length) {
        return;
    }
    else if (self.arrayOrderList.count) {
        self.viewAllTable.hidden=NO;
        self.tblAllTable.hidden=YES;
        self.tblAllOrder.hidden=NO;
        self.imgTable.hidden=YES;
        self.lblSelectTable.hidden=YES;
        self.lblSelectorder.hidden=NO;
        [self.view addSubview:self.viewAllTable];
    }else{
        [ECSToast showToast:@"Please select table first." view:self.view];
    }
    
    
   
}




- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
 //   [self updateTextLabelsWithText: newString];
    if (_arrayQues.count) {
        QuestionObject  *object=[self.arrayQues objectAtIndex:3];
         NSLog(@"Changed Str: %@",object.answer);
    }
    
//    if (self.txtAnswer.editing) {
//        object.answer=newString;
//    }
//
  //  [self.tblFeedback setContentInset:UIEdgeInsetsMake(0, 0, 300, 0)];
  
   
    
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
    [self resignFirstResponder];
    //[self.tblFeedback setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];

}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    //[self.tblFeedback setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
//    if (textField==self.txtName) {
//        // [self.tblFeedback setContentOffset:CGPointMake(0,200) animated:YES];
//        [self.txtPhone becomeFirstResponder];
//    }else if (textField==self.txtPhone){
//        [self.txtEmail becomeFirstResponder];
//    }else{
//        [self.txtEmail resignFirstResponder];
//    }
//    
//    return YES;
//}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    // add your method here
    if (textField==self.txtName) {
       // [self.tblFeedback setContentOffset:CGPointMake(0,200) animated:YES];
        [self.txtName becomeFirstResponder];
    }else if (textField==self.txtPhone){
        [self.txtEmail becomeFirstResponder];
    }else if (textField==self.txtEmail){
        [self becomeFirstResponder];
    }
    return YES;
    {
        
    }
}
    -(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

        if (textField==self.txtName) {
            //[self.txtName becomeFirstResponder];
        }else if (textField==self.txtPhone){
           // [self.txtEmail becomeFirstResponder];
        }else if (textField==self.txtEmail){
           // [self becomeFirstResponder];
        }
        //[self.tblFeedback setContentOffset:CGPointMake(0,350) animated:YES];

        return YES;
    }
-(IBAction)onclickThanks:(id)sender{
                [ECSUserDefault saveString:@"" ToUserDefaultForKey:@"orderNum"];
                [ECSUserDefault saveString:@"" ToUserDefaultForKey:@"tablename"];
                [ECSUserDefault saveString:@"" ToUserDefaultForKey:@"tableId"];
    self.viewSuccess.hidden=YES;
     [[NSNotificationCenter defaultCenter] postNotificationName:@"NavigateToRootVC" object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
