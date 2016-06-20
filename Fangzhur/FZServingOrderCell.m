//
//  FZAllOrdersCell.m
//  Fangzhur
//
//  Created by --Chao-- on 14-7-4.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZServingOrderCell.h"

@implementation FZServingOrderCell

- (id)copy
{
    return self;
}


- (void)awakeFromNib
{
    [_informButton addTarget:self action:@selector(informButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)addTarget:(id)target action:(SEL)action
{
    _target = target;
    _action = action;
}

- (void)fillDataWithModel:(FZOrdersModel *)model
{
    _orderModel            = model;
    _orderNumLabel.text    = model.jiaoy_no;
//    NSArray *serviceTypes  = @[@"房屋租赁服务", @"全款过户服务", @"公积金贷款服务",
//                               @"商业贷款服务", @"组合贷款服务", @"贷款服务", @"过户+贷款服务"];
    _orderTypeLabel.text   = model.service_type;
    if (model.informFlag.intValue == 1) {
        _informButton.enabled = NO;
    }
    _orderPriceLabel.text  = [NSString stringWithFormat:@"%@元", model.service_price];
    _orderDetailLabel.text = [NSString stringWithFormat:@"%@%@",model.quyu, model.qu_name];
    _dealPriceLabel.text   = [NSString stringWithFormat:@"%@元", model.cjjg];
    _orderTimeLabel.text   = model.service_time;
    (model.method_payment.intValue == 1) ?
    (_orderStateLabel.text = @"线上交易") : (_orderStateLabel.text = @"线下交易");
    _agentLabel.text       = [NSString stringWithFormat:@"%@ %@", model.adviser_realname, model.adviser_phone];
}

- (void)informButtonClicked
{
    if ([_target respondsToSelector:_action]) {
        [_target performSelector:_action withObject:self];
    }
}

@end
