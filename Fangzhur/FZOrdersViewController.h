//
//  FZOrdersViewController.h
//  Fangzhur
//
//  Created by --超-- on 14/12/8.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZRootTableViewController.h"
#import "FZOrderTableView.h"

@interface FZOrdersViewController : FZRootTableViewController
<FZOrderTableViewDelegate, UIAlertViewDelegate>

- (void)reloadView;

@end
