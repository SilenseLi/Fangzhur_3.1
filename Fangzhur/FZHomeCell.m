//
//  FZHomeCell.m
//  Fangzhur
//
//  Created by --超-- on 14/11/2.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZHomeCell.h"

@implementation FZHomeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellAtRow:(NSInteger)row
{
//    self.titleImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"HomeCell%d", row]];
    self.bgImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Home%d.jpg", row]];
}

@end
