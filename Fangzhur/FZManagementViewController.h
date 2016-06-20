//
//  FZManagementViewController.h
//  Fangzhur
//
//  Created by --超-- on 14-7-19.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZRootTableViewController.h"
#import "FZManagementCell.h"
#import "FZOrderMenuBar.h"

@interface FZManagementViewController : FZRootTableViewController
<UIAlertViewDelegate, FZManagementCellDelegate>

- (void)reloadView;

@end
