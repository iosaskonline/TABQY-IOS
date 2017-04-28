//
//  FeedBackVC.h
//  TABQY MENU
//
//  Created by ASK ONLINE  on 01/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSBaseViewController.h"
#import "OrderHistryObject.h"
@interface FeedBackVC : ECSBaseViewController
-(void)clickToPlaceOrderList:(id)sender;
@property(strong,nonatomic) OrderHistryObject *orderObj;
@end
