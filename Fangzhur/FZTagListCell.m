//
//  FZTagListCell.m
//  Fangzhur
//
//  Created by --超-- on 14/11/18.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZTagListCell.h"

@implementation FZTagListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithTagID:(NSString *)tagID tagName:(NSString *)tagName
{
    self.tagBgImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", tagID]];
}

@end
