//
//  CousineObject.h
//  TABQY MENU
//
//  Created by ASK ONLINE  on 04/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CousineObject: NSObject {
    
    NSString *image;
    NSString *cusineName;
    NSString *cusineId;
    
}
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *cusineName;
@property (nonatomic, copy) NSString *cusineId;

+ (CousineObject *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
