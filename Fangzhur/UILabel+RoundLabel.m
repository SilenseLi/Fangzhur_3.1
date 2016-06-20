//
//  UILabel+RoundLabel.m
//  SelfBusiness
//
//  Created by --Chao-- on 14-6-9.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "UILabel+RoundLabel.h"

@implementation UILabel (RoundLabel)

+ (UILabel *)roundLabelWithFrame:(CGRect)frame Title:(NSString *)title fontSize:(CGFloat)size
{
    UILabel *roundLabel = [[UILabel alloc] initWithFrame:frame];
    roundLabel.backgroundColor = [UIColor whiteColor];
    roundLabel.font = [UIFont systemFontOfSize:size];
    roundLabel.textColor = [UIColor blackColor];
    roundLabel.textAlignment = NSTextAlignmentCenter;
    NSRange separatorRange = [title rangeOfString:@"|"];
    if (separatorRange.length != 0) {
        roundLabel.text = [title substringToIndex:separatorRange.location];
    }
    else {
        roundLabel.text = title;
    }
    
    roundLabel.layer.masksToBounds = YES;
    roundLabel.layer.cornerRadius = 35;
    roundLabel.layer.borderWidth = 1.5;
    roundLabel.layer.borderColor = [roundLabel.textColor CGColor];
    
    return roundLabel;
}

@end
