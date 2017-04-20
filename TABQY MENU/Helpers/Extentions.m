//
//  NSMutableArray+Extentions.m
//  Ag Mobile App
//
//  Created by Shreesh Garg on 10/05/13.
//  Copyright (c) 2013 Developer. All rights reserved.
//

#import "Extentions.h"

@implementation NSMutableArray (Extentions)

-(id)objectWithIndex:(int)index
{
    
    id object=@"";
    if(self.count > index)
    {
        object=[self objectAtIndex:index];
    }
    return object;

}

- (void)reverse {
    if ([self count] == 0)
        return;
    NSUInteger i = 0;
    NSUInteger j = [self count] - 1;
    while (i < j) {
        [self exchangeObjectAtIndex:i
                  withObjectAtIndex:j];
        
        i++;
        j--;
    }
}


@end


@implementation NSString (Extentions)

+(NSString *)stringWithFloat:(float)f
{
   
    NSString *string=[NSString stringWithFormat:@"%f",f];
    return string;

}

+(NSString *)stringWithInt:(int)f
{
    
    NSString *string=[NSString stringWithFormat:@"%i",f];
    return string;
    
}

+(NSString *)stringWithBool:(BOOL)bools
{
    NSNumber *number = [NSNumber numberWithBool:bools];
    return [number stringValue];
    
}


-(NSDate *)toNSDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *returnDate = [formatter dateFromString:self];
    return returnDate;
}

@end


@implementation NSNumber (Extentions)



@end


@implementation NSDictionary (Extentions)

-(id)nonNullObjectForKey:(NSString *)string
{
    id object = [self objectForKey:string];
    if([object isKindOfClass:[NSNull class]]) return @"";
    else return object;

}

-(id)nonNullNumberForKey:(NSString *)string
{
    NSNumber *object = [self objectForKey:string];
    if(!object) return [NSNumber numberWithInt:-1];
    else if([object isKindOfClass:[NSNull class]])
        return [NSNumber numberWithInt:-1];
    else return object;
    
}




@end
