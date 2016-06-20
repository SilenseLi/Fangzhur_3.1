//
//  FZHouseBaseInfoCell.h
//  Fangzhur
//
//  Created by --超-- on 14/11/28.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZHouseDetailModel.h"

@interface FZHouseBaseInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

- (void)configureCellWithModel:(FZHouseDetailModel *)detailModel;

@end
