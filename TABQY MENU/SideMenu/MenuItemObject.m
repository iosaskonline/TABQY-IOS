//
//  MenuItemObject.m
//  TABQY MENU
//
//  Created by ASK ONLINE  on 05/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import "MenuItemObject.h"

@implementation MenuItemObject
+ (MenuItemObject *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    MenuItemObject *instance = [[MenuItemObject alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
    
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    
    self.itemColor = [aDictionary objectForKey:@"color_code"];
    self.image = [aDictionary objectForKey:@"image"];
    self.name = [aDictionary objectForKey:@"name"];
    self.menuId = [aDictionary objectForKey:@"id"];
    // self.cusineName = [aDictionary objectForKey:@"name"];
    
    
}
@end
