//
//  FZScreenDateCell.m
//  Fangzhur
//
//  Created by --超-- on 14/11/10.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZScreenDateCell.h"
#import "UIButton+ZCCustomButtons.h"

@interface FZScreenDateCell ()

@end

@implementation FZScreenDateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 70)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 5;
        bgView.clipsToBounds = YES;
        [self.contentView addSubview:bgView];
        
        self.dateButton = [UIButton buttonWithFrame:bgView.bounds title:@"现在" fontSize:17 bgImageName:nil];
        [bgView addSubview:self.dateButton];
        self.dateButton.backgroundColor = [UIColor clearColor];
        [self.dateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    return self;
}

- (void)setCellDate:(NSString *)cellDate
{
    _cellDate = cellDate;
    [self.dateButton setTitle:cellDate forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
