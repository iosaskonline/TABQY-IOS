//
//  FeedbackTableCell.h
//  TABQY MENU
//
//  Created by ASK ONLINE  on 26/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackTableCell : UITableViewCell
{
  
}
@property (weak, nonatomic) IBOutlet UILabel *lblQues;
@property (weak, nonatomic) IBOutlet UIView *viewRadiotype2;
@property (weak, nonatomic) IBOutlet UIView *viewtextEntryType;



@property (weak, nonatomic) IBOutlet UIButton *btnRadioYes;
@property (weak, nonatomic) IBOutlet UIButton *btnRadioNo;
@property(strong,nonatomic)  UISegmentedControl *segmentedControl;

@end
