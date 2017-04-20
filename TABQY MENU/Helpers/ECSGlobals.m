//
//  ECSGlobals.m
//  TrustYoo
//
//  Created by Shreesh Garg on 07/11/14.
//  Copyright (c) 2014 Shreesh Garg. All rights reserved.
//

#import "ECSGlobals.h"


static ECSGlobals * ecsGlobals;

@implementation ECSGlobals
//@synthesize constant;
//@synthesize accessKeys;



+(ECSGlobals *)sharedInstance
{
   if(ecsGlobals == nil)
   {
       ecsGlobals = [[ECSGlobals alloc]init];
       ecsGlobals.constant = nil;
       ecsGlobals.accessKeys = nil;
       ecsGlobals.jsonString = nil;
   }
   return ecsGlobals;
}


@end
