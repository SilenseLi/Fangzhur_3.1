//
//  FZPayPeopleTableViewCell.m
//  Fangzhur
//
//  Created by fq on 14/12/26.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZPayPeopleTableViewCell.h"

@interface FZPayPeopleTableViewCell ()

@property (nonatomic, strong) NSMutableArray *bankIDArray;
@property (nonatomic, strong) NSMutableArray *bankNameArray;

@end

@implementation FZPayPeopleTableViewCell

- (void)awakeFromNib
{
    self.bankIDArray = [[NSMutableArray alloc] init];
    self.bankNameArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *bankInfoDict in [[EGOCache globalCache] plistForKey:@"Banklist"]) {
        [self.bankIDArray addObject:[bankInfoDict objectForKey:@"id"]];
        [self.bankNameArray addObject:[bankInfoDict objectForKey:@"name"]];
    }
}

- (void)drawRect:(CGRect)rect
{
    self.bgImageView.image = [self.bgImageView.image stretchableImageWithLeftCapWidth:5 topCapHeight:15];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configerCellWithModel:(FZPayBoltingModel *)model
{
    dateExchange(model.created_on.integerValue, self.downOrderLabel.text)
    self.OwnernameLabel.text=model.bank_membername;
    self.bankCardLbael.text=model.bank_card_no;
    NSString * startDate=nil;
    NSString * endDate=nil;
    dateExchange(model.rent_starttime.integerValue, startDate);
    dateExchange(model.rent_starttime.integerValue + model.pay_month_num.integerValue *3600*24*30 , endDate);
    self.payTimeLbael.text=[NSString  stringWithFormat:@"%@ 至 %@",startDate,endDate];
    self.banNmaLabel.text = self.bankNameArray[[self.bankIDArray indexOfObject:model.bank_id]];
}

@end
