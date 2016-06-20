//
//  FZButtonCell.m
//  Fangzhur
//
//  Created by --超-- on 14/11/30.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZLabelCell.h"

@implementation FZLabelCell

- (void)awakeFromNib
{
}

- (void)drawRect:(CGRect)rect
{
    self.titleLabel.layer.cornerRadius = 5;
    self.titleLabel.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
