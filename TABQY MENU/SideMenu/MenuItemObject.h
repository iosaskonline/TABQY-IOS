//
//  MenuItemObject.h
//  TABQY MENU
//
//  Created by ASK ONLINE  on 05/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MenuItemObject : NSObject {
    NSString *itemColor;
    NSString *image;
    NSString *Name;
    NSString *menuId;
    
}

@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *itemColor;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *menuId;

+ (MenuItemObject *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
