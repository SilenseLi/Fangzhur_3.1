//
//  FZOrderTableView.h
//  Fangzhur
//
//  Created by --Chao-- on 14-7-4.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZServingOrderCell.h"
#import "FZReleaseOrderCell.h"
#import "FZCompleteOrderCell.h"
#import "FZOrdersModel.h"
#import "FZChooseAgentView.h"

@protocol FZOrderTableViewDelegate;

typedef enum _RefreshType {
    UP,
    DOWN
} RefreshType;

//我的订单的table view单元
@interface FZOrderTableView : UITableViewCell
<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) FZChooseAgentView *agentChooseView;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSMutableArray *agentArray;
@property (nonatomic, assign) id <FZOrderTableViewDelegate> delegate;

@end

@protocol FZOrderTableViewDelegate <NSObject>

/**
 *  @brief 开始刷新操作时调用
 */
- (void)orderTableView:(FZOrderTableView *)cell startRefresh:(RefreshType)type;
- (void)informOrderWithID:(NSString *)orderId agentInfo:(NSString *)info;
- (void)gotoCompleteService:(FZServingOrderCell *)cell;

@end

