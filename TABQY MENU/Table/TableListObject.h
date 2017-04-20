//
//  TableListObject.h
//  TABQY MENU
//
//  Created by ASK ONLINE  on 14/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableListObject : NSObject {
    NSString *restaurentId;
    NSString *tableId;
    NSString *tableName;;
    
}


@property (nonatomic, copy) NSString *restaurentId;
@property (nonatomic, copy) NSString *tableId;
@property (nonatomic, copy) NSString *tableName;

+ (TableListObject *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
