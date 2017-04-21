//
//  AssociatedFoods.h
//  TABQY MENU
//
//  Created by ASK ONLINE  on 21/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AssociatedFoods : NSObject {
    NSString *assoFoodAvailability;
    NSString *assoFoodDiscription;
    NSString *assoFoodAvailabilityTime;
    NSString *associatedFoodCode;
    
    NSString *associatedFoodimage;
    NSString *associatedFoodId;
    
    NSString *associatedFoodName;
    NSString *associatedFoodPrice;
    
}

@property (nonatomic, copy) NSString *assoFoodAvailability;
@property (nonatomic, copy) NSString *assoFoodDiscription;
@property (nonatomic, copy) NSString *assoFoodAvailabilityTime;
@property (nonatomic, copy) NSString *associatedFoodCode;

@property (nonatomic, copy) NSString *associatedFoodimage;
@property (nonatomic, copy) NSString *associatedFoodId;

@property (nonatomic, copy) NSString *associatedFoodName;
@property (nonatomic, copy) NSString *associatedFoodPrice;
+ (AssociatedFoods *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
