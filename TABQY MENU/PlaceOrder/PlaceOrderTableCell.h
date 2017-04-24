//
//  PlaceOrderTableCell.h
//  TABQY MENU
//
//  Created by ASK ONLINE  on 10/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceOrderTableCell : UITableViewCell
@property(weak,nonatomic)IBOutlet UILabel *lblFoodName;
@property(weak,nonatomic)IBOutlet UILabel *lblFoodprice;
@property(weak,nonatomic)IBOutlet UILabel *lbldescription;
@property(weak,nonatomic)IBOutlet UIImageView *imgFood;
@property(weak,nonatomic)IBOutlet UILabel *lblCount;
@property(weak,nonatomic)IBOutlet UILabel *lblassociatedItem;
@property(weak,nonatomic)IBOutlet UITextView *txtassociatedItem;
@property(weak,nonatomic)IBOutlet UIButton *btnAdd;
@property(weak,nonatomic)IBOutlet UIButton *btnDelete;

@property(weak,nonatomic)IBOutlet UIButton *btnCancel;
@property(weak,nonatomic)IBOutlet UIActivityIndicatorView *activityInd;
@end
