//
//  CousineObject.m
//  TABQY MENU
//
//  Created by ASK ONLINE  on 04/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import "CousineObject.h"

@implementation CousineObject
+ (CousineObject *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    CousineObject *instance = [[CousineObject alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
    
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    self.cusineId = [aDictionary objectForKey:@"cusinie_id"];
    self.image = [aDictionary objectForKey:@"cusinie_image"];
    self.cusineName = [aDictionary objectForKey:@"name"];
  
    
}

@end
