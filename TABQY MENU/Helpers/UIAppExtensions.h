//
//  UIExtensions.h
//  SecureCredentials
//
//  Created by Shreesh Garg on 01/10/13.
//  Copyright (c) 2013 SecureCredentials. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface UIButton  (AppExtensions)




@end



@interface UITextField  (AppExtensions)

-(void)setFont_hint_input_text;
-(void)setFont_input_text;



@end

@interface UITextView  (AppExtensions)

-(void)setFont_hint_input_text;
-(void)setFont_input_text;



@end





@interface UILabel  (Extensions)

// These name conventions are based on Erika's HTML

-(void)setFont_H1;
-(void)setFont_H2;
-(void)setFont_H3;
-(void)setFont_H4;
-(void)setFont_H5;
-(void)setFontKalra:(float)size;

@end

@interface UIFont (Extensions)

+(UIFont *)setFont_H1;
+(UIFont *)setFont_H2;
+(UIFont *)setFont_H3;
+(UIFont *)setFont_H4;
+(UIFont *)setFont_H5;
+(UIFont *)setFontKalra;
@end








