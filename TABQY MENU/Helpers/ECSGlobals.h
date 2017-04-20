//
//  ECSGlobals.h
//  TrustYoo
//
//  Created by Shreesh Garg on 07/11/14.
//  Copyright (c) 2014 Shreesh Garg. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Constants;
@class AccessKeys;


@interface ECSGlobals : NSObject


@property (nonatomic, retain) Constants * constant;
@property (nonatomic, retain) AccessKeys * accessKeys;
@property (nonatomic, retain) NSString * jsonString;


+(ECSGlobals *)sharedInstance;

@end
