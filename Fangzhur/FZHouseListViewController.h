//
//  FZHouseListViewController.h
//  Fangzhur
//
//  Created by --超-- on 14/11/8.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZRootTableViewController.h"
#import "FZHouseListModel.h"
#import "FZHouseListCell.h"

@interface FZHouseListViewController : FZRootTableViewController

@property (nonatomic, strong) UIButton *bottomButton; //写在这里是为了方便子类修改
@property (nonatomic, strong) FZWaitingView *waitingView;

@property (nonatomic, strong) NSMutableArray *requestArray;
@property (nonatomic, copy) NSString *houseType;
// 存放请求后的房源数据
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, copy) NSString *tagName;

- (void)configureUI;
- (void)gotoSignAContract:(UIButton *)sender;
- (void)popViewController;
- (void)gotoNextView;
- (void)headerRefreshing;

@end
