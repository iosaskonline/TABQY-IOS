//
//  FoodTypeObject.m
//  TABQY MENU
//
//  Created by ASK ONLINE  on 05/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import "FoodTypeObject.h"


@implementation FoodTypeObject
+ (FoodTypeObject *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    FoodTypeObject *instance = [[FoodTypeObject alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
    
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    self.foodId = [aDictionary objectForKey:@"foodtype_id"];
    self.FoodName = [aDictionary objectForKey:@"dish_name"];
   // self.cusineName = [aDictionary objectForKey:@"name"];
    
    
}
@end
