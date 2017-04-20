//
//  HotDealTableCell.h
//  TABQY MENU
//
//  Created by ASK ONLINE  on 12/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotDealTableCell : UITableViewCell
@property(weak,nonatomic)IBOutlet UILabel *lblFoodName;
@property(weak,nonatomic)IBOutlet UILabel *lblFoodprice;
@property(weak,nonatomic)IBOutlet UILabel *lbldescription;
@property(weak,nonatomic)IBOutlet UIImageView *imgFood;
@property(weak,nonatomic)IBOutlet UILabel *lblCount;
@property(weak,nonatomic)IBOutlet UIButton *btnAdd;
@property(weak,nonatomic)IBOutlet UIButton *btnDelete;
@property(weak,nonatomic)IBOutlet UIImageView *imgLogo;
@property(weak,nonatomic)IBOutlet UIButton *btnCheck;
@end