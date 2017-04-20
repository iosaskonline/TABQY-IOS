//
//  FoodDetailObject.m
//  TABQY MENU
//
//  Created by ASK ONLINE  on 07/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import "FoodDetailObject.h"


@implementation FoodDetailObject
+ (FoodDetailObject *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    FoodDetailObject *instance = [[FoodDetailObject alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
    
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    
    self.associatedFood = [aDictionary objectForKey:@"associated_food"];
    self.foodName = [aDictionary objectForKey:@"name"];
    self.price = [aDictionary objectForKey:@"price"];
    self.discountPrice = [aDictionary objectForKey:@"discount_price"];
    
    self.foodAvailability = [aDictionary objectForKey:@"food_availability"];
    self.foodImage = [aDictionary objectForKey:@"food_image"];
    self.foodCode = [aDictionary objectForKey:@"food_code"];
    self.foodId = [aDictionary objectForKey:@"food_id"];
    self.foodCount = [aDictionary objectForKey:@"count"];
    self.foodDescription = [aDictionary objectForKey:@"description"];//
    self.foodcategory=[aDictionary objectForKey:@"categories"];
}




@end
