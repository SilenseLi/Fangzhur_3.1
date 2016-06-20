//
//  FZReleaseOrderCell.m
//  Fangzhur
//
//  Created by --Chao-- on 14-7-4.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZReleaseOrderCell.h"

@implementation FZReleaseOrderCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillDataWithModel:(FZOrdersModel *)model
{
    _orderID = model.orderID;
    
    _orderNumLabel.text    = model.jiaoy_no;
//    NSArray *serviceTypes  = @[@"房屋租赁服务", @"全款过户服务", @"公积金贷款服务",
//                               @"商业贷款服务", @"组合贷款服务", @"贷款服务", @"过户+贷款服务"];
    _orderTypeLabel.text   = model.service_type;
    _orderPriceLabel.text  = [NSString stringWithFormat:@"%@元", model.service_price];
    _orderDetailLabel.text = [NSString stringWithFormat:@"%@%@",model.quyu, model.qu_name];
    _dealPriceLabel.text   = [NSString stringWithFormat:@"%@元", model.cjjg];
    _orderTimeLabel.text   = model.service_time;
    (model.method_payment.intValue == 1) ?
    (_orderStateLabel.text = @"线上交易") : (_orderStateLabel.text = @"线下交易");
    if (model.order_state.intValue == 1) {
        _agentButton.enabled = YES;
        _cancelButton.enabled = YES;
        [_agentButton setTitle:@"选择服务顾问" forState:UIControlStateNormal];
    }
    else if (model.order_state.intValue == 21) {
        _agentButton.enabled  = NO;
        _cancelButton.enabled = NO;
        [_agentButton setTitle:@"退款中" forState:UIControlStateDisabled];
    }
    else {
        _agentButton.enabled  = NO;
        _cancelButton.enabled = NO;
        [_agentButton setTitle:@"已退款" forState:UIControlStateDisabled];
    }
}

@end
