//
//  QuestionObject.h
//  TABQY MENU
//
//  Created by ASK ONLINE  on 27/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionObject : NSObject {
    NSDictionary *question;
    NSString *question_id;
    NSString *question_type;
    NSString *answer;
    
}

@property (nonatomic, copy) NSDictionary *question;
@property (nonatomic, copy) NSString *question_id;
@property (nonatomic, copy) NSString *question_type;
@property (nonatomic, copy) NSString *answer;

+ (QuestionObject *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
