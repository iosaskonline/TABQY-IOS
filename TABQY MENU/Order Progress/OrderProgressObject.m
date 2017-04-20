//
//  OrderProgressObject.m
//  TABQY MENU
//
//  Created by ASK ONLINE  on 17/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import "OrderProgressObject.h"

@implementation OrderProgressObject

+ (OrderProgressObject *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    OrderProgressObject *instance = [[OrderProgressObject alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
    
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    self.order_date = [aDictionary objectForKey:@"order_date"];
    self.order_no = [aDictionary objectForKey:@"order_no"];
    self.order_time = [aDictionary objectForKey:@"order_time"];
    self.type = [aDictionary objectForKey:@"type"];
    self.waiter_name = [aDictionary objectForKey:@"waiter_name"];
  
}


@end
