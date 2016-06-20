//
//  FZCompleteOrderCell.h
//  Fangzhur
//
//  Created by --Chao-- on 14-7-4.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZOrdersModel.h"

//完成的订单 、订单回收站
@interface FZCompleteOrderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *dealPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *agentLabel;
@property (weak, nonatomic) IBOutlet UILabel *completeTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *agentTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeTitleLabel;

- (void)fillDataWithModel:(FZOrdersModel *)model;

@end
