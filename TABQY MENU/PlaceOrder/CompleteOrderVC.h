//
//  CompleteOrderVC.h
//  TABQY MENU
//
//  Created by ASK ONLINE  on 21/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSBaseViewController.h"
#import "OrderHistryObject.h"
@interface CompleteOrderVC : ECSBaseViewController
@property(strong,nonatomic)NSMutableArray *savedArray;
@property(strong,nonatomic) OrderHistryObject *orderObj;
@end
