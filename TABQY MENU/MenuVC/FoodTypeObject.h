//
//  FoodTypeObject.h
//  TABQY MENU
//
//  Created by ASK ONLINE  on 05/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodTypeObject : NSObject {
    NSString *foodId;
    NSString *FoodName;
  
    
}

@property (nonatomic, copy) NSString *foodId;
@property (nonatomic, copy) NSString *FoodName;


+ (FoodTypeObject *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
