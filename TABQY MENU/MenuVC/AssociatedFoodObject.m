//
//  AssociatedFoodObject.m
//  TABQY MENU
//
//  Created by ASK ONLINE  on 14/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import "AssociatedFoodObject.h"


@implementation AssociatedFoodObject
+ (AssociatedFoodObject *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    AssociatedFoodObject *instance = [[AssociatedFoodObject alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
    
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    self.assoFoodAvailability = [aDictionary objectForKey:@"associated_food_food_availability"];
    self.assoFoodDiscription = [aDictionary objectForKey:@"associated_food_description"];
    self.assoFoodAvailabilityTime = [aDictionary objectForKey:@"associated_food_availability_time"];
    self.associatedFoodCode = [aDictionary objectForKey:@"associated_food_food_code"];
    
    self.associatedFoodimage = [aDictionary objectForKey:@"associated_food_food_image"];
    self.associatedFoodId = [aDictionary objectForKey:@"associated_food_id"];
    
    self.associatedFoodName = [aDictionary objectForKey:@"associated_food_name"];
    self.associatedFoodPrice = [aDictionary objectForKey:@"associated_food_price"];
    
}


@end
