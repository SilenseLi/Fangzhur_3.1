//
//  FZRPaymentCell.m
//  SelfBusiness
//
//  Created by --Chao-- on 14-6-12.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZRPaymentCell.h"

@implementation FZRPaymentCell

- (void)awakeFromNib
{
    _containerView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _containerView.layer.borderWidth = 0.5f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
