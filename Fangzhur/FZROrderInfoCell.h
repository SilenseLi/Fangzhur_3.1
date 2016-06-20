//
//  FZROrderInfoCell.h
//  SelfBusiness
//
//  Created by --Chao-- on 14-6-12.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZROrderReleasedInfoModel.h"

@interface FZROrderInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *serviceTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *servicePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *communityLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

- (void)fillDataWithModel:(FZROrderReleasedInfoModel *)model;

@end
