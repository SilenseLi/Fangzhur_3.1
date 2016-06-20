//
//  FZScreenSliderCell.m
//  Fangzhur
//
//  Created by --超-- on 14/11/9.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZScreenRangeSliderCell.h"
#import <NMRangeSlider.h>

@interface FZScreenRangeSliderCell ()

//双向滑块
@property (nonatomic, strong) NMRangeSlider *rangeSlider;
@property (nonatomic, strong) UILabel *upperLabel;
@property (nonatomic, strong) UILabel *lowerLabel;

- (void)configureRangeSlider;
- (void)updateRangeSlider;

@end

@implementation FZScreenRangeSliderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self configureRangeSlider];
    }
    
    return self;
}

- (void)configureRangeSlider
{
    self.rangeSlider = [[NMRangeSlider alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, CGRectGetHeight(self.bounds))];
    [self.rangeSlider addTarget:self action:@selector(SliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    UIImage *image = [UIImage imageNamed:@"slider_btn"];
    self.rangeSlider.lowerHandleImageNormal = image;
    self.rangeSlider.upperHandleImageNormal = image;
    self.rangeSlider.lowerHandleImageHighlighted = image;
    self.rangeSlider.upperHandleImageHighlighted = image;
    
    image = [UIImage imageNamed:@"zhuangtaitiao_b"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)];
    self.rangeSlider.trackBackgroundImage = image;
    
    image = [UIImage imageNamed:@"zhuangtaitiao_h"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)];
    self.rangeSlider.trackImage = image;
    
    self.lowerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 21)];
    self.lowerLabel.backgroundColor = [UIColor clearColor];
    self.lowerLabel.font = [UIFont fontWithName:kFontName size:12];
    self.lowerLabel.textAlignment = NSTextAlignmentCenter;
    
    self.upperLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 21)];
    self.upperLabel.backgroundColor = [UIColor clearColor];
    self.upperLabel.font = [UIFont fontWithName:kFontName size:12];
    self.upperLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:self.rangeSlider];
    [self.contentView addSubview:self.lowerLabel];
    [self.contentView addSubview:self.upperLabel];
}

- (void)addRangeSliderWithMinimumValue:(CGFloat)minimumValue maximumValue:(CGFloat)maximumValue stepValue:(CGFloat)stepValue
{
    self.rangeSlider.minimumValue = minimumValue;
    self.rangeSlider.maximumValue = maximumValue;
    self.rangeSlider.stepValue = stepValue;
    
    NSArray *valueArray = [[self.cacheArray objectAtIndex:self.tag] componentsSeparatedByString:@","];
    [self.rangeSlider setLowerValue:[valueArray.firstObject integerValue]
                         upperValue:[valueArray.lastObject integerValue]
                           animated:NO];
    
    [self updateRangeSlider];
}

- (void)hideTheRightSlider
{
    self.rangeSlider.upperHandleHidden = YES;
    self.upperLabel.hidden = YES;
}

#pragma mark - 响应事件 -

- (void)updateRangeSlider
{
    CGPoint lowerCenter;
    lowerCenter.x = (self.rangeSlider.lowerCenter.x + self.rangeSlider.frame.origin.x);
    lowerCenter.y = (self.rangeSlider.center.y - 30.0f);

    if (lowerCenter.x == 15) {
        lowerCenter.x = 35;
    }
    self.lowerLabel.center = lowerCenter;
    self.lowerLabel.text = [NSString stringWithFormat:@"%d", (int)self.rangeSlider.lowerValue];
    
    CGPoint upperCenter;
    upperCenter.x = (self.rangeSlider.upperCenter.x + self.rangeSlider.frame.origin.x);
    upperCenter.y = (self.rangeSlider.center.y - 30.0f);
    if (upperCenter.x == 15) {
        upperCenter.x = SCREEN_WIDTH - 35;
    }
    self.upperLabel.center = upperCenter;
    self.upperLabel.text = [NSString stringWithFormat:@"%d", (int)self.rangeSlider.upperValue];
    
    //TODO:特殊值设定
    CGFloat maximumValue = self.rangeSlider.maximumValue;
    if (maximumValue < 10000) {
        if (self.rangeSlider.upperValue >= maximumValue && self.rangeSlider.lowerValue >= maximumValue) {
            self.upperLabel.text = [NSString stringWithFormat:@"%d+", (NSInteger)self.rangeSlider.upperValue];
            self.lowerLabel.text = self.upperLabel.text;
        }
    }
    else {
        if (self.rangeSlider.upperValue >= maximumValue && self.rangeSlider.lowerValue >= maximumValue) {
            self.upperLabel.text = [NSString stringWithFormat:@"%dW+", (NSInteger)self.rangeSlider.upperValue / 10000];
            self.lowerLabel.text = self.upperLabel.text;
        }
        else {
            if (self.rangeSlider.upperValue >= 10000) {
                self.upperLabel.text = [NSString stringWithFormat:@"%dW", (NSInteger)self.rangeSlider.upperValue / 10000];
            }
            if (self.rangeSlider.lowerValue >= 10000) {
                self.lowerLabel.text = [NSString stringWithFormat:@"%dW", (NSInteger)self.rangeSlider.lowerValue / 10000];
            }
        } 
    }
}


- (void)SliderValueChanged:(NMRangeSlider *)sender
{
    [self updateRangeSlider];
    [self.cacheArray replaceObjectAtIndex:self.tag
                               withObject:[NSString stringWithFormat:@"%d,%d",
                                           (int)sender.lowerValue, (int)sender.upperValue]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
