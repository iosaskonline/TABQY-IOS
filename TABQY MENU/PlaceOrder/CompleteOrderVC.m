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
@interface CompleteOrderVC (){
    CGFloat Price;
    CGFloat anotheItemPrice;
    CGFloat vatPrice;
    
    CGFloat assoPreviousItemPrice;
    CGFloat assoItemPrice;
    CGFloat totalPricewithtaxandassociateItemPrice;
    
    NSString *totalPrice;
    NSString *vatPricetotal;
    NSString *taxPrice;
    NSString *tbleId;
    NSString *orderNumber;
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
    [self getOpdatedList];
    [self settingTopView:self.viewTop onController:self andTitle:[NSString stringWithFormat:@"%@ Place Order",self.appUserObject.resturantName] andImg:@"arrow-left.png"];
    NSString *imgurl=[NSString stringWithFormat:@"%@%@",RESTORENTBGIMAGE,self.appUserObject.resturantBgImage];
    [self.restorentBGImage ecs_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         // [self.activityProfileImage stopAnimating];
     }];
    
     self.lblselectedTable.text=[NSString stringWithFormat:@"Order list for  %@",self.orderObj.tableName];
    tbleId=self.orderObj.tableId;
    self.arrayAssociatedItem=[[NSMutableArray alloc]init];
    

    
    if (self.orderObj.tableId.length) {
        tbleId=self.orderObj.tableId;
        orderNumber= self.orderObj.orderNum;
         self.lblselectedTable.text=[NSString stringWithFormat:@"Order For %@",self.orderObj.tableName];
    }else{
        NSString *tableName=[ECSUserDefault getStringFromUserDefaultForKey:@"tablename"];
        NSString *tableid=[ECSUserDefault getStringFromUserDefaultForKey:@"tableId"];
        if ([tableName isEqualToString:@""]) {
            self.lblselectedTable.text=[NSString stringWithFormat:@"Order For table number"];
        }else{
            self.lblselectedTable.text=[NSString stringWithFormat:@"Order For %@",tableName];
        }
        tbleId=tableid;
    }
    
    
    
    
    [self.btnPrevious setButtonBackgroundColor: [JKSColor colorwithHexString:self.appUserObject.sidebarActiveColor alpha:1.0]];
    [self.btnOnGoing setButtonBackgroundColor: [JKSColor colorwithHexString:self.appUserObject.sidebarColor alpha:1.0]];
  
    
    if (self.selectedOrder.length) {
       orderNumber=self.selectedOrder;
    }
    
    
    [self startServiceToGetPreviousOrder];
}

-(void)getOpdatedList{
    self.orderArray =[[NSMutableArray alloc]init];
    Price=0;
    anotheItemPrice=0;
    vatPrice=0;
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
            Price=Price+anotheItemPrice;
            
        }
        
        
        
    }
    
    NSLog(@"arr %@",self.arayjsonOrder);
    NSString *taxVal=[ECSUserDefault getObjectFromUserDefaultForKey:@"tax_value"];
    vatPrice=Price*[taxVal floatValue]/100;
    NSString *taxname=[ECSUserDefault getObjectFromUserDefaultForKey:@"tax_name"];
    
    //
    totalPrice=[NSString stringWithFormat:@"%.2f",Price+vatPrice];
    taxPrice=[NSString stringWithFormat:@"%.2f",vatPrice];
    vatPricetotal=[NSString stringWithFormat:@"%.2f",vatPrice];
   // self.lblPreviousTotalPrice.text=[NSString stringWithFormat:@"Previous total price :    %@",@"INR 0.00"];
    self.lblOngoingTotalPrice.text=[NSString stringWithFormat:@"Ongoing total price :   INR %.2f",Price];
    self.lblVatTotalPrice.text=[NSString stringWithFormat:@"%@ %@%@ :       INR %.2f",taxname,taxVal,@"%",vatPrice];
    self.lblTotalPayablePrice.text=[NSString stringWithFormat:@"Total payable price :    %.2f",Price+vatPrice];
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
        
       // cell.lblFoodprice.text=[NSString stringWithFormat:@"%@ %@",self.appUserObject.resturantCurrency,object.price];
        cell.lbldescription.text=[NSString stringWithFormat:@"%@",object.foodDescription];
        
        
        [cell.btnCancel addTarget:self action:@selector(clickToRemove:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *associatedFoodNames=@"";
         NSString *associatedFoodNames2=@"";
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
                }else{
                    assoPreviousItemPrice=associatedFoodObject.associatedFoodPrice.floatValue ;
                    assoItemPrice=assoPreviousItemPrice+assoItemPrice;
                    assoPreviousItemPrice=0;
                    
                    associatedFoodNames=[NSString stringWithFormat:@"%@,%@",associatedFoodNames,associatedFoodObject.associatedFoodName];
                    
                }
                 [cell.txtassociatedItem setText:associatedFoodNames];
            }else{
            AssociatedFoods *associatedfood=[AssociatedFoods instanceFromDictionary:dictionary];
            if (associatedfood.associatedFoodName.length) {
                if ([associatedFoodNames2 isEqualToString:@""]) {
                    assoPreviousItemPrice=associatedfood.associatedFoodPrice.floatValue ;
                    assoItemPrice=assoPreviousItemPrice+assoItemPrice;
                    assoPreviousItemPrice=0;
                    associatedFoodNames2=[NSString stringWithFormat:@"%@",associatedfood.associatedFoodName];
                }else{
                    assoPreviousItemPrice=associatedfood.associatedFoodPrice.floatValue ;
                    assoItemPrice=assoPreviousItemPrice+assoItemPrice;
                    assoPreviousItemPrice=0;
                    associatedFoodNames2=[NSString stringWithFormat:@"%@,%@",associatedFoodNames2,associatedfood.associatedFoodName];
                    
                }
                 [cell.txtassociatedItem setText:associatedFoodNames2];
            }
               

}
            
            cell.lblassociatedItem.hidden=NO;
                cell.txtassociatedItem.hidden=NO;
//            if (associatedFoodNames2.length>0) {
//                [cell.txtassociatedItem setText:associatedFoodNames2];
//            }else
//            {
//                [cell.txtassociatedItem setText:associatedFoodNames];
//            }
        }
        
        CGFloat totalrice=assoItemPrice+object.price.floatValue;
  
        cell.lblFoodprice.text=[NSString stringWithFormat:@"%@ %.2f",self.appUserObject.resturantCurrency,totalrice];
        assoItemPrice=0;
        if (associatedFoodNames.length) {
            cell.lblassociatedItem.hidden=NO;
            cell.txtassociatedItem.hidden=NO;
        }else{
            cell.lblassociatedItem.hidden=YES;
            cell.txtassociatedItem.hidden=YES;
        }
        if (associatedFoodNames2.length) {
            cell.lblassociatedItem.hidden=NO;
            cell.txtassociatedItem.hidden=NO;
        }else{
            cell.lblassociatedItem.hidden=YES;
            cell.txtassociatedItem.hidden=YES;
        }
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
    }
    
    self.viewAllTable.hidden=YES;
    [self startServiceToSubmitFoodOrder];
    
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
    
    [class setServiceURL:[NSString stringWithFormat:@"%@re_food_orders",SERVERURLPATH]];
    
    // {"user_id": "23","table_id": "19","resturant_id": "4","type": "2","status": "0","order_no": "Al Ja-11-2","total_price":"450","sales_tax":"9.4","service_tax":"8.46","payable_amount":"111.8","orders": [{"food_id": "5","name": "Hakka Noodles","food_code": "noodles1","qty": "2","price": "25","items": [{"asscioted_food_id": "1","asscioted_food_name": "Curd-2","asscioted_food_code": "co-123","asscioted_qty": 2,"asscioted_price": "40" }, {"asscioted_food_id": "3","asscioted_food_name": "Ratias","asscioted_food_code": "ra-124","asscioted_qty": 1,"asscioted_price": 0}]}]}
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                 self.appUserObject.resturantId, @"resturant_id",
                                 self.appUserObject.user_id, @"user_id",
                                 tbleId,@"table_id",
                                 @"2", @"type",
                                 @"0", @"status",
                                 totalPrice, @"total_price",
                                 orderNumber,@"order_no",
                                 @"0", @"sales_tax",
                                 taxPrice, @"service_tax",
                                 totalPrice, @"payable_amount",
                                 self.arayjsonOrder, @"orders",
                                 nil];
    
    
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
        if ([rootDictionary objectForKey:@"msg"]) {
            [self removeAllSaveData];
            [ECSAlert showAlert:[rootDictionary objectForKey:@"msg"]];
        }
    }
    else [ECSAlert showAlert:@"Error!"];
    
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
    
    [class setServiceURL:[NSString stringWithFormat:@"%@previous_order",SERVERURLPATH]];
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
        NSString *subtotal=[rootDictionary valueForKey:@"sub_total"];
        CGFloat total=Price+vatPrice+[subtotal floatValue];
        self.lblPreviousTotalPrice.text=[NSString stringWithFormat:@"Previous total price :    %@ %.2f",self.appUserObject.resturantCurrency,[subtotal floatValue]];
        
         self.lblTotalPayablePrice.text=[NSString stringWithFormat:@"Total Payable price :    %@ %.2f",self.appUserObject.resturantCurrency,total];
        [self.tblOrder reloadData];
    }
    
    else [ECSAlert showAlert:@"Error!"];
    
}

-(IBAction)onClickOnGoingOrder:(id)sender{
      [self.btnOnGoing setButtonBackgroundColor: [JKSColor colorwithHexString:self.appUserObject.sidebarActiveColor alpha:1.0]];
     [self.btnPrevious setButtonBackgroundColor: [JKSColor colorwithHexString:self.appUserObject.sidebarColor alpha:1.0]];
    [self getOpdatedList];
    
}


-(IBAction)onClickPreviousOrder:(id)sender{
    
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
    
    [class setServiceURL:[NSString stringWithFormat:@"%@home_delivery_completed",SERVERURLPATH]];
    //{"status":"1","order_no": "Al Ja-11-1"}
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                 orderNumber, @"order_no",
                                 @"1", @"status",
                                 nil];
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
            [ECSAlert showAlert:[rootDictionary objectForKey:@"msg"]];
        }
        
        
           }
    
    else [ECSAlert showAlert:@"Error!"];
    
    
    
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
    
    [class setServiceURL:[NSString stringWithFormat:@"%@order_completed",SERVERURLPATH]];
    //{"status":"1","order_no": "Al Ja-11-1"}
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                 orderNumber, @"order_no",
                                 @"1", @"status",
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
            [ECSAlert showAlert:[rootDictionary objectForKey:@"msg"]];
        }
    }
    
    else [ECSAlert showAlert:@"Error!"];
    
    
}



-(IBAction)onClickComplete:(id)sender{
    if (self.orderObj.tableName.length) {
        [self startServiceToCompleteOrder];
    }else{
        [self startServiceToCompleteHomeOrder];
    }
}
-(IBAction)onClickMore:(id)sender{
    MenuItemVC *menuVC=[[MenuItemVC alloc]initWithNibName:@"MenuItemVC" bundle:nil];
    menuVC.addMoreSelectedOrder=self.orderObj.orderNum;

    [ECSUserDefault saveString:self.orderObj.tableName ToUserDefaultForKey:@"tablename"];
     [ECSUserDefault saveString:self.orderObj.tableId ToUserDefaultForKey:@"tableId"];
    [self.navigationController pushViewController:menuVC animated:YES];
}
-(void)removeAllSaveData{
    NSMutableArray *oldFoodid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"oldFoodId"] mutableCopy];
    NSArray *ooldFoodid = [[NSSet setWithArray:oldFoodid] allObjects];
    
    for (int i=0; i<ooldFoodid.count; i++) {
        NSString *key=[NSString stringWithFormat:@"placeOrder%@",[ooldFoodid objectAtIndex:i]];
        [ECSUserDefault RemoveObjectFromUserDefaultForKey:key];
    }
    [ECSUserDefault RemoveObjectFromUserDefaultForKey:@"oldFoodId"];
    [self getOpdatedList];
}
- (void)clickToOpenSearch:(id)sender{
    
    SearchFoodVC *spl=[[SearchFoodVC alloc ]initWithNibName:@"SearchFoodVC" bundle:nil];
    [self.navigationController pushViewController:spl animated:YES];
    
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
