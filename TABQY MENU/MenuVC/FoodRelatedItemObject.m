//
//  FoodRelatedItemObject.m
//  TABQY MENU
//
//  Created by ASK ONLINE  on 07/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import "FoodRelatedItemObject.h"

@implementation FoodRelatedItemObject
+ (FoodRelatedItemObject *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    FoodRelatedItemObject *instance = [[FoodRelatedItemObject alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
    
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    self.discountPrice = [aDictionary objectForKey:@"discount_price"];
    self.food_code = [aDictionary objectForKey:@"food_code"];
    self.food_id = [aDictionary objectForKey:@"food_id"];
    self.food_image = [aDictionary objectForKey:@"food_image"];
    
    self.name = [aDictionary objectForKey:@"name"];
    self.price = [aDictionary objectForKey:@"price"];
}


@end
