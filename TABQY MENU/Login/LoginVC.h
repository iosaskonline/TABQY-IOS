//
//  LoginVC.h
//  TABQY MENU
//
//  Created by ASK ONLINE  on 01/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSBaseViewController.h"
@interface LoginVC : ECSBaseViewController<UITextFieldDelegate, UIAlertViewDelegate>
{
      NSMutableData *recieveData;
}
@end
