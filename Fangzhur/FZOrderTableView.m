//
//  FZOrderTableView.m
//  Fangzhur
//
//  Created by --Chao-- on 14-7-4.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZOrderTableView.h"
#import "MJRefresh.h"

@interface FZOrderTableView ()
{
    int index;
    FZReleaseOrderCell *_currenCell;
}

- (void)UIConfig;
//举报订单
- (void)gotoInfomOrder:(FZServingOrderCell *)cell;

@end

@implementation FZOrderTableView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _dataArray    = [[NSMutableArray alloc] init];
        _agentArray   = [[NSMutableArray alloc] init];
        
        [self UIConfig];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)UIConfig
{
    self.frame = CGRectMake(0, 0, SCREEN_HEIGHT - 108, SCREEN_WIDTH);
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 8, SCREEN_WIDTH, self.frame.size.width)
                                              style:UITableViewStylePlain];
    _tableView.allowsSelection = NO;
    _tableView.backgroundColor = RGBColor(230, 230, 230);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"FZServingOrderCell" bundle:nil] forCellReuseIdentifier:@"FZServingOrderCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"FZReleaseOrderCell" bundle:nil] forCellReuseIdentifier:@"FZReleaseOrderCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"FZCompleteOrderCell" bundle:nil] forCellReuseIdentifier:@"FZCompleteOrderCell"];
    
    [_tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
}

#pragma mark - 举报订单 -

- (void)gotoInfomOrder:(FZServingOrderCell *)cell
{
    [_delegate informOrderWithID:cell.orderNumLabel.text agentInfo:cell.agentLabel.text];
}

#pragma mark - Table view delegate -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FZOrdersModel *model = [_dataArray objectAtIndex:indexPath.row];
    switch (model.order_state.intValue) {
        case 1://发布的订单
            return 290;
        case 2://进行中的订单
        case 3:
            return 310;
        case 4://完成的订单//回收站的订单
            return 290;
        case 10:
            return 220;
        case 21://退款的订单
        case 22:
            return 290;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FZOrdersModel *currentModel = [_dataArray objectAtIndex:indexPath.row];
    UITableViewCell *currentCell = nil;
    
    if (currentModel.order_state.intValue == 2 ||
        currentModel.order_state.intValue == 3) {//进行中
        FZServingOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FZServingOrderCell"];
        [cell addTarget:self action:@selector(gotoInfomOrder:)];
        cell.commentButton.tag = indexPath.row;
        [cell.commentButton addTarget:self action:@selector(commentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell fillDataWithModel:currentModel];
        currentCell = cell;
    }
    else if (currentModel.order_state.intValue == 1  ||
             currentModel.order_state.intValue == 21 ||
             currentModel.order_state.intValue == 22) {//发布、退款
        FZReleaseOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FZReleaseOrderCell"];
        [cell fillDataWithModel:currentModel];
        cell.agentButton.tag = indexPath.row;
        cell.cancelButton.tag = indexPath.row;
        [cell.agentButton addTarget:self action:@selector(chooseAgent:) forControlEvents:UIControlEventTouchUpInside];
        [cell.cancelButton addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
        currentCell = cell;
    }
    else if (currentModel.order_state.intValue == 4 ||
             currentModel.order_state.intValue == 10) {//完成、回收站
        FZCompleteOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FZCompleteOrderCell"];
        [cell fillDataWithModel:currentModel];
        currentCell = cell;
    }
    
    currentCell.tag = indexPath.row;
    return currentCell;
}

#pragma mark - 刷新 -

- (void)headerRefreshing
{
//    [_dataArray removeAllObjects];
    if ([_delegate respondsToSelector:@selector(orderTableView:startRefresh:)]) {
        [_delegate orderTableView:self startRefresh:UP];
    }
}

- (void)footerRefreshing
{
    if ([_delegate respondsToSelector:@selector(orderTableView:startRefresh:)]) {
        [_delegate orderTableView:self startRefresh:DOWN];
    }
}

#pragma mark - 选择顾问 -

- (void)chooseAgent:(UIButton *)sender
{
    FZReleaseOrderCell *cell = (FZReleaseOrderCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    _currenCell = cell;
    
    if (_agentArray.count == 0) {
        [JDStatusBarNotification showWithStatus:@"还没有顾问进行抢单!" dismissAfter:2 styleName:JDStatusBarStyleDark];
        return;
    }
    
    index = 0;
    _agentChooseView = [[FZChooseAgentView alloc] initWithFrame:self.window.bounds];
    [_agentChooseView.agentModel setValuesForKeysWithDictionary:[_agentArray firstObject]];
    [_agentChooseView.agentView fillDataWithModel:_agentChooseView.agentModel];
    [_agentChooseView.nextButton addTarget:self action:@selector(changeAgent) forControlEvents:UIControlEventTouchUpInside];
    [self.window addSubview:_agentChooseView];
    
    [_agentChooseView.agentView.chooseButton addTarget:self
                                                action:@selector(chooseButtonClicked)
                                      forControlEvents:UIControlEventTouchUpInside];
}

- (void)changeAgent
{
    _agentChooseView.agentView.alpha = 0;
    [UIView animateWithDuration:0.4 animations:^{
        _agentChooseView.agentView.alpha = 1;
    }];
    
    //////////////////////////////////
    
    if (++index == _agentArray.count) {
        index = 0;
    }
    [_agentChooseView.agentModel setValuesForKeysWithDictionary:[_agentArray objectAtIndex:index]];
    [_agentChooseView.agentView fillDataWithModel:_agentChooseView.agentModel];
}

- (void)chooseButtonClicked
{
    [[FZRequestManager manager] chooseAdvicerWithID:_agentChooseView.agentModel.advicer_id jiaoyiID:_currenCell.orderID complete:^(BOOL success) {
        if (success) {
            [JDStatusBarNotification showWithStatus:@"顾问选择成功, 请到\"进行的订单\"中查看" dismissAfter:3];
            [_agentChooseView removeFromSuperview];
            [self.tableView headerBeginRefreshing];
        }
        else {
            [JDStatusBarNotification showWithStatus:@"顾问选择失败" dismissAfter:2 styleName:JDStatusBarStyleError];
        }
    }];
}

#pragma mark - 取消订单 -

- (void)cancelOrder:(UIButton *)sender
{
    FZReleaseOrderCell *cell = (FZReleaseOrderCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    _currenCell = cell;
    
    [[FZRequestManager manager] cancelOrderWithID:_currenCell.orderID complete:^(BOOL success) {
        if (success) {
            [JDStatusBarNotification showWithStatus:@"该单已被取消，请到\"订单回收站\"中查看" dismissAfter:3];
            [self.tableView headerBeginRefreshing];
        }
        else {
            [JDStatusBarNotification showWithStatus:@"取消订单失败" dismissAfter:2 styleName:JDStatusBarStyleError];
        }
    }];
}

- (void)commentButtonClicked:(UIButton *)sender
{
    [_delegate gotoCompleteService:(FZServingOrderCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]]];
}

@end
