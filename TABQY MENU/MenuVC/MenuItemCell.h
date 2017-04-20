//
//  MenuItemCell.h
//  TABQY MENU
//
//  Created by ASK ONLINE  on 03/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuItemCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img_view;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblCity;
@property (weak, nonatomic) IBOutlet UIView *viewBg;
@end
