//
//  FZDealNumTableViewCell.h
//  Fangzhur
//
//  Created by fq on 14/12/25.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZPaymentModel.h"

@interface FZDealNumTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *adressLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *housemoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *waterLabel;
@property (weak, nonatomic) IBOutlet UILabel *yajinLabel;
@property (weak, nonatomic) IBOutlet UILabel *shouxufeiLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

- (void)configureCellWithPaymentModel:(FZPaymentModel *)paymentModel;

@end
