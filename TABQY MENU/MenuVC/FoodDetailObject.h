//
//  FoodDetailObject.h
//  TABQY MENU
//
//  Created by ASK ONLINE  on 07/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FoodDetailObject : NSObject {
    
    NSMutableArray *associatedFood;
    NSString *foodName;
    NSString *price;
    
    NSString *discountPrice;
    NSString *foodAvailability;
    NSString *foodImage;
    NSString *foodCode;
    NSString *foodId;
    NSString *foodDescription;
    NSString *foodCount;
     NSString *foodcategory;
}


@property (nonatomic, copy) NSString *foodcategory;

@property (nonatomic, copy) NSString *foodCount;
@property (nonatomic, copy) NSMutableArray *associatedFood;
@property (nonatomic, copy) NSString *foodName;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *discountPrice;

@property (nonatomic, copy) NSString *foodAvailability;
@property (nonatomic, copy) NSString *foodImage;
@property (nonatomic, copy) NSString *foodCode;
@property (nonatomic, copy) NSString *foodId;
@property (nonatomic, copy) NSString *foodDescription;

+ (FoodDetailObject *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
