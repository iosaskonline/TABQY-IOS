//
//  OrderHistoryTableCell.h
//  TABQY MENU
//
//  Created by ASK ONLINE  on 17/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderHistoryTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbldate;
@property (weak, nonatomic) IBOutlet UILabel *lblvalue;
@property (weak, nonatomic) IBOutlet UILabel *lblwaitername;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderTime;
@property (weak, nonatomic) IBOutlet UILabel *lbltablename;
@property (weak, nonatomic) IBOutlet UIButton *btnFeedback;
@property (weak, nonatomic) IBOutlet UIButton *btnDetail;
@property (weak, nonatomic) IBOutlet UIButton *btnPrint;
@end
