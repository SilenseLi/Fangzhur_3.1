//
//  FZHouseDescriptionCell.m
//  Fangzhur
//
//  Created by --超-- on 14/11/22.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZHouseDescriptionCell.h"

@implementation FZHouseDescriptionCell

- (void)awakeFromNib
{
    self.BottomLine.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithModel:(FZHouseDetailModel *)detailModel
{
    CGSize labelSize = [detailModel.house_desc sizeWithFont:[UIFont fontWithName:kFontName size:15] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, 999) lineBreakMode:NSLineBreakByWordWrapping];
    self.descriptionLabel.frame = CGRectMake(15, 46, labelSize.width, labelSize.height);
    self.descriptionLabel.text = detailModel.house_desc;
    self.floorLabel.text = [NSString stringWithFormat:@"层   高：%@ / %@", detailModel.house_floor, detailModel.house_topfloor];
    self.squareLabel.text = [NSString stringWithFormat:@"面   积：%@平米", detailModel.house_totalarea];
    self.peopleLabel.text = [NSString stringWithFormat:@"人   数：%@人", @"1"];
    self.directionLabel.text = [NSString stringWithFormat:@"方   向：%@", detailModel.house_toward];
}


@end
