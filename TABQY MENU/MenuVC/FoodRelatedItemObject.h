//
//  FoodRelatedItemObject.h
//  TABQY MENU
//
//  Created by ASK ONLINE  on 07/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodRelatedItemObject : NSObject {
    NSString *discountPrice;
    NSString *food_code;
    NSString *food_id;
    NSString *food_image;
    
    NSString *name;
    NSString *price;
    
}

@property (nonatomic, copy) NSString *discountPrice;
@property (nonatomic, copy) NSString *food_code;
@property (nonatomic, copy) NSString *food_id;
@property (nonatomic, copy) NSString *food_image;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *price;

+ (FoodRelatedItemObject *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
