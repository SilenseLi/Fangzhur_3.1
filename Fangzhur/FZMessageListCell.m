//
//  FZMessageListCell.m
//  Fangzhur
//
//  Created by --超-- on 14/12/19.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZMessageListCell.h"
#import <UIImageView+WebCache.h>

@implementation FZMessageListCell

- (void)awakeFromNib {
    
}

- (void)drawRect:(CGRect)rect
{
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    self.headerImageView.backgroundColor = [UIColor blackColor];
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = CGRectGetWidth(self.headerImageView.bounds) / 2.0f;
    
    self.badgeLabel.layer.masksToBounds = YES;
    self.badgeLabel.layer.cornerRadius = CGRectGetWidth(self.badgeLabel.bounds) / 2.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithMessageModel:(FZMessageModel *)messageModel
{
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:messageModel.avatar]
                            placeholderImage:[UIImage imageNamed:@"moren_touxiang"]];
    
    self.nameLabel.text = [messageModel stringByHidePhoneTail];
    self.contentLabel.text = messageModel.content;
    self.contentLabel.clipsToBounds = YES;
    dateExchange(messageModel.created_on.doubleValue, self.dateLabel.text);
    
    if (messageModel.cnt.integerValue == 0) {
        self.badgeLabel.hidden = YES;
    }
    else {
        self.badgeLabel.hidden = NO;
        self.badgeLabel.text = (messageModel.cnt.integerValue >= 99) ? @"99+" : messageModel.cnt;
    }
}

@end
