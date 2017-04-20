//
//  OrderHistryObject.m
//  TABQY MENU
//
//  Created by ASK ONLINE  on 17/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import "OrderHistryObject.h"

@implementation OrderHistryObject

+ (OrderHistryObject *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    OrderHistryObject *instance = [[OrderHistryObject alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
    
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    self.custStatus = [aDictionary objectForKey:@"customer_status"];
    self.orderDate = [aDictionary objectForKey:@"order_date"];
    self.orderNum = [aDictionary objectForKey:@"order_no"];
    self.orderSatatus = [aDictionary objectForKey:@"order_status"];
    
    self.ordrTime = [aDictionary objectForKey:@"order_time"];
    self.orderValue = [aDictionary objectForKey:@"order_value"];
    self.orderValueTax = [aDictionary objectForKey:@"order_value_no_tax"];
    self.tableId = [aDictionary objectForKey:@"table_id"];

    self.tableName = [aDictionary objectForKey:@"table_name"];
    self.type = [aDictionary objectForKey:@"type"];
    self.waiterName = [aDictionary objectForKey:@"waiter_name"];
    

  

}


@end
