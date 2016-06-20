//
//  FZScreenRangeSliderCell.h
//  Fangzhur
//
//  Created by --超-- on 14/11/9.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZScreenRangeSliderCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *cacheArray;

- (void)addRangeSliderWithMinimumValue:(CGFloat)minimumValue maximumValue:(CGFloat)maximumValue stepValue:(CGFloat)stepValue;
- (void)hideTheRightSlider;

@end
