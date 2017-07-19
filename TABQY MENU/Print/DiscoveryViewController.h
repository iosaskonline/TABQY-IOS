//
//  DiscoveryViewController.h
//  TABQY MENU
//
//  Created by ASK ONLINE  on 03/06/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ePOS2.h"
#import "ECSBaseViewController.h"
@protocol SelectPrinterDelegate<NSObject>
- (void)onSelectPrinter:(NSString *)target;
@end

@interface DiscoveryViewController : ECSBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    Epos2FilterOption *filteroption_;
    NSMutableArray *printerList_;
}
@property(weak, nonatomic) IBOutlet UIButton *buttonRestart;
@property(weak, nonatomic) IBOutlet UITableView *printerView_;
@property(weak, nonatomic)id<SelectPrinterDelegate> delegate;
@end
