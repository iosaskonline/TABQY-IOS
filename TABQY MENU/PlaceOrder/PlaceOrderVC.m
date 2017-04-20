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
@interface PlaceOrderVC (){
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
    
    
    self.arrayAssociatedItem=[[NSMutableArray alloc]init];
    
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
    self.lblPreviousTotalPrice.text=[NSString stringWithFormat:@"Previous total price :    %@",@"INR 0.00"];
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
        
        [cell.imgFood ecs_setImageWithURL:[NSURL URLWithString:[imgurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"User-image.png"] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
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
    
    
    
    CGFloat price2=[object.price floatValue]*[object.foodCount integerValue]+assoItemPrice;
    totalPricewithtaxandassociateItemPrice=price2+totalPricewithtaxandassociateItemPrice;
    NSString *taxVal=[ECSUserDefault getObjectFromUserDefaultForKey:@"tax_value"];
     CGFloat vatP=totalPricewithtaxandassociateItemPrice*[taxVal floatValue]/100;
  NSString *taxname=[ECSUserDefault getObjectFromUserDefaultForKey:@"tax_name"];
    
    self.lblPreviousTotalPrice.text=[NSString stringWithFormat:@"Previous total price :    %@",@"INR 0.00"];
    self.lblOngoingTotalPrice.text=[NSString stringWithFormat:@"Ongoing total price :   INR %.2f",totalPricewithtaxandassociateItemPrice];
    self.lblVatTotalPrice.text=[NSString stringWithFormat:@"%@ %@%@ :       INR %.2f",taxname,taxVal,@"%",vatP];
    self.lblTotalPayablePrice.text=[NSString stringWithFormat:@"Total payable price :    %.2f",totalPricewithtaxandassociateItemPrice+vatP];
    
    
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


-(void)removeAllSaveData{
    NSMutableArray *oldFoodid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"oldFoodId"] mutableCopy];
    NSArray *ooldFoodid = [[NSSet setWithArray:oldFoodid] allObjects];
    
    for (int i=0; i<ooldFoodid.count; i++) {
        NSString *key=[NSString stringWithFormat:@"placeOrder%@",[ooldFoodid objectAtIndex:i]];
         [ECSUserDefault RemoveObjectFromUserDefaultForKey:key];
    }
    [ECSUserDefault RemoveObjectFromUserDefaultForKey:@"oldFoodId"];

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
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                          self.appUserObject.resturantId, @"resturant_id",
                           self.appUserObject.user_id, @"user_id",
                           @"1", @"type",
                           @"0", @"status",
                          totalPrice, @"total_price",
                          @"0", @"sales_tax",
                          taxPrice, @"service_tax",
                          totalPrice, @"payable_amount",
                          self.arayjsonOrder, @"orders",
                          nil];
    


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
    [self startServiceToGetHomeDelivery];
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
    
    [class setServiceURL:[NSString stringWithFormat:@"%@add_food_orders",SERVERURLPATH]];
    
   // {"user_id": "23","resturant_id": "4","table_id": "9","type": "2","status": "1","total_price":"450","sales_tax":"9.4","service_tax":"8.46","payable_amount":"111.8","orders": [{"food_id": "3","name": "Hamburger","food_code": "hamburger","qty": 1,"price": 70,"items": [{"asscioted_food_id": "1","asscioted_food_name": "Curd-001","asscioted_food_code": "Curd-123","asscioted_qty": 2,"asscioted_price": "40"}, {"asscioted_food_id": "3","asscioted_food_name": "Ratia","asscioted_food_code": "Ratia-123","asscioted_qty": 1,"asscioted_price": 0}]}, {"food_id ": "8","food_code": "biryani01","name": "Dum Biryani","qty": 1,"price ": "30","items": null}]}
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                 self.appUserObject.resturantId, @"resturant_id",
                                 self.appUserObject.user_id, @"user_id",
                                 tbleId,@"table_id",
                                 @"2", @"type",
                                 @"0", @"status",
                                 totalPrice, @"total_price",
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
//        HomeDeliveryVC *nav=[[HomeDeliveryVC alloc]initWithNibName:@"HomeDeliveryVC" bundle:nil];
//        nav.dict=rootDictionary;
//        nav.arrayJason=self.arayjsonOrder;
//        [self.navigationController pushViewController:nav animated:YES];
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







/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
