//
//  UIExtensions.m
//  SecureCredentials
//
//  Created by Shreesh Garg on 01/10/13.
//  Copyright (c) 2013 SecureCredentials. All rights reserved.
//

#import "UIAppExtensions.h"
#import "UIExtensions.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>




@implementation UIButton  (AppExtensions)

// TY specific methods



@end




@implementation UITextField  (AppExtensions)





@end


@implementation UITextView  (AppExtensions)









@end









@implementation UILabel (AppExtensions)


// Start TY specific methods

-(void)setFont_H1
{

    [self setTextColor:[UIColor colorWithR:51 G:51 B:51]];
    [self setFont:[UIFont setFont_H1]];


}
-(void)setFont_H2
{
    [self setTextColor:[UIColor colorWithR:153 G:153 B:153]];
    [self setFont:[UIFont setFont_H2]];
}
-(void)setFont_H3
{
    [self setTextColor:[UIColor colorWithR:51 G:51 B:51]];
    [self setFont:[UIFont setFont_H3]];
}

-(void)setFont_H4
{
    [self setTextColor:[UIColor colorWithR:51 G:51 B:51]];
    [self setFont:[UIFont setFont_H4]];
}
-(void)setFont_H5
{
    [self setTextColor:[UIColor colorWithR:255 G:255 B:255]];
    [self setFont:[UIFont setFont_H5]];
}
-(void)setFontKalra:(float)size
{
    [self setFont:[UIFont fontWithName:@"Karla-Bold" size:size]];
}


@end





@implementation UIView (Extensions)

//- (void)setViewColorSoftRedColor
//{
//    [self setBackgroundColor:[UIColor colorWithRed:238.0/255.0f green:105.0/255.0f blue:96.0/255.0f alpha:1.0f]];
//    
//    
//}

@end



@implementation UIFont (AppExtensions)





+(UIFont *)setFont_H1
{
    return [UIFont fontWithName:@"ArialBold-MT" size:19.0f];
}
+(UIFont *)setFont_H2{
    return [UIFont fontWithName:@"Arial" size:16.0f];
}
+(UIFont *)setFont_H3{
    return [UIFont fontWithName:@"ArialBold-MT" size:16.0f];
    
}
+(UIFont *)setFontKalra{
    return [UIFont fontWithName:@"Karla-Regular" size:15.0f];
    
}
+(UIFont *)setFont_H4{
     return [UIFont fontWithName:@"Arial" size:16.0f];
}
+(UIFont *)setFont_H5{
    
     return [UIFont fontWithName:@"ArialBold-MT" size:16.0f];
    
}
+(UIFont *)setFontKalra:(float)size
{
    return[UIFont fontWithName:@"Karla-Bold" size:size];
}


@end


