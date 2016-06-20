//
//  FZAllOrdersCell.h
//  Fangzhur
//
//  Created by --Chao-- on 14-7-4.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZOrdersModel.h"

//全部订单
@interface FZServingOrderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *informButton;
@property (weak, nonatomic) IBOutlet UILabel *orderTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *dealPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *agentLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *seperatedLine;
@property (nonatomic, retain) FZOrdersModel *orderModel;

//用于进行举报
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;

- (void)fillDataWithModel:(FZOrdersModel *)model;
- (void)addTarget:(id)target action:(SEL)action;


@end
