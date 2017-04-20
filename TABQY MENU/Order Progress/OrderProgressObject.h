//
//  OrderProgressObject.h
//  TABQY MENU
//
//  Created by ASK ONLINE  on 17/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderProgressObject : NSObject {
    NSString *order_date;
    NSString *order_no;
    NSString *order_time;
    NSString *type;
    
  NSString *waiter_name;
    
    
}

@property (nonatomic, copy) NSString *order_date;
@property (nonatomic, copy) NSString *order_no;
@property (nonatomic, copy) NSString *order_time;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *waiter_name;


+ (OrderProgressObject *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
