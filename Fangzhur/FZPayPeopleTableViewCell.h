//
//  FZPayPeopleTableViewCell.h
//  Fangzhur
//
//  Created by fq on 14/12/26.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZPayBoltingModel.h"
@interface FZPayPeopleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *downOrderLabel;
@property (weak, nonatomic) IBOutlet UILabel *OwnernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *payTimeLbael;
@property (weak, nonatomic) IBOutlet UILabel *bankCardLbael;
@property (weak, nonatomic) IBOutlet UILabel *banNmaLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;



- (void)configerCellWithModel:(FZPayBoltingModel *)model;
@end
