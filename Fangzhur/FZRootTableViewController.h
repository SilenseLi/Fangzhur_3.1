//
//  FZRootTableViewController.h
//  Fangzhur
//
//  Created by --Chao-- on 14-6-19.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZScrolledNavigationBarController.h"
#import "MJRefresh.h"

@interface FZRootTableViewController : FZScrolledNavigationBarController
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

/** 设置横向 Tableview */
- (void)reverseTableView;

@end
