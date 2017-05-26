//
//  TableListObject.m
//  TABQY MENU
//
//  Created by ASK ONLINE  on 14/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import "TableListObject.h"

@implementation TableListObject



- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        
        
        self.restaurentId = [decoder decodeObjectForKey:@"resturant_id"];
        self.tableId = [decoder decodeObjectForKey:@"table_id"];
        self.tableName = [decoder decodeObjectForKey:@"table_name"];
        self.Booked = [decoder decodeObjectForKey:@"isBooked"];
           }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //appLogicId
    [encoder encodeObject:self.restaurentId forKey:@"resturant_id"];
    [encoder encodeObject:self.tableId forKey:@"table_id"];
    [encoder encodeObject:self.tableName forKey:@"table_name"];
     [encoder encodeObject:self.Booked forKey:@"isBooked"];
}

+ (TableListObject *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    TableListObject *instance = [[TableListObject alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
    
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    self.restaurentId = [aDictionary objectForKey:@"resturant_id"];
    self.tableId = [aDictionary objectForKey:@"table_id"];
    self.tableName = [aDictionary objectForKey:@"table_name"];
    self.Booked = [aDictionary objectForKey:@"isBooked"];
    
}


@end
