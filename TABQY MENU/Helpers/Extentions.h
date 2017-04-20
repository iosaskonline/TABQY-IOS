//
//  NSMutableArray+Extentions.h
//  Ag Mobile App
//
//  Created by Shreesh Garg on 10/05/13.
//  Copyright (c) 2013 Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extentions)


@end



@interface NSMutableArray (Extentions)

-(id)objectWithIndex:(int)index;
- (void)reverse;

@end


@interface NSString (Extentions)

+(NSString *)stringWithFloat:(float)f;
+(NSString *)stringWithInt:(int)f;
+(NSString *)stringWithBool:(BOOL)bools;
-(NSDate *)toNSDate;

@end


@interface NSNumber (Extentions)

@end


@interface NSDictionary (Extentions)

-(id)nonNullObjectForKey:(NSString *)string;
-(id)nonNullNumberForKey:(NSString *)string;

@end