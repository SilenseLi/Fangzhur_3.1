//
//  FZPayManagerTableViewCell.m
//  Fangzhur
//
//  Created by fq on 14/12/26.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZPayManagerTableViewCell.h"

@implementation FZPayManagerTableViewCell

- (void)awakeFromNib {
//    self.applyBtn.clipsToBounds = YES;
//    self.applyBtn.layer.cornerRadius = 2;
//    self.applyBtn.hidden=YES;
//    self.leftButton.clipsToBounds = YES;
//    self.leftButton.layer.cornerRadius = 2;
//    
//    
//    self.rightButton.clipsToBounds = YES;
//    self.rightButton.layer.cornerRadius = 2;
//    self.rightButton.layer.borderColor = kDefaultColor.CGColor;
//    self.rightButton.layer.borderWidth = 1;

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    
}




- (void)configureCellWithModel:(FZPayBoltingModel *)model
{
    dateExchange(model.created_on.integerValue, self.timeLabel.text)
    self.dayLabel.text=[NSString stringWithFormat:@"%@个月的房租", model.pay_month_num];
    self.OwnNameLabel.text=model.bank_membername;
    self.PhoneLabel.text=model.bank_card_no;
    
    self.continueBtn.tag=self.tag;
    
//    NSDictionary * dict=[[ZCReadFileMethods dataFromPlist:@"bankmanager" ofType:Dictionary]objectForKey:@"bank_name"];
//    self.bankNameLabel.text=[dict objectForKey:model.bank_name];
    
    self.bankNameLabel.text=[NSString stringWithFormat:@"(%@)",model.bank_name];

    NSString * startDate=nil;
    NSString * endDate=nil;
    dateExchange(model.rent_starttime.integerValue, startDate);
    dateExchange(model.rent_starttime.integerValue + model.pay_month_num.integerValue *3600*24*30 , endDate);
    self.payTimeLabel.text=[NSString stringWithFormat:@"日期：%@ 至 %@",startDate,endDate];
    self.MoneyLabel.text=[NSString stringWithFormat:@"%ld元", ([model.total_amount integerValue] / 100)];

}
@end
