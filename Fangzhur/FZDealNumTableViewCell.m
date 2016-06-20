//
//  FZDealNumTableViewCell.m
//  Fangzhur
//
//  Created by fq on 14/12/25.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZDealNumTableViewCell.h"

@implementation FZDealNumTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)configureCellWithPaymentModel:(FZPaymentModel *)paymentModel
{
    NSInteger rentCounter = [paymentModel.secondCacheArray[2] integerValue] + 1;
    
    self.numberLabel.text = paymentModel.firstCacheArray[0];
    self.adressLabel.text = paymentModel.firstCacheArray[1];
    self.nameLabel.text = paymentModel.thirdCacheArray[1];
    self.housemoneyLabel.text = [NSString stringWithFormat:@"%@元", paymentModel.secondCacheArray[0]];
    self.waterLabel.text = [NSString stringWithFormat:@"%ld元", [paymentModel.secondCacheArray[3] integerValue]];
    self.yajinLabel.text = [NSString stringWithFormat:@"%ld元", [paymentModel.secondCacheArray[1] integerValue]];
    self.bankLabel.text = paymentModel.thirdCacheArray[3];
    self.countLabel.text = paymentModel.thirdCacheArray[2];
    self.timeLabel.text = [NSString stringWithFormat:@"%d个月", (int)rentCounter];
    self.shouxufeiLabel.text = [NSString stringWithFormat:@"%ld元", paymentModel.commission];
    self.priceLabel.text = [NSString stringWithFormat:@"%ld元", paymentModel.totalPrice + paymentModel.commission];
    [paymentModel.forthCacheArray replaceObjectAtIndex:0 withObject:self.priceLabel.text];
}

@end
