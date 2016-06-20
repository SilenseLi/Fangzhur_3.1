//
//  FZCompleteOrderCell.m
//  Fangzhur
//
//  Created by --Chao-- on 14-7-4.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZCompleteOrderCell.h"

@implementation FZCompleteOrderCell

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
    _orderNumLabel.text     = model.jiaoy_no;
//    NSArray *serviceTypes   = @[@"房屋租赁服务", @"全款过户服务", @"公积金贷款服务",
//                                @"商业贷款服务", @"组合贷款服务", @"贷款服务", @"过户+贷款服务"];
    _orderTypeLabel.text    = model.service_type;
    _orderPriceLabel.text   = [NSString stringWithFormat:@"%@元", model.service_price];
    _orderDetailLabel.text  = [NSString stringWithFormat:@"%@%@",model.quyu, model.qu_name];
    _dealPriceLabel.text    = model.cjjg;
    _orderTimeLabel.text    = model.service_time;
    if (model.order_state.intValue == 5) {
        _orderStateLabel.text = @"永久删除";
    }
    else {
        (model.method_payment.intValue == 1) ? (_orderStateLabel.text = @"线上交易") : (_orderStateLabel.text = @"线下交易");
    }
    
    if (model.order_state.intValue == 10) {
        CGRect frame       = _bgImageView.frame;
        frame.size.height  = 212;
        _bgImageView.frame = frame;
        
        _agentLabel.hidden        = YES;
        _completeTimeLabel.hidden = YES;
        _agentTitleLabel.hidden   = YES;
        _timeTitleLabel.hidden    = YES;
        return;
    }
    
    _agentLabel.hidden        = NO;
    _completeTimeLabel.hidden = NO;
    _agentTitleLabel.hidden   = NO;
    _timeTitleLabel.hidden    = NO;
    
    _agentLabel.text        = [NSString stringWithFormat:@"%@ %@", model.adviser_realname, model.adviser_phone];
    _completeTimeLabel.text = model.finish_time;
    
}

@end
