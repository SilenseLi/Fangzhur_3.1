//
//  FZScreenSingleSliderCell.m
//  Fangzhur
//
//  Created by --超-- on 14/11/9.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZScreenSingleSliderCell.h"
#import <NMRangeSlider.h>

@interface FZScreenSingleSliderCell ()

//单向滑块
@property (nonatomic, strong) NMRangeSlider *singleSlider;
@property (nonatomic, strong) UILabel *singleLabel;

- (void)configureSingleSlider;
- (void)updateSingleSlider;

@end

@implementation FZScreenSingleSliderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self configureSingleSlider];
        [self updateSingleSlider];
    }
    
    return self;
}

- (void)configureSingleSlider
{
    self.singleSlider = [[NMRangeSlider alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, CGRectGetHeight(self.bounds))];
    [self.singleSlider addTarget:self action:@selector(SliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    UIImage* image = nil;
    image = [UIImage imageNamed:@"slider_btn"];
    self.singleSlider.lowerHandleImageNormal = image;
    self.singleSlider.lowerHandleImageHighlighted = image;
    
    image = [UIImage imageNamed:@"zhuangtaitiao_b"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)];
    self.singleSlider.trackBackgroundImage = image;
    
    image = [UIImage imageNamed:@"zhuangtaitiao_h"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)];
    self.singleSlider.trackImage = image;
    
    self.singleSlider.minimumValue = 10.0;
    self.singleSlider.maximumValue = 200.0;
    self.singleSlider.lowerValue = 10.0;
    self.singleSlider.upperValue = 200.0;
    self.singleSlider.stepValue = 10.0;
    self.singleSlider.upperHandleHidden = YES;
    
    self.singleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 21)];
    self.singleLabel.backgroundColor = [UIColor clearColor];
    self.singleLabel.font = [UIFont fontWithName:kFontName size:12];
    self.singleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)addSingleSlider
{
    for (UIView *subview in self.contentView.subviews) {
        [subview removeFromSuperview];
    }
    
    [self.contentView addSubview:self.singleSlider];
    [self.contentView addSubview:self.singleLabel];
}

#pragma mark - 响应事件 -

- (void)updateSingleSlider
{
    CGPoint lowerCenter;
    lowerCenter.x = (self.singleSlider.lowerCenter.x + self.singleSlider.frame.origin.x);
    lowerCenter.y = (self.singleSlider.center.y - 30.0f);
    
    if (self.singleSlider.lowerValue == 1) {
        lowerCenter.x = 35;
        [self.singleSlider setLowerValue:10 animated:NO];
    }
    
    self.singleLabel.center = lowerCenter;
    self.singleLabel.text = [NSString stringWithFormat:@"%dm²", (int)self.singleSlider.lowerValue];
}

- (void)SliderValueChanged:(NMRangeSlider *)sender
{
    [self updateSingleSlider];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
