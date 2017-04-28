//
//  QuestionObject.m
//  TABQY MENU
//
//  Created by ASK ONLINE  on 27/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import "QuestionObject.h"


@implementation QuestionObject
+ (QuestionObject *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    QuestionObject *instance = [[QuestionObject alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
    
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    self.question = [aDictionary objectForKey:@"question"];
    self.question_id = [aDictionary objectForKey:@"question_id"];
    self.question_type = [aDictionary objectForKey:@"question_type"];
    self.answer = [aDictionary objectForKey:@"answer"];
    
}


@end
