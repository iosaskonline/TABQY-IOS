//
//  PrintTableCell.h
//  TABQY MENU
//
//  Created by ASK ONLINE  on 01/06/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrintTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblItemName;
@property (weak, nonatomic) IBOutlet UILabel *lblItemPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblItemQty;
@property (weak, nonatomic) IBOutlet UILabel *lblItemTotalPrice;

@end
