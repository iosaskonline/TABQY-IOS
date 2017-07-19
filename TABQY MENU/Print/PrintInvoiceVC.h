//
//  PrintInvoiceVC.h
//  TABQY MENU
//
//  Created by ASK ONLINE  on 01/06/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSBaseViewController.h"
#import "OrderHistryObject.h"
#import "PickerTableView.h"
#import "DiscoveryViewController.h"
#import "ePOS2.h"

@interface PrintInvoiceVC :ECSBaseViewController<SelectPrinterDelegate, SelectPickerTableDelegate>

{
    Epos2Printer *printer_;
    int printerSeries_;
    int lang_;
    PickerTableView *printerList_;
    PickerTableView *langList_;
}
@property(strong,nonatomic) OrderHistryObject *orderObj;
@property(strong, nonatomic)  NSString *textTarget;
@property(strong, nonatomic)  NSString *orderNumber;

@property(strong, nonatomic)  NSString *selectedPrinter;
@property(weak, nonatomic) IBOutlet UIButton *buttonDiscovery;
@property(weak, nonatomic) IBOutlet UIButton *buttonPrinter;
@property(weak, nonatomic) IBOutlet UIButton *buttonLang;
@property(weak, nonatomic) IBOutlet UIButton *buttonReceipt;
@property(weak, nonatomic) IBOutlet UIButton *buttonCoupon;
@property(weak, nonatomic) IBOutlet UITextView *textWarnings;
@end
