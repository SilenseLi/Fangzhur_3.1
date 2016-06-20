//
//  FZRServiceProcedureCell.m
//  SelfBusiness
//
//  Created by --Chao-- on 14-6-9.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZRProcedureCell.h"

@implementation FZRProcedureCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillDataWithTitle:(NSString *)title position:(Position)pos
{
    if (pos == POSLeft) {
        _leftImageView.hidden  = NO;
        _leftLabel.hidden      = NO;
        _rightImageView.hidden = YES;
        _rightLabel.hidden     = YES;
        _leftLabel.text        = title;
        
    }
    else {
        _leftImageView.hidden  = YES;
        _leftLabel.hidden      = YES;
        _rightImageView.hidden = NO;
        _rightLabel.hidden     = NO;
        _rightLabel.text       = title;

    }
}

@end
