//
//  DS_SideMenuVC.h
//  DSale_Sale
//
//  Created by Daksha_Mac4 on 1/3/16.
//  Copyright © 2016 Daksha_Mac4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSBaseViewController.h"



@class DS_SidemenuCell;


@interface DS_SideMenuVC : ECSBaseViewController<UITableViewDataSource,UITableViewDataSource>

@property(strong ,nonatomic)IBOutlet UITableView *sideMenuTable;


-(void)ReloadTable:(NSMutableArray *)responseArray;
-(void)removeHomeCategory;
//@property (strong, nonatomic) IBOutlet DS_SidemenuCell *tblCell;

@end
