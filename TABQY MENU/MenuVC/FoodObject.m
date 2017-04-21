//
//  FoodObject.m
//  TABQY MENU
//
//  Created by ASK ONLINE  on 05/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import "FoodObject.h"

@implementation FoodObject



- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        
    
        self.associatedFood = [decoder decodeObjectForKey:@"associated_food"];
        self.foodName = [decoder decodeObjectForKey:@"name"];
        self.price = [decoder decodeObjectForKey:@"price"];
        self.discountPrice = [decoder decodeObjectForKey:@"discount_price"];
        
        self.foodAvailability = [decoder decodeObjectForKey:@"food_availability"];
        self.foodImage = [decoder decodeObjectForKey:@"food_image"];
        self.foodCode = [decoder decodeObjectForKey:@"food_code"];
        self.foodId = [decoder decodeObjectForKey:@"food_id"];
        self.foodCount = [decoder decodeObjectForKey:@"count"];
         self.foodqty = [decoder decodeObjectForKey:@"qty"];
        self.foodDescription = [decoder decodeObjectForKey:@"description"];
        
        
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //appLogicId
    [encoder encodeObject:self.associatedFood forKey:@"associated_food"];
     [encoder encodeObject:self.foodqty forKey:@"qty"];
    [encoder encodeObject:self.foodName forKey:@"name"];
    [encoder encodeObject:self.price forKey:@"price"];
    [encoder encodeObject:self.discountPrice forKey:@"discount_price"];
    
    
    [encoder encodeObject:self.foodAvailability forKey:@"food_availability"];
    
    
    
    [encoder encodeObject:self.foodImage forKey:@"food_image"];
    [encoder encodeObject:self.foodCode forKey:@"food_code"];
    [encoder encodeObject:self.foodId forKey:@"food_id"];
    [encoder encodeObject:self.foodCount forKey:@"count"];
    
    
    [encoder encodeObject:self.foodDescription forKey:@"description"];
   
    
    
}







+ (FoodObject *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    FoodObject *instance = [[FoodObject alloc] init];
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
    self.foodqty = [aDictionary objectForKey:@"qty"];
    self.foodDescription = [aDictionary objectForKey:@"description"];
}




@end
