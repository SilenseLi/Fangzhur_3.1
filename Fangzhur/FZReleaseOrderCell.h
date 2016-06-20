//
//  FZReleaseOrderCell.h
//  Fangzhur
//
//  Created by --Chao-- on 14-7-4.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZOrdersModel.h"

//发布、退款的订单
@interface FZReleaseOrderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *orderTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *dealPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStateLabel;
@property (weak, nonatomic) IBOutlet UIButton *agentButton;
@property (nonatomic, copy) NSString *orderID;

- (void)fillDataWithModel:(FZOrdersModel *)model;

@end
