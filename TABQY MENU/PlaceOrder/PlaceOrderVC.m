//
//  PlaceOrderVC.m
//  TABQY MENU
//
//  Created by ASK ONLINE  on 10/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import "PlaceOrderVC.h"
#import "AppUserObject.h"
#import "ECSServiceClass.h"
#import "UIExtensions.h"
#import "PlaceOrderTableCell.h"
#import "FoodObject.h"
#import "ECSHelper.h"
#import "TPKeyboardAvoidingTableView.h"
#import "MBProgressHUD.h"
#import "HomeDeliveryVC.h"
#import "AssociatedFoodObject.h"
#import "OrderTableCell.h"
#import "TableListObject.h"
#import "MenuItemVC.h"
#import "SearchFoodVC.h"
#import "MVYSideMenuController.h"
@interface PlaceOrderVC (){
    CGFloat Price;
    CGFloat totalpriceWithoutVat;
    CGFloat anotheItemPrice;
    CGFloat vatPrice;
    
    CGFloat assoPreviousItemPrice;
    CGFloat assoItemPrice;
    CGFloat totalPricewithtaxandassociateItemPrice;
    
    NSString *totalPrice;
    NSString *vatPricetotal;
    NSString *taxPrice;
    NSString *tbleId;
}
@property(weak,nonatomic)IBOutlet UIView *viewTop;

@property(weak,nonatomic)IBOutlet UIImageView *restorentBGImage;
@property(weak,nonatomic)IBOutlet UIImageView *restorentBGImage2;

@property(weak,nonatomic)IBOutlet UITableView *tblOrder;
@property(weak,nonatomic)IBOutlet UITableView *tblAllTable;
@property(strong,nonatomic)IBOutlet UIView *viewAllTable;


@property(weak,nonatomic)IBOutlet UILabel *lblPreviousTotalPrice;
@property(weak,nonatomic)IBOutlet UILabel *lblOngoingTotalPrice;
@property(weak,nonatomic)IBOutlet UILabel *lblVatTotalPrice;
@property(weak,nonatomic)IBOutlet UILabel *lblTotalPayablePrice;
@property(weak,nonatomic)IBOutlet UILabel *lblselectedTable;

@property(strong,nonatomic) NSMutableArray *arayold;
@property(strong,nonatomic) NSMutableArray *arrayTable;

@property(strong,nonatomic) NSMutableArray *arayjsonOrder;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *scroll_addContact;
@property(strong,nonatomic)NSMutableArray *orderArray;
@property(strong,nonatomic)NSMutableArray *arrayAssociatedItem;
@end

@implementation PlaceOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingTopView:self.viewTop onController:self andTitle:[NSString stringWithFormat:@"%@ Place Order",self.appUserObject.resturantName] andImg:@"arrow-left.png"];
    NSString *imgurl=[NSString stringWithFormat:@"%@%@",RESTORENTBGIMAGE,self.appUserObject.resturantBgImage];
    [self.restorentBGImage ecs_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         // [self.activityProfileImage stopAnimating];
     }];
    [self.restorentBGImage2 ecs_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         // [self.activityProfileImage stopAnimating];
     }];
    
    NSString *tableName=[ECSUserDefault getStringFromUserDefaultForKey:@"tablename"];
     NSString *tableid=[ECSUserDefault getStringFromUserDefaultForKey:@"tableId"];
    if ([tableName isEqualToString:@""]||tableName ==nil) {
          self.lblselectedTable.text=[NSString stringWithFormat:@"Order For table number"];
    }else{
         self.lblselectedTable.text=[NSString stringWithFormat:@"Order For table number %@",tableName];
    }
    self.arrayAssociatedItem=[[NSMutableArray alloc]init];
    tbleId=tableid;
    [self getOpdatedList];
    [self startServiceToGetAllTable];
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
                    assoPreviousItemPrice=associatedFoodObject.associatedFoodPrice.floatValue ;
                    assoItemPrice=assoPreviousItemPrice+assoItemPrice;
                    assoPreviousItemPrice=0;
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
            Price=Price+assoItemPrice;
            assoItemPrice=0;
            assoItemPrice=0;
        }
        
     
        
    }
    
    NSLog(@"arr %@",self.arayjsonOrder);
    totalpriceWithoutVat=Price;
    totalPrice=[NSString stringWithFormat:@"%.2f",Price+vatPrice];
    taxPrice=[NSString stringWithFormat:@"%.2f",vatPrice];
    vatPricetotal=[NSString stringWithFormat:@"%.2f",vatPrice];
    self.lblPreviousTotalPrice.text=[NSString stringWithFormat:@"Previous total price :  %@ 0.00",self.appUserObject.resturantCurrency];
    self.lblOngoingTotalPrice.text=[NSString stringWithFormat:@"Ongoing total price :  %@ %.2f",self.appUserObject.resturantCurrency,Price];
   // self.lblVatTotalPrice.text=[NSString stringWithFormat:@"%@ %@%@ :  %@ %.2f",taxname,taxVal,@"%",self.appUserObject.resturantCurrency,vatPrice];
   
    
    NSMutableArray *arrayAlltax = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"tax_type"] mutableCopy];
    NSMutableString* result = [[NSMutableString alloc]init];

    for (int i=0; i<arrayAlltax.count;i++) {
        NSDictionary *dict=[arrayAlltax objectAtIndex:i];
        NSString *taxName=[dict valueForKey:@"tax_name"];
        NSString *taxValue=[dict valueForKey:@"tax_value"];
          vatPrice=totalpriceWithoutVat*[taxValue floatValue]/100;
        Price=Price+vatPrice;
        [result appendFormat:@"%@\n", [NSString stringWithFormat:@"%@ %@%@ : %@ %.2f",taxName,taxValue,@"%",self.appUserObject.resturantCurrency,vatPrice]];
       // [self.lblVatTotalPrice setStringValue:result];
        
    }
     self.lblTotalPayablePrice.text=[NSString stringWithFormat:@"Total payable amount : %@ %.2f",self.appUserObject.resturantCurrency,Price];
    self.lblVatTotalPrice.text=result;
    
    if (self.arayjsonOrder.count) {
        self.tblOrder.hidden=NO;
    }else{
         self.tblOrder.hidden=YES;
    }
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
    
        assoItemPrice=0;
        assoPreviousItemPrice=0;
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
    
    cell.lblFoodprice.text=[NSString stringWithFormat:@"%@ %@",self.appUserObject.resturantCurrency,object.price];
    cell.lbldescription.text=[NSString stringWithFormat:@"%@",object.foodDescription];
    
    
    [cell.btnCancel addTarget:self action:@selector(clickToRemove:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    NSString *associatedFoodNames=@"";
   
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
            cell.lblassociatedItem.hidden=NO;
            cell.txtassociatedItem.hidden=NO;
        
            [cell.txtassociatedItem setText:associatedFoodNames];
        }
    }
    
    
    
    CGFloat price2=[object.price floatValue]*[object.foodCount floatValue]+assoItemPrice;
   // totalPricewithtaxandassociateItemPrice=price2+totalPricewithtaxandassociateItemPrice;
        CGFloat foodItemPrice;
        foodItemPrice=0;
        foodItemPrice=price2;
        NSMutableArray *arrayAlltax = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"tax_type"] mutableCopy];
      
        for (int i=0; i<arrayAlltax.count;i++) {
            NSDictionary *dict=[arrayAlltax objectAtIndex:i];
           
            NSString *taxValue=[dict valueForKey:@"tax_value"];
           CGFloat vatPr=price2*[taxValue floatValue]/100;
            
            
            foodItemPrice=foodItemPrice+vatPr;

            
        }
    
    cell.lblFoodprice.text=[NSString stringWithFormat:@"%@ %.2f",self.appUserObject.resturantCurrency,price2];
    assoItemPrice=0;
    if (associatedFoodNames.length) {
        cell.lblassociatedItem.hidden=NO;
        cell.txtassociatedItem.hidden=NO;
    }else{
        cell.lblassociatedItem.hidden=YES;
        cell.txtassociatedItem.hidden=YES;
    }
    
    cell.btnCancel.tag=indexPath.row;
    if (object.foodCount.length) {
        cell.lblCount.text=object.foodCount;
    }else{
        cell.lblCount.text=@"0";
    }

    return cell;
    }else{
        static NSString *CellIdentifier = @"Cell";
        
        
       [self.tblAllTable registerNib:[UINib nibWithNibName:@"OrderTableCell" bundle:nil]forCellReuseIdentifier:@"Cell"];
        OrderTableCell *cell = [self.tblAllTable dequeueReusableCellWithIdentifier:CellIdentifier ];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.tblAllTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
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
        if ([connectionObject.Booked isEqualToString:@"booked"]) {
           // cell.img_view.image = [UIImage imageNamed:@"selected2.png"];
            [ECSToast showToast:@"already booked.Please choose another table" view:self.view];
        }else{
            //cell.img_view.image = [UIImage imageNamed:@"table_icon12.png"];
            tbleId=connectionObject.tableId;
            
            self.lblselectedTable.text=[NSString stringWithFormat:@"Order For table number %@",connectionObject.tableName];
            [ECSUserDefault saveString:connectionObject.tableName ToUserDefaultForKey:@"tablename"];
            [ECSUserDefault saveString:connectionObject.tableId ToUserDefaultForKey:@"tableId"];
              self.viewAllTable.hidden=YES;
            
            if (self.arayjsonOrder.count) {
                [self startServiceToSubmitFoodOrder];
            }else{
                // [self startServiceToSubmitFoodOrder];
                // [ECSAlert showAlert:@"Please add item to order."];
                [ECSToast showToast:@"Please add item to order." view:self.view];
            }

        }
        
        
                 //[self startServiceToSubmitFoodOrder];
       
    }
   
   
   
    
}
-(void)clickToRemove:(id)sender{
    UIButton *btn=(UIButton *)sender;

    FoodObject *object=[self.orderArray objectAtIndex:btn.tag];
  //placeOrder180
    NSString *strForKey=[NSString stringWithFormat:@"placeOrder%ld",[object.foodId integerValue]];
    
    for (NSDictionary * dictionary in object.associatedFood)
    {
        
        AssociatedFoodObject  *associatedFoodObject=[AssociatedFoodObject instanceFromDictionary:dictionary];
        NSString *strForKeyAsso=[NSString stringWithFormat:@"placeOrderWithAssociatedFood%ld%ld",(long)[object.foodId integerValue],(long)[associatedFoodObject.associatedFoodId integerValue]];
       
        
        [ECSUserDefault RemoveObjectFromUserDefaultForKey:strForKeyAsso];
        
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








-(void)startServiceToGetHomeDelivery
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToGetHomeDelivery) withObject:nil];
    
    
}

-(void)serviceToGetHomeDelivery
{
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
    
    [class setServiceURL:[NSString stringWithFormat:@"%@home_delivery",SERVERURLPATH]];
    //{"user_id": "23","resturant_id": "4","type": "1","status": "0","total_price":"450","sales_tax":"9.4","service_tax":"8.46","payable_amount":"111.8","orders": [{"food_id": "3","name": "Hamburger","food_code": "hamburger","qty": 1,"price": 70,"items": [{"asscioted_food_id": "1","asscioted_food_name":"Curd001","asscioted_food_code": "Curd-123","asscioted_qty": 2,"asscioted_price": "40"}, {"asscioted_food_id": "3","asscioted_food_name": "Ratia","asscioted_food_code": "Ratia-123","asscioted_qty": 1,"asscioted_price": 0}]}, {"food_id ": "8","food_code": "biryani01","name": "Dum Biryani","qty": 1,"price ": "30","items": null}]}
    NSString *pricewithTax=[NSString stringWithFormat:@"%.2f",Price];

    NSString *priceWithouttax=[NSString stringWithFormat:@"%.2f",totalpriceWithoutVat];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                          self.appUserObject.resturantId, @"resturant_id",
                           self.appUserObject.user_id, @"user_id",
                           @"1", @"type",
                           @"0", @"status",
                          priceWithouttax, @"total_price",
                          //@"0", @"sales_tax",
                          //taxPrice, @"service_tax",
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

     //[dict addEntriesFromDictionary:dict2];
    
    [class addJson:dict];
    [class setCallback:@selector(callBackServiceToGetHomeDelivery:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToGetHomeDelivery:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
        HomeDeliveryVC *nav=[[HomeDeliveryVC alloc]initWithNibName:@"HomeDeliveryVC" bundle:nil];
        nav.dict=rootDictionary;
        nav.arrayJason=self.arayjsonOrder;
        [self.navigationController pushViewController:nav animated:YES];
        
    }
    else [ECSAlert showAlert:@"Error!"];
    
}


-(IBAction)onclickSubmitOrdr:(id)sender{
    if (self.arayjsonOrder.count) {
        [self startServiceToGetHomeDelivery];
    }else{
        // [ECSAlert showAlert:@"Please add item to order."];
        [ECSToast showToast:@"Please add item to order." view:self.view];
    }
    
}

-(IBAction)onClickSubmitFoodOrder:(id)sender{
    
    if ([tbleId isEqualToString:@""]||tbleId==nil) {
        
        if (self.arrayTable.count) {
            self.viewAllTable.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            self.viewAllTable.hidden=NO;
            [self.view addSubview:self.viewAllTable];
        }else{
            [ECSToast showToast:@"Table not available." view:self.view];
        }
        
           // [self startServiceToSubmitFoodOrder];
        
        
        
    }else{
        
        if (self.arayjsonOrder.count) {
             [self startServiceToSubmitFoodOrder];
        }else{
   // [self startServiceToSubmitFoodOrder];
           // [ECSAlert showAlert:@"Please add item to order."];
            [ECSToast showToast:@"Please add item to order." view:self.view];
        }
    }
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
    
    [class setServiceURL:[NSString stringWithFormat:@"%@add_food_orders",SERVERURLPATH]];
    
   // {"user_id": "23","resturant_id": "4","table_id": "9","type": "2","status": "1","total_price":"450","sales_tax":"9.4","service_tax":"8.46","payable_amount":"111.8","orders": [{"food_id": "3","name": "Hamburger","food_code": "hamburger","qty": 1,"price": 70,"items": [{"asscioted_food_id": "1","asscioted_food_name": "Curd-001","asscioted_food_code": "Curd-123","asscioted_qty": 2,"asscioted_price": "40"}, {"asscioted_food_id": "3","asscioted_food_name": "Ratia","asscioted_food_code": "Ratia-123","asscioted_qty": 1,"asscioted_price": 0}]}, {"food_id ": "8","food_code": "biryani01","name": "Dum Biryani","qty": 1,"price ": "30","items": null}]}
    
 
    
    NSLog(@"price =%f",Price);
    //totalpriceWithoutVat
    NSString *price1=[NSString stringWithFormat:@"%.2f",Price];
     NSString *priceWithouttax=[NSString stringWithFormat:@"%.2f",totalpriceWithoutVat];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                 self.appUserObject.resturantId, @"resturant_id",
                                 self.appUserObject.user_id, @"user_id",
                                 tbleId,@"table_id",
                                 @"2", @"type",
                                 @"0", @"status",
                                 priceWithouttax, @"total_price",
                                // @"0", @"sales_tax",
                              //   price1, @"service_tax",
                                 price1, @"payable_amount",
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
//        HomeDeliveryVC *nav=[[HomeDeliveryVC alloc]initWithNibName:@"HomeDeliveryVC" bundle:nil];
//        nav.dict=rootDictionary;
//        nav.arrayJason=self.arayjsonOrder;
//        [self.navigationController pushViewController:nav animated:YES];
        
        if ([[rootDictionary objectForKey:@"msg"] isEqualToString:@"Order Successfully"]) {
            [ECSAlert showAlert:@"Order Successfully"];
            [self removeAllSaveData];
                    [self.navigationController popToRootViewControllerAnimated:YES];

        }else{
            [ECSAlert showAlert:[rootDictionary objectForKey:@"msg"]];
        }
    }
    else [ECSAlert showAlert:@"Error!"];
    
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


-(void)removeAllSaveData{
    
    [ECSUserDefault saveString:@"" ToUserDefaultForKey:@"tablename"];
    [ECSUserDefault saveString:@"" ToUserDefaultForKey:@"tableId"];
    
    NSMutableArray *oldFoodid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"oldFoodId"] mutableCopy];
    NSArray *ooldFoodid = [[NSSet setWithArray:oldFoodid] allObjects];
    
    for (int i=0; i<ooldFoodid.count; i++) {
        NSString *key=[NSString stringWithFormat:@"placeOrder%@",[ooldFoodid objectAtIndex:i]];
        [ECSUserDefault RemoveObjectFromUserDefaultForKey:key];
        
        FoodObject *object=[self.orderArray objectAtIndex:i];
        for (NSDictionary * dictionary in object.associatedFood)
        {
            
            AssociatedFoodObject  *associatedFoodObject=[AssociatedFoodObject instanceFromDictionary:dictionary];
            NSString *strForKey=[NSString stringWithFormat:@"placeOrderWithAssociatedFood%ld%ld",(long)[object.foodId integerValue],(long)[associatedFoodObject.associatedFoodId integerValue]];
            
            
            [ECSUserDefault RemoveObjectFromUserDefaultForKey:strForKey];
            
        }

    }
    [ECSUserDefault RemoveObjectFromUserDefaultForKey:@"oldFoodId"];
    [self getOpdatedList];
}

-(IBAction)onClickMore:(id)sender{
    MenuItemVC *menuVC=[[MenuItemVC alloc]initWithNibName:@"MenuItemVC" bundle:nil];
    [self.navigationController pushViewController:menuVC animated:YES];
}

- (void)clickToOpenSearch:(id)sender{
    
    SearchFoodVC *spl=[[SearchFoodVC alloc ]initWithNibName:@"SearchFoodVC" bundle:nil];
    [self.navigationController pushViewController:spl animated:YES];
    
}
-(void)openSideMenuButtonClicked:(UIButton *)sender{
    
    MVYSideMenuController *sideMenuController = [self sideMenuController];
   
    if (sideMenuController) {
        
        [sideMenuController openMenu];
    }
    
}

-(IBAction)onclickBg:(id)sender{
     self.viewAllTable.hidden=YES;
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
