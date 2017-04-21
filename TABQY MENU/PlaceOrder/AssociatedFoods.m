//
//  AssociatedFoods.m
//  TABQY MENU
//
//  Created by ASK ONLINE  on 21/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import "AssociatedFoods.h"

@implementation AssociatedFoods
+ (AssociatedFoods *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    AssociatedFoods *instance = [[AssociatedFoods alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
    
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    self.assoFoodAvailability = [aDictionary objectForKey:@"associated_food_food_availability"];
    self.assoFoodDiscription = [aDictionary objectForKey:@"description"];
    self.assoFoodAvailabilityTime = [aDictionary objectForKey:@"associated_food_availability_time"];
    self.associatedFoodCode = [aDictionary objectForKey:@"associated_food_food_code"];
    
    self.associatedFoodimage = [aDictionary objectForKey:@"food_image"];
    self.associatedFoodId = [aDictionary objectForKey:@"associated_food_id"];
    
    self.associatedFoodName = [aDictionary objectForKey:@"name"];
    self.associatedFoodPrice = [aDictionary objectForKey:@"price"];
    
}


@end
