//
//  CompleteOrderVC.m
//  TABQY MENU
//
//  Created by ASK ONLINE  on 21/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import "CompleteOrderVC.h"
#import "AppUserObject.h"
#import "ECSServiceClass.h"
#import "UIExtensions.h"
#import "PlaceOrderTableCell.h"
#import "FoodObject.h"
#import "ECSHelper.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "MBProgressHUD.h"
#import "HomeDeliveryVC.h"
#import "AssociatedFoodObject.h"
#import "OrderTableCell.h"
#import "TableListObject.h"
#import "MenuItemVC.h"
#import "AssociatedFoods.h"
#import "SearchFoodVC.h"
#import "MVYSideMenuController.h"
#import "PrintInvoiceVC.h"
@interface CompleteOrderVC (){
    CGFloat Price;
    CGFloat anotheItemPrice;
    CGFloat vatPrice;
     CGFloat totalpriceWithoutVat;
    CGFloat assoPreviousItemPrice;
    CGFloat assoItemPrice;
    CGFloat totalPricewithtaxandassociateItemPrice;
    
    NSString *totalPrice;
    NSString *vatPricetotal;
    NSString *taxPrice;
    NSString *tbleId;
    NSString *orderNumber;
    
    BOOL selectedTab;
     CGFloat allPreviousPriceWithTaxes;
    CGFloat assoPrice;
    CGFloat preAssoPrice;
    NSString *subtotal;
     CGFloat grandValue;
    
    CGFloat coupon;
    CGFloat initialvalue;
}
@property(weak,nonatomic)IBOutlet UIView *viewTop;

@property(weak,nonatomic)IBOutlet UIImageView *restorentBGImage;
@property(weak,nonatomic)IBOutlet UITableView *tblOrder;
@property(weak,nonatomic)IBOutlet UITableView *tblAllTable;
@property(strong,nonatomic)IBOutlet UIView *viewAllTable;


@property(weak,nonatomic)IBOutlet UILabel *lblPreviousTotalPrice;
@property(weak,nonatomic)IBOutlet UILabel *lblOngoingTotalPrice;
@property(weak,nonatomic)IBOutlet UILabel *lblVatTotalPrice;
@property(weak,nonatomic)IBOutlet UILabel *lblTotalPayablePrice;
@property(weak,nonatomic)IBOutlet UILabel *lblselectedTable;
@property(weak,nonatomic)IBOutlet UILabel *lblafterapplycoupon;
@property(weak,nonatomic)IBOutlet UILabel *lblgrandTotal;

@property(weak,nonatomic)IBOutlet UITextField *txtcoupon;

@property(weak,nonatomic)IBOutlet UIButton *btnPrevious;
@property(weak,nonatomic)IBOutlet UIButton *btnOnGoing;
@property(strong,nonatomic) NSMutableArray *arayold;
@property(strong,nonatomic) NSMutableArray *arrayTable;

@property(strong,nonatomic) NSMutableArray *arayjsonOrder;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scroll_addContact;
@property(strong,nonatomic)NSMutableArray *orderArray;
@property(strong,nonatomic)NSMutableArray *arrayAssociatedItem;
@end

@implementation CompleteOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    coupon=0;
   initialvalue=0;
    grandValue=0;
    allPreviousPriceWithTaxes=0;
    [self getOpdatedList];
    [self settingTopView:self.viewTop onController:self andTitle:[NSString stringWithFormat:@"%@ Place Order",self.appUserObject.resturantName] andImg:@"arrow-left.png"];
    UIImage *img=[UIImage imageWithName:@"restorentgp.jpg"];

  //  NSString *imgurl=[NSString stringWithFormat:@"%@%@",RESTORENTBGIMAGE,self.appUserObject.resturantBgImage];
    NSString *imgurl;
    NSString *selectedIp=[ECSUserDefault getStringFromUserDefaultForKey:@"ResetIP"];
    
    if (selectedIp.length) {
        imgurl=[NSString stringWithFormat:@"http://%@%@%@",selectedIp,RESTORENTBGIMAGE,self.appUserObject.resturantBgImage];
    }else{
        imgurl=[NSString stringWithFormat:@"http://%@%@%@",@"tabqy.com",RESTORENTBGIMAGE,self.appUserObject.resturantBgImage];
    }
    [self.restorentBGImage ecs_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:img options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         // [self.activityProfileImage stopAnimating];
     }];
    
     self.lblselectedTable.text=[NSString stringWithFormat:@"Order list for  %@",self.orderObj.tableName];
    tbleId=self.orderObj.tableId;
    self.arrayAssociatedItem=[[NSMutableArray alloc]init];
    
    [self.scroll_addContact setContentSize:CGSizeMake(320, 1000)];

    
    if (self.orderObj.tableId.length||self.orderObj.orderNum.length) {
        tbleId=self.orderObj.tableId;
        orderNumber= self.orderObj.orderNum;
        [ECSUserDefault saveString:self.orderObj.tableName ToUserDefaultForKey:@"tablename"];
        [ECSUserDefault saveString:self.orderObj.tableId ToUserDefaultForKey:@"tableId"];
        [ECSUserDefault saveString:self.orderObj.orderNum ToUserDefaultForKey:@"orderNum"];
        if ([self.orderObj.tableName isEqualToString:@""]) {
              self.lblselectedTable.text=[NSString stringWithFormat:@"Order For %@",@"Home develiry"];
            [ECSAlert showAlert:@"Can't add more order in home delivery.\nPlease complete this order."];
        }else{
         self.lblselectedTable.text=[NSString stringWithFormat:@"Order For %@",self.orderObj.tableName];
        }
    }else{
        NSString *tableName=[ECSUserDefault getStringFromUserDefaultForKey:@"tablename"];
        NSString *tableid=[ECSUserDefault getStringFromUserDefaultForKey:@"tableId"];
        NSString *orderNum=[ECSUserDefault getStringFromUserDefaultForKey:@"orderNum"];
        if ([tableName isEqualToString:@""]) {
            if (orderNum.length>1) {
                if (self.arayjsonOrder.count) {
                    [self removeAllSaveData];
                    [ECSAlert showAlert:@"Can't add more order in home delivery.\nPlease complete this order."];
                    
                }
           self.lblselectedTable.text=[NSString stringWithFormat:@"Order For Home develiry"];

            }else{
                self.lblselectedTable.text=[NSString stringWithFormat:@"Order For table number"];
            }
        }
        else{
            self.lblselectedTable.text=[NSString stringWithFormat:@"Order For %@",tableName];
        }
        tbleId=tableid;
    }
    
    
    
    selectedTab=YES;
   
  
    
    if (self.selectedOrder.length) {
       orderNumber=self.selectedOrder;
    }
    [self startServiceToGetPreviousOrder];
            [self.btnPrevious setButtonBackgroundColor: [JKSColor colorwithHexString:self.appUserObject.sidebarActiveColor alpha:1.0]];
            [self.btnOnGoing setButtonBackgroundColor: [JKSColor colorwithHexString:self.appUserObject.sidebarColor alpha:1.0]];
//    if (self.selectedOrder.length) {
//        // [self startServiceToGetPreviousOrder];
//        [self.btnOnGoing setButtonBackgroundColor: [JKSColor colorwithHexString:self.appUserObject.sidebarActiveColor alpha:1.0]];
//        [self.btnPrevious setButtonBackgroundColor: [JKSColor colorwithHexString:self.appUserObject.sidebarColor alpha:1.0]];
//        [self getOpdatedList];
//    }else{
//        [self.btnPrevious setButtonBackgroundColor: [JKSColor colorwithHexString:self.appUserObject.sidebarActiveColor alpha:1.0]];
//        [self.btnOnGoing setButtonBackgroundColor: [JKSColor colorwithHexString:self.appUserObject.sidebarColor alpha:1.0]];
//        
//    }
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

-(void)getOpdatedList{
    selectedTab=NO;
    self.orderArray =[[NSMutableArray alloc]init];
    Price=0;
    anotheItemPrice=0;
    vatPrice=0;
    preAssoPrice=0;
    assoPrice=0;
    self.arayjsonOrder=[[NSMutableArray alloc]init];
    NSMutableArray *oldFoodid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"oldFoodId"] mutableCopy];
    NSArray *ooldFoodid = [[NSSet setWithArray:oldFoodid] allObjects];
    
    for (int i=0; i<ooldFoodid.count; i++) {
        
        NSString *key=[NSString stringWithFormat:@"placeOrder%@",[ooldFoodid objectAtIndex:i]];
        NSData *data=[ECSUserDefault getObjectFromUserDefaultForKey:key];
        FoodObject *obj=[NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (obj.foodId) {
            [self.orderArray addObject:obj];
            self.arrayAssociatedItem=[[NSMutableArray alloc]init];
            for (NSDictionary * dictionary in obj.associatedFood)
            {
                
                AssociatedFoodObject  *associatedFoodObject=[AssociatedFoodObject instanceFromDictionary:dictionary];
                NSString *strForKey=[NSString stringWithFormat:@"placeOrderWithAssociatedFood%ld%ld",(long)[obj.foodId integerValue],(long)[associatedFoodObject.associatedFoodId integerValue]];
                NSString *associatedItem=[ECSUserDefault getObjectFromUserDefaultForKey:strForKey];
                
                if ([associatedItem isEqualToString:@"selected"]) {
                    NSMutableDictionary *dictAssociate=[[NSMutableDictionary alloc]init];
                    [dictAssociate setValue:associatedFoodObject.associatedFoodId forKey:@"asscioted_food_id"];
                    [dictAssociate setValue:associatedFoodObject.associatedFoodName forKey:@"asscioted_food_name"];
                    [dictAssociate setValue:associatedFoodObject.associatedFoodCode forKey:@"asscioted_food_code"];
                    [dictAssociate setValue:associatedFoodObject.associatedFoodPrice forKey:@"asscioted_price"];
                    [dictAssociate setValue:@"1" forKey:@"asscioted_qty"];
                    preAssoPrice=associatedFoodObject.associatedFoodPrice.floatValue;
                    assoPrice=preAssoPrice+assoPrice;
                    preAssoPrice=0;
                    [self.arrayAssociatedItem addObject:dictAssociate];
                    
                   
                }
            }
            
            NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
            [dict setValue:obj.foodId forKey:@"food_id"];
            [dict setValue:obj.foodCode forKey:@"food_code"];
            [dict setValue:obj.foodName forKey:@"name"];
            [dict setValue:obj.foodCount forKey:@"qty"];
            [dict setValue:obj.price forKey:@"price"];
            if (self.arrayAssociatedItem.count) {
                [dict setValue:self.arrayAssociatedItem forKey:@"items"];
            }else{
                [dict setValue:nil forKey:@"items"];
            }
            [self.arayjsonOrder addObject:dict];
            
            NSLog(@"self.arrayAssociatedItem= %@",self.arrayAssociatedItem);
            NSLog(@"Associated Food= %@",obj.associatedFood);
            NSLog(@"self.arayjsonOrder= %@",self.arayjsonOrder);
            anotheItemPrice=[obj.price floatValue];
            anotheItemPrice=anotheItemPrice*[obj.foodCount integerValue];
            Price=Price+anotheItemPrice+assoPrice;
            
        }
        
        
        
    }
    
    NSLog(@"arr %@",self.arayjsonOrder);
    totalpriceWithoutVat=Price;
//    NSString *taxVal=[ECSUserDefault getObjectFromUserDefaultForKey:@"tax_value"];
//    vatPrice=Price*[taxVal floatValue]/100;
//    NSString *taxname=[ECSUserDefault getObjectFromUserDefaultForKey:@"tax_name"];
//    
//    //
    totalPrice=[NSString stringWithFormat:@"%.2f",Price+vatPrice];
    taxPrice=[NSString stringWithFormat:@"%.2f",vatPrice];
    vatPricetotal=[NSString stringWithFormat:@"%.2f",vatPrice];
   // self.lblPreviousTotalPrice.text=[NSString stringWithFormat:@"Previous total price :    %@",@"INR 0.00"];
    self.lblOngoingTotalPrice.text=[NSString stringWithFormat:@"Ongoing total price :   %@ %.2f",self.appUserObject.resturantCurrency,Price];
//    self.lblVatTotalPrice.text=[NSString stringWithFormat:@"%@ %@%@ :   %@ %.2f",taxname,taxVal,@"%",self.appUserObject.resturantCurrency,vatPrice];
    self.lblTotalPayablePrice.text=[NSString stringWithFormat:@"Total payable price :   %@ %.2f",self.appUserObject.resturantCurrency,Price+vatPrice+[subtotal floatValue]];
    
    NSMutableArray *arrayAlltax = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"tax_type"] mutableCopy];
    NSMutableString* result = [[NSMutableString alloc]init];
   
    for (int i=0; i<arrayAlltax.count;i++) {
        NSDictionary *dict=[arrayAlltax objectAtIndex:i];
        NSString *taxName=[dict valueForKey:@"tax_name"];
        NSString *taxValue=[dict valueForKey:@"tax_value"];
        vatPrice=totalpriceWithoutVat*[taxValue floatValue]/100;
        
        
        Price=Price+vatPrice;
        [result appendFormat:@"%@\n", [NSString stringWithFormat:@"%@ %@%@ : %@ %.2f",taxName,taxValue,@"%",self.appUserObject.resturantCurrency,vatPrice]];
       
        
    }
    self.lblTotalPayablePrice.text=[NSString stringWithFormat:@"Total payable amount : %@ %.2f",self.appUserObject.resturantCurrency,Price+allPreviousPriceWithTaxes];
    self.lblVatTotalPrice.text=result;
    
    
    [self.tblOrder reloadData];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==self.tblOrder) {
        return self.orderArray.count;
    }else
        return self.arrayTable.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==self.tblOrder) {
        return 200;
    }else
        return 50;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==self.tblOrder) {
        
        static NSString *CellIdentifier = @"Cell";
        
        
        [self.tblOrder registerNib:[UINib nibWithNibName:@"PlaceOrderTableCell" bundle:nil]forCellReuseIdentifier:@"Cell"];
        PlaceOrderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.tblOrder setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        cell.backgroundColor = [UIColor clearColor];
        FoodObject *object=[self.orderArray objectAtIndex:indexPath.row];
        
        cell.lblFoodName.text=object.foodName;
        NSLog(@"Foodname=%@",object.foodName);
        NSString *strimage = object.foodImage;
        //NSString *imgurl=[NSString stringWithFormat:@"%@%@",FOODIMAGE,object.foodImage];
        NSString *imgurl;
        NSString *selectedIp=[ECSUserDefault getStringFromUserDefaultForKey:@"ResetIP"];
        
        if (selectedIp.length) {
            imgurl=[NSString stringWithFormat:@"http://%@%@%@",selectedIp,FOODIMAGE,object.foodImage];
        }else{
            imgurl=[NSString stringWithFormat:@"http://%@%@%@",@"tabqy.com",FOODIMAGE,object.foodImage];
        }
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
        
       // cell.lblFoodprice.text=[NSString stringWithFormat:@"%@ %@",self.appUserObject.resturantCurrency,object.price];
        cell.lbldescription.text=[NSString stringWithFormat:@"%@",object.foodDescription];
        
        
        if (selectedTab==YES) {
            [cell.btnCancel setHidden:YES];
        }else{
               [cell.btnCancel setHidden:NO];
        }
        
        [cell.btnCancel addTarget:self action:@selector(clickToRemove:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *associatedFoodNames=@"";
         NSString *associatedFoodNames2=@"";
        cell.lblassociatedItem.hidden=YES;
        cell.txtassociatedItem.hidden=YES;
            for (NSDictionary * dictionary in object.associatedFood)
            {
                
                AssociatedFoodObject  *associatedFoodObject=[AssociatedFoodObject instanceFromDictionary:dictionary];
                
                NSString *strForKey=[NSString stringWithFormat:@"placeOrderWithAssociatedFood%ld%ld",(long)[object.foodId integerValue],(long)[associatedFoodObject.associatedFoodId integerValue]];
                NSString *associatedItem=[ECSUserDefault getObjectFromUserDefaultForKey:strForKey];
                
                if ([associatedItem isEqualToString:@"selected"]) {
                    if ([associatedFoodNames isEqualToString:@""]) {
                        assoPreviousItemPrice=associatedFoodObject.associatedFoodPrice.floatValue ;
                        assoItemPrice=assoPreviousItemPrice+assoItemPrice;
                        assoPreviousItemPrice=0;
                        associatedFoodNames=[NSString stringWithFormat:@"%@",associatedFoodObject.associatedFoodName];
                        [cell.txtassociatedItem setText:associatedFoodNames];
                    }else{
                        assoPreviousItemPrice=associatedFoodObject.associatedFoodPrice.floatValue ;
                        assoItemPrice=assoPreviousItemPrice+assoItemPrice;
                        assoPreviousItemPrice=0;
                        
                        associatedFoodNames=[NSString stringWithFormat:@"%@,%@",associatedFoodNames,associatedFoodObject.associatedFoodName];
                        [cell.txtassociatedItem setText:associatedFoodNames];
                        
                    }
                    
                }else{
                    AssociatedFoods *associatedfood=[AssociatedFoods instanceFromDictionary:dictionary];
                    if (associatedfood.associatedFoodName.length) {
                        if ([associatedFoodNames2 isEqualToString:@""]) {
                            assoPreviousItemPrice=associatedfood.associatedFoodPrice.floatValue ;
                            assoItemPrice=assoPreviousItemPrice+assoItemPrice;
                            assoPreviousItemPrice=0;
                            associatedFoodNames2=[NSString stringWithFormat:@"%@",associatedfood.associatedFoodName];
                            [cell.txtassociatedItem setText:associatedFoodNames2];
                        }else{
                            assoPreviousItemPrice=associatedfood.associatedFoodPrice.floatValue ;
                            assoItemPrice=assoPreviousItemPrice+assoItemPrice;
                            assoPreviousItemPrice=0;
                            associatedFoodNames2=[NSString stringWithFormat:@"%@,%@",associatedFoodNames2,associatedfood.associatedFoodName];
                            [cell.txtassociatedItem setText:associatedFoodNames2];
                        }
                        
                    }
                    
                    
                }
                
                cell.lblassociatedItem.hidden=NO;
                cell.txtassociatedItem.hidden=NO;
                
            }
            
        CGFloat totalrice=assoItemPrice+object.price.floatValue;
  
        cell.lblFoodprice.text=[NSString stringWithFormat:@"%@ %.2f",self.appUserObject.resturantCurrency,totalrice];
        assoItemPrice=0;
        NSLog(@"new %@",object.foodCount);
        cell.btnCancel.tag=indexPath.row;
        if (object.foodqty.length) {
            cell.lblCount.text=object.foodqty;
        }else{
            if (object.foodCount.length) {
                cell.lblCount.text=object.foodCount;
            }else{
                cell.lblCount.text=@"0";
            }
        }
        
        
        return cell;
    }else{
        static NSString *CellIdentifier = @"Cell";
        
        
        [self.tblAllTable registerNib:[UINib nibWithNibName:@"OrderTableCell" bundle:nil]forCellReuseIdentifier:@"Cell"];
        OrderTableCell *cell = [self.tblAllTable dequeueReusableCellWithIdentifier:CellIdentifier ];
        
        cell.lbltableName.text=[NSString stringWithFormat:@"Table %ld",(long)indexPath.row];
        TableListObject * connectionObject = [self.arrayTable objectAtIndex:indexPath.row];
        
        
        NSLog(@"hello");
        
        cell.lbltableName.text=connectionObject.tableName;
        
        return cell;
    }
    
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==self.tblAllTable) {
        TableListObject * connectionObject = [self.arrayTable objectAtIndex:indexPath.row];
        
        tbleId=connectionObject.tableId;
        
        self.lblselectedTable.text=[NSString stringWithFormat:@"Order For table number %@",connectionObject.tableName];
        self.viewAllTable.hidden=YES;
        [self startServiceToSubmitFoodOrder];
    }
    
 
    
}
-(void)clickToRemove:(id)sender{
    UIButton *btn=(UIButton *)sender;
    
    FoodObject *object=[self.orderArray objectAtIndex:btn.tag];
    
    NSString *strForKey=[NSString stringWithFormat:@"placeOrder%ld",[object.foodId integerValue]];
    
    for (NSDictionary * dictionary in object.associatedFood)
    {
        
        AssociatedFoodObject  *associatedFoodObject=[AssociatedFoodObject instanceFromDictionary:dictionary];
        NSString *strForKey=[NSString stringWithFormat:@"placeOrderWithAssociatedFood%ld%ld",(long)[object.foodId integerValue],(long)[associatedFoodObject.associatedFoodId integerValue]];
        
        
        [ECSUserDefault RemoveObjectFromUserDefaultForKey:strForKey];
        
    }
    
    
    
    
    
    
    
    [ECSUserDefault RemoveObjectFromUserDefaultForKey:strForKey];
    [self.orderArray removeObjectAtIndex:btn.tag];
    NSMutableArray *storeArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"oldFoodId"] mutableCopy];
    [storeArray removeObject:object.foodId];
    
    NSLog(@"arayold%@",storeArray);
    [ECSUserDefault saveObject:storeArray ToUserDefaultForKey:@"oldFoodId"];
    
    [self getOpdatedList];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}








//-(void)startServiceToGetHomeDelivery
//{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    
//    [self performSelectorInBackground:@selector(serviceToGetHomeDelivery) withObject:nil];
//    
//    
//}
//
//-(void)serviceToGetHomeDelivery
//{
//    ECSServiceClass * class = [[ECSServiceClass alloc]init];
//    [class setServiceMethod:POST];
//    
//    [class setServiceURL:[NSString stringWithFormat:@"%@home_delivery",SERVERURLPATH]];
//    //{"user_id": "23","resturant_id": "4","type": "1","status": "0","total_price":"450","sales_tax":"9.4","service_tax":"8.46","payable_amount":"111.8","orders": [{"food_id": "3","name": "Hamburger","food_code": "hamburger","qty": 1,"price": 70,"items": [{"asscioted_food_id": "1","asscioted_food_name":"Curd001","asscioted_food_code": "Curd-123","asscioted_qty": 2,"asscioted_price": "40"}, {"asscioted_food_id": "3","asscioted_food_name": "Ratia","asscioted_food_code": "Ratia-123","asscioted_qty": 1,"asscioted_price": 0}]}, {"food_id ": "8","food_code": "biryani01","name": "Dum Biryani","qty": 1,"price ": "30","items": null}]}
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
//                                 self.appUserObject.resturantId, @"resturant_id",
//                                 self.appUserObject.user_id, @"user_id",
//                                 @"1", @"type",
//                                 @"0", @"status",
//                                 totalPrice, @"total_price",
//                                 @"0", @"sales_tax",
//                                 taxPrice, @"service_tax",
//                                 totalPrice, @"payable_amount",
//                                 self.arayjsonOrder, @"orders",
//                                 nil];
//    
//      [class addJson:dict];
//    [class setCallback:@selector(callBackServiceToGetHomeDelivery:)];
//    [class setController:self];
//    
//    [class runService];
//}
//
//-(void)callBackServiceToGetHomeDelivery:(ECSResponse *)response
//{
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
//    if(response.isValid)
//    {
//        HomeDeliveryVC *nav=[[HomeDeliveryVC alloc]initWithNibName:@"HomeDeliveryVC" bundle:nil];
//        nav.dict=rootDictionary;
//        nav.arrayJason=self.arayjsonOrder;
//        [self.navigationController pushViewController:nav animated:YES];
//    }
//    else [ECSAlert showAlert:@"Error!"];
//    
//}
//

-(IBAction)onclickSubmitOrdr:(id)sender{
    [self startServiceToSubmitFoodOrder];
}

-(IBAction)onClickSubmitFoodOrder:(id)sender{
    self.viewAllTable.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.viewAllTable.hidden=NO;
    [self.view addSubview:self.viewAllTable];
    
    //[self startServiceToSubmitFoodOrder];
}
-(void)startServiceToSubmitFoodOrder
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToSubmitFoodOrder) withObject:nil];
    
    
}

-(void)serviceToSubmitFoodOrder
{
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
    NSString *selectedIp=[ECSUserDefault getStringFromUserDefaultForKey:@"ResetIP"];
    if (selectedIp.length) {
        [class setServiceURL:[NSString stringWithFormat:@"http://%@%@re_food_orders",selectedIp,SERVERURLPATH]];
    }else{
        [class setServiceURL:[NSString stringWithFormat:@"http://%@%@re_food_orders",@"tabqy.com",SERVERURLPATH]];
    }

   // [class setServiceURL:[NSString stringWithFormat:@"%@re_food_orders",SERVERURLPATH]];
    NSString *pricewithTax;
//    if (grandValue>0) {
//    pricewithTax=[NSString stringWithFormat:@"%.2f",Price+allPreviousPriceWithTaxes];
//    }else{
        pricewithTax=[NSString stringWithFormat:@"%.2f",Price+allPreviousPriceWithTaxes];

    //}
    NSString *priceWithouttax=[NSString stringWithFormat:@"%.2f",totalpriceWithoutVat];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                 self.appUserObject.resturantId, @"resturant_id",
                                 self.appUserObject.user_id, @"user_id",
                                 tbleId,@"table_id",
                                 @"2", @"type",
                                 @"0", @"status",
                                 priceWithouttax, @"total_price",
                                 orderNumber,@"order_no",
                                 pricewithTax, @"payable_amount",
                                 self.arayjsonOrder, @"orders",
                                 nil];
    NSMutableArray *arrayAlltax = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"tax_type"] mutableCopy];
    for (int i=0; i<arrayAlltax.count;i++) {
        NSDictionary *dict2=[arrayAlltax objectAtIndex:i];
        NSString *taxName=[dict2 valueForKey:@"tax_name"];
        NSString *taxValue=[dict2 valueForKey:@"tax_value"];
        vatPrice=totalpriceWithoutVat*[taxValue floatValue]/100;
        [dict setObject:[NSString stringWithFormat:@"%.2f",vatPrice] forKey:taxName];
        
    }
    
    [class addJson:dict];
    [class setCallback:@selector(callBackServiceToSubmitFoodOrder:)];
    [class setController:self];
    [class runService];
    
    
    
    
    
}

-(void)callBackServiceToSubmitFoodOrder:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
        if ([[rootDictionary objectForKey:@"msg"] isEqualToString:@"Order Successfully"]) {
            [self removeAllSaveData];
            //[self  startServiceToGetPreviousOrder];
           // [self onClickPreviousOrder:nil];
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Order Submitted!"
//                                                                message:@"Print receipt for kitchen."
//                                                               delegate:self
//                                                      cancelButtonTitle:nil
//                                                      otherButtonTitles:@"Ok", nil];
//            [alertView show];
           // [ECSAlert showAlert:@"Order Submitted Successfully"];
           // [self.navigationController popToRootViewControllerAnimated:YES];
            
            PrintInvoiceVC *nav=[[PrintInvoiceVC alloc]initWithCoder:nil];
            //nav.orderObj=self.orderObj;
            nav.orderNumber=orderNumber;
            nav.selectedPrinter=@"kitchen";
            [self.navigationController pushViewController:nav animated:YES];
        }else if([[rootDictionary objectForKey:@"msg"] isEqualToString:@"Table Id is Missing"]){
             [ECSAlert showAlert:@"Please complete this order."];
        }
        else{
            [ECSAlert showAlert:@"You have not added any On Going order!"];
        }
    }
    else [ECSAlert showAlert:@"Server Issue."];
    
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 0) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"NavigateToRootVC" object:nil];
//        
//        [self.navigationController popToRootViewControllerAnimated:YES];
      //  [self onClickPreviousOrder:nil];
        PrintInvoiceVC *nav=[[PrintInvoiceVC alloc]initWithCoder:nil];
        //nav.orderObj=self.orderObj;
        nav.orderNumber=orderNumber;
        nav.selectedPrinter=@"kitchen";
        [self.navigationController pushViewController:nav animated:YES];
        
    }else{
        
        
       
    }
}


//-(void)startServiceToGetAllTable
//{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    
//    [self performSelectorInBackground:@selector(serviceToGetAllTable) withObject:nil];
//    
//    
//}
//
//-(void)serviceToGetAllTable
//{
//    ECSServiceClass * class = [[ECSServiceClass alloc]init];
//    [class setServiceMethod:POST];
//    
//    [class setServiceURL:[NSString stringWithFormat:@"%@table_assign_to_waiter",SERVERURLPATH]];
//    
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
//                                 self.appUserObject.user_id, @"user_id",
//                                 nil];
//    [class addJson:dict];
//    [class setCallback:@selector(callBackServiceToGetAllTable:)];
//    [class setController:self];
//    
//    [class runService];
//}
//
//-(void)callBackServiceToGetAllTable:(ECSResponse *)response
//{
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
//    if(response.isValid)
//    {
//        self.arrayTable=[[NSMutableArray alloc]init];
//        NSArray *arr=[rootDictionary valueForKey:@"waitertable"];
//        for (NSDictionary * dictionary in arr)
//        {
//            TableListObject  *object=[TableListObject instanceFromDictionary:dictionary];
//            
//            [self.arrayTable addObject:object];
//        }
//        
//        [self.tblAllTable reloadData];
//    }
//    
//    else [ECSAlert showAlert:@"Error!"];
//    
//}
//



-(void)startServiceToGetPreviousOrder
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToGetPreviousOrder) withObject:nil];
    
    
}

-(void)serviceToGetPreviousOrder
{
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
    NSString *selectedIp=[ECSUserDefault getStringFromUserDefaultForKey:@"ResetIP"];
    if (selectedIp.length) {
        [class setServiceURL:[NSString stringWithFormat:@"http://%@%@previous_order",selectedIp,SERVERURLPATH]];
    }else{
        [class setServiceURL:[NSString stringWithFormat:@"http://%@%@previous_order",@"tabqy.com",SERVERURLPATH]];
    }
    //[class setServiceURL:[NSString stringWithFormat:@"%@previous_order",SERVERURLPATH]];
    //{"order_no": "McDon-01-1"}
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                 orderNumber, @"order_no",
                                 nil];
    [class addJson:dict];
    [class setCallback:@selector(callBackServiceToGetPreviousOrder:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToGetPreviousOrder:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
        self.orderArray=[[NSMutableArray alloc]init];
        NSArray *arr=[rootDictionary valueForKey:@"food_details"];
        for (NSDictionary * dictionary in arr)
        {
            FoodObject  *object=[FoodObject instanceFromDictionary:dictionary];
            
            [self.orderArray addObject:object];
        }
        subtotal=[rootDictionary valueForKey:@"sub_total"];
       // subtotal=self.orderObj.orderValue;
       
        
        
        
        
        NSMutableArray *arrayAlltax = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"tax_type"] mutableCopy];
      //  NSMutableString* result = [[NSMutableString alloc]init];
       
        allPreviousPriceWithTaxes=[subtotal floatValue];
        CGFloat taxes;
        taxes=0;
        for (int i=0; i<arrayAlltax.count;i++) {
            NSDictionary *dict=[arrayAlltax objectAtIndex:i];
            NSString *taxName=[dict valueForKey:@"tax_name"];
            NSString *taxValue=[dict valueForKey:@"tax_value"];
            
            taxes=[[rootDictionary valueForKey:@"sub_total"] floatValue]*[taxValue floatValue]/100;
            allPreviousPriceWithTaxes=allPreviousPriceWithTaxes+taxes;
//            vatPrice=totalpriceWithoutVat*[taxValue floatValue]/100;
//            
//            
//            Price=Price+vatPrice;
//            [result appendFormat:@"%@\n", [NSString stringWithFormat:@"%@ %@%@ : %@ %.2f",taxName,taxValue,@"%",self.appUserObject.resturantCurrency,vatPrice]];
            
            
        }
         CGFloat total=Price+allPreviousPriceWithTaxes;
        self.lblPreviousTotalPrice.text=[NSString stringWithFormat:@"Previous total price :    %@ %.2f",self.appUserObject.resturantCurrency,allPreviousPriceWithTaxes];
        
         self.lblTotalPayablePrice.text=[NSString stringWithFormat:@"Total payable amount :    %@ %.2f",self.appUserObject.resturantCurrency,total];
        [self.tblOrder reloadData];
        
        if (self.selectedOrder.length) {
            // [self startServiceToGetPreviousOrder];
            [self.btnOnGoing setButtonBackgroundColor: [JKSColor colorwithHexString:self.appUserObject.sidebarActiveColor alpha:1.0]];
            [self.btnPrevious setButtonBackgroundColor: [JKSColor colorwithHexString:self.appUserObject.sidebarColor alpha:1.0]];
            [self getOpdatedList];
        }
    }
    
    else [ECSAlert showAlert:@"Server Issue."];
    
}

-(IBAction)onClickOnGoingOrder:(id)sender{
      [self.btnOnGoing setButtonBackgroundColor: [JKSColor colorwithHexString:self.appUserObject.sidebarActiveColor alpha:1.0]];
     [self.btnPrevious setButtonBackgroundColor: [JKSColor colorwithHexString:self.appUserObject.sidebarColor alpha:1.0]];
    selectedTab=NO;
    
    if ([self.lblselectedTable.text isEqualToString:@"Order For Home develiry"]) {
        [self removeAllSaveData];
    }
    
    [self getOpdatedList];
    
    
}
    -(IBAction)onClickPreviousOrder:(id)sender{
        self.selectedOrder=@"";
    selectedTab=YES;
    [self.btnPrevious setButtonBackgroundColor: [JKSColor colorwithHexString:self.appUserObject.sidebarActiveColor alpha:1.0]];
  
    [self.btnOnGoing setButtonBackgroundColor: [JKSColor colorwithHexString:self.appUserObject.sidebarColor alpha:1.0]];
      [self startServiceToGetPreviousOrder];
}


-(void)startServiceToCompleteHomeOrder
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToGetCompleteHomeOrder) withObject:nil];
    
    
}

-(void)serviceToGetCompleteHomeOrder
{
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
    NSString *selectedIp=[ECSUserDefault getStringFromUserDefaultForKey:@"ResetIP"];
    if (selectedIp.length) {
        [class setServiceURL:[NSString stringWithFormat:@"http://%@%@home_delivery_completed",selectedIp,SERVERURLPATH]];
    }else{
        [class setServiceURL:[NSString stringWithFormat:@"http://%@%@home_delivery_completed",@"tabqy.com",SERVERURLPATH]];
    }
   // [class setServiceURL:[NSString stringWithFormat:@"%@home_delivery_completed",SERVERURLPATH]];
    //{"status":"1","order_no": "Al Ja-11-1"}
    NSString *coupn=[NSString stringWithFormat:@"%.2f",coupon];
    NSString *initialv=[NSString stringWithFormat:@"%.2f",initialvalue];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                 orderNumber, @"order_no",
                                 @"1", @"status",
                                 self.txtcoupon.text,@"coupon_code",
                                 coupn,@"discount_amount",
                                 initialv,@"coupon_discount",
                                 nil];
//    jsonObject.addProperty("coupon_discount",discount);
//    jsonObject.addProperty("discount_amount",discountPrice);

    
    [class addJson:dict];
    [class setCallback:@selector(callBackServiceToGetCompleteHomeOrder:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToGetCompleteHomeOrder:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
        if ([rootDictionary objectForKey:@"msg"]) {
            
            [ECSUserDefault saveString:@"" ToUserDefaultForKey:@"orderNum"];
            [ECSUserDefault saveString:@"" ToUserDefaultForKey:@"tablename"];
            [ECSUserDefault saveString:@"" ToUserDefaultForKey:@"tableId"];
            // [self.navigationController popToRootViewControllerAnimated:YES];
            [ECSAlert showAlert:[rootDictionary objectForKey:@"msg"]];
            
            PrintInvoiceVC *nav=[[PrintInvoiceVC alloc]initWithCoder:nil];
            //nav.orderObj=self.orderObj;
             nav.orderNumber=orderNumber;
            [self.navigationController pushViewController:nav animated:YES];
            
            
        }
        
        
           }
    
    else [ECSAlert showAlert:@"Server Issue."];
    
    
    
}
-(void)startServiceToCompleteOrder
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToGetCompleteOrder) withObject:nil];
    
    
}

-(void)serviceToGetCompleteOrder
{
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
    NSString *selectedIp=[ECSUserDefault getStringFromUserDefaultForKey:@"ResetIP"];
    if (selectedIp.length) {
        [class setServiceURL:[NSString stringWithFormat:@"http://%@%@order_completed",selectedIp,SERVERURLPATH]];
    }else{
        [class setServiceURL:[NSString stringWithFormat:@"http://%@%@order_completed",@"tabqy.com",SERVERURLPATH]];
    }
   // [class setServiceURL:[NSString stringWithFormat:@"%@order_completed",SERVERURLPATH]];
    //{"status":"1","order_no": "Al Ja-11-1"}
    NSString *coupn=[NSString stringWithFormat:@"%.2f",coupon];
     NSString *initialv=[NSString stringWithFormat:@"%.2f",initialvalue];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                 orderNumber, @"order_no",
                                 @"1", @"status",
                                self.txtcoupon.text,@"coupon_code",
                                 coupn,@"discount_amount",
                                 initialv,@"coupon_discount",
                                 nil];
    [class addJson:dict];
    [class setCallback:@selector(callBackServiceToGetCompleteOrder:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToGetCompleteOrder:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
        if ([rootDictionary objectForKey:@"msg"]) {
            
//            [ECSUserDefault saveString:@"" ToUserDefaultForKey:@"orderNum"];
//            [ECSUserDefault saveString:@"" ToUserDefaultForKey:@"tablename"];
//            [ECSUserDefault saveString:@"" ToUserDefaultForKey:@"tableId"];
            // [self.navigationController popToRootViewControllerAnimated:YES];
            [ECSAlert showAlert:[rootDictionary objectForKey:@"msg"]];
            
            PrintInvoiceVC *nav=[[PrintInvoiceVC alloc]initWithCoder:nil];
            
            nav.orderNumber=orderNumber;
            [self.navigationController pushViewController:nav animated:YES];
//            [ECSUserDefault saveString:@"" ToUserDefaultForKey:@"tablename"];
//            [ECSUserDefault saveString:@"" ToUserDefaultForKey:@"tableId"];
//            [ECSUserDefault saveString:@"" ToUserDefaultForKey:@"orderNum"];
//             [self.navigationController popToRootViewControllerAnimated:YES];
//            [ECSAlert showAlert:[rootDictionary objectForKey:@"msg"]];
        }
    }
    
    else [ECSAlert showAlert:@"Server Issue."];
    
    
}



-(IBAction)onClickComplete:(id)sender{
    NSString *tableName=[ECSUserDefault getStringFromUserDefaultForKey:@"tablename"];
    NSString *tableid=[ECSUserDefault getStringFromUserDefaultForKey:@"tableId"];
    if (tableName.length) {
        tbleId=tableid;
        if (self.arayjsonOrder.count) {
            [ECSToast showToast:@"please submit ongoing order first." view:self.view];
        }else{
            
        [self startServiceToCompleteOrder];
            
        }
    }else{
        [self startServiceToCompleteHomeOrder];
    }
}
-(IBAction)onClickMore:(id)sender{
    NSString *tableName=[ECSUserDefault getStringFromUserDefaultForKey:@"tablename"];
    NSString *tableid=[ECSUserDefault getStringFromUserDefaultForKey:@"tableId"];
    NSString *orderNumb=[ECSUserDefault getStringFromUserDefaultForKey:@"orderNum"];
    if (tableName.length) {
        MenuItemVC *menuVC=[[MenuItemVC alloc]initWithNibName:@"MenuItemVC" bundle:nil];
        menuVC.addMoreSelectedOrder=orderNumb;
        [ECSUserDefault saveString:tableName ToUserDefaultForKey:@"tablename"];
        [ECSUserDefault saveString:tableid ToUserDefaultForKey:@"tableId"];
         [self.navigationController pushViewController:menuVC animated:YES];
    }else{
       // else if([[rootDictionary objectForKey:@"msg"] isEqualToString:@"Table Id is Missing"]){
            [ECSAlert showAlert:@"Can't add more order in home delivery.\nPlease complete this order."];
       // }
    }
    
   
   
}
-(void)removeAllSaveData{
    
   
    NSMutableArray *oldFoodid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"oldFoodId"] mutableCopy];
    NSArray *ooldFoodid = [[NSSet setWithArray:oldFoodid] allObjects];
    
    for (int i=0; i<ooldFoodid.count; i++) {
        NSString *key=[NSString stringWithFormat:@"placeOrder%@",[ooldFoodid objectAtIndex:i]];
        [ECSUserDefault RemoveObjectFromUserDefaultForKey:key];
        
          for (int j=0; j< self.orderArray.count; j++) {
         FoodObject *object=[self.orderArray objectAtIndex:j];
        for (NSDictionary * dictionary in object.associatedFood)
        {
            
            AssociatedFoodObject  *associatedFoodObject=[AssociatedFoodObject instanceFromDictionary:dictionary];
            NSString *strForKey=[NSString stringWithFormat:@"placeOrderWithAssociatedFood%ld%ld",(long)[object.foodId integerValue],(long)[associatedFoodObject.associatedFoodId integerValue]];
            
            
            [ECSUserDefault RemoveObjectFromUserDefaultForKey:strForKey];
            
        }
        
          }
    }
    [ECSUserDefault RemoveObjectFromUserDefaultForKey:@"oldFoodId"];
    
   

    [self getOpdatedList];
}
- (void)clickToOpenSearch:(id)sender{
    
    SearchFoodVC *spl=[[SearchFoodVC alloc ]initWithNibName:@"SearchFoodVC" bundle:nil];
    [self.navigationController pushViewController:spl animated:YES];
    
}

-(IBAction)onclickofApplyButton:(id)sender{
    
    
    [self startServiceToapplyCoupon];
}

-(void)startServiceToapplyCoupon
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToGetapplyCoupon) withObject:nil];
    
    
}

-(void)serviceToGetapplyCoupon
{
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
    NSString *selectedIp=[ECSUserDefault getStringFromUserDefaultForKey:@"ResetIP"];
    if (selectedIp.length) {
        [class setServiceURL:[NSString stringWithFormat:@"http://%@%@apply_coupon",selectedIp,SERVERURLPATH]];
    }else{
        [class setServiceURL:[NSString stringWithFormat:@"http://%@%@apply_coupon",@"tabqy.com",SERVERURLPATH]];
    }
   // [class setServiceURL:[NSString stringWithFormat:@"%@apply_coupon",SERVERURLPATH]];
    //{"status":"1","order_no": "Al Ja-11-1"}
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                 self.txtcoupon.text, @"coupon_code",
                                 self.appUserObject.resturantId, @"restaurant_id",
                                 nil];
    [class addJson:dict];
    [class setCallback:@selector(callBackServiceToGetapplyCoupon:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToGetapplyCoupon:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
      
        
        NSNumber * isSuccessNumber = (NSNumber *)[rootDictionary objectForKey: @"status"];
        if([isSuccessNumber boolValue] == YES)
        {
            //Price+allPreviousPriceWithTaxes
         NSString   *lvalue=[rootDictionary objectForKey:@"value"];
            initialvalue=lvalue.floatValue;
             coupon=(Price+allPreviousPriceWithTaxes)*initialvalue/100;
            self.lblafterapplycoupon.text=[NSString stringWithFormat:@"%@ %@ Discount coupon applied successfully \nDiscount price is %@ %.2f ",[rootDictionary objectForKey:@"value"],@"%",self.appUserObject.resturantCurrency,coupon];
            
           
            grandValue=Price+allPreviousPriceWithTaxes-coupon;
            self.lblgrandTotal.text=[NSString stringWithFormat:@"Grand total : %@ %.2f",self.appUserObject.resturantCurrency,grandValue];
            // this is the YES case
        } else {
            initialvalue=0;
            coupon=(Price+allPreviousPriceWithTaxes)*initialvalue/100;
            self.lblgrandTotal.text=@"";
            self.lblafterapplycoupon.text=@"";
            // we end up here in the NO case **OR** if isSuccessNumber is nil
        }
        
        
        if ([rootDictionary objectForKey:@"msg"]) {
            [ECSAlert showAlert:[rootDictionary objectForKey:@"msg"]];
        }
    }
    
    else [ECSAlert showAlert:@"Server Issue."];
    
    
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
