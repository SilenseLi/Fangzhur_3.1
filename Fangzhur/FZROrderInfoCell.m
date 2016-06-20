//
//  FZROrderInfoCell.m
//  SelfBusiness
//
//  Created by --Chao-- on 14-6-12.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZROrderInfoCell.h"


@implementation FZROrderInfoCell

- (void)awakeFromNib
{
    _containerView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _containerView.layer.borderWidth = 0.5f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillDataWithModel:(FZROrderReleasedInfoModel *)model
{
    NSDictionary *serviceTypeDict = [[ZCReadFileMethods dataFromPlist:@"SelfHelperData" ofType:Dictionary]
                                     objectForKey:@"ServiceType"];
    
    self.serviceTypeLabel.text = [serviceTypeDict objectForKey:model.service_type];
    self.servicePriceLabel.text = model.service_price;
    self.areaLabel.text         = model.cityarea_name;
    self.communityLabel.text    = model.qu_name;
    self.priceLabel.text        = model.cjjg;
    
    if (model.service_type.intValue == 1) {
        self.unitLabel.text = @"元/月";
    }
    else {
        self.unitLabel.text = @"万元";
    }
}

@end
