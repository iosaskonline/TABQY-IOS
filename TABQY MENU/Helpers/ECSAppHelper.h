//
//  ECSHelper.h
//  TME
//
//  Created by Shreesh Garg on 03/12/13.
//  Copyright (c) 2013 Shreesh Garg. All rights reserved.
//




#import <Foundation/Foundation.h>
#import "ECSHelper.h"





@interface ECSAppHelper : ECSHelper
+(NSString *)getUniqueApplogicName:(NSString *)userId andEmail:(NSString *)email;
+(NSString *)getUniqueApplogicGroupName:(NSString *)userId andEmail:(NSString *)email;
+(NSString *)getUniqueStreamUrl:(NSString *)userId  stream:(NSString *)streamUrl;

    +(NSString *)getInvitationMailBody;
      +(NSString *)getAppName;
+(void)openBuckwormApp:(UIViewController *)controller;

@end







