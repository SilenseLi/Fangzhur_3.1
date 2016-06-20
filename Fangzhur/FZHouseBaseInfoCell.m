//
//  FZHouseBaseInfoCell.m
//  Fangzhur
//
//  Created by --超-- on 14/11/28.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZHouseBaseInfoCell.h"
#import "AdjustLineSpacing.h"

#define DynamicLabelSizeOf(string)\
[string sizeWithFont:[UIFont fontWithName:kFontName size:15] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, 999) lineBreakMode:NSLineBreakByWordWrapping]

@implementation FZHouseBaseInfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithModel:(FZHouseDetailModel *)detailModel
{
    self.infoLabel.text = detailModel.baseInfo;
    self.infoLabel.backgroundColor = [UIColor clearColor];
    self.infoLabel.attributedText = [AdjustLineSpacing adjustString:self.infoLabel.text withLineSpacing:10];
    
    CGRect frame = self.infoLabel.frame;
    frame.size.height = DynamicLabelSizeOf(self.infoLabel.text).height * 2;
    self.infoLabel.frame = frame;
    
    [self.infoLabel sizeToFit];
}

@end
