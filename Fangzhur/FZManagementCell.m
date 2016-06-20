//
//  FZManagementCell.m
//  Fangzhur
//
//  Created by --超-- on 14-7-21.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZManagementCell.h"

@implementation FZManagementCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)bottomButtonClicked:(UIButton *)sender {
    if (sender.tag == 0) {//重新发布
        [_delegate releaseAgain:_infoModel.houseID];
    }
    else {
        [_delegate manageReleasedHouse:_infoModel.houseID selectedIndex:sender.tag];
    }
}

- (void)fillDataWithType:(NSString *)type Model:(FZHouseDetailModel *)model
{
    if ([type isEqualToString:@"1"]) {
        _houseTypeLabel.text = @"出租房源";
    }
    else {
        _houseTypeLabel.text = @"出售房源";
    }
    
    _infoModel               = model;
    _houseNumLabel.text      = model.house_no;
    _communityNameLabel.text = model.borough_name;
    _priceLabel.text         = model.house_price;
    
    dateExchange(model.updated.doubleValue, _releaseDateLabel.text);
}

@end
