//
//  OrderHistryObject.h
//  TABQY MENU
//
//  Created by ASK ONLINE  on 17/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OrderHistryObject : NSObject {
    NSString *custStatus;
    NSString *orderDate;
    NSString *orderNum;
    NSString *orderSatatus;
    
    NSString *ordrTime;
    NSString *orderValue;
    NSString *orderValueTax;
    NSString *tableId;
    NSString *tableName;
    NSString *type;
    NSString *waiterName;
    
    
}

@property (nonatomic, copy) NSString *custStatus;
@property (nonatomic, copy) NSString *orderDate;
@property (nonatomic, copy) NSString *orderNum;
@property (nonatomic, copy) NSString *orderSatatus;
@property (nonatomic, copy) NSString *ordrTime;
@property (nonatomic, copy) NSString *orderValue;
@property (nonatomic, copy) NSString *orderValueTax;
@property (nonatomic, copy) NSString *tableId;
@property (nonatomic, copy) NSString *tableName;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *waiterName;


+ (OrderHistryObject *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
