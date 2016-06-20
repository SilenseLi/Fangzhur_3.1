//
//  UIButton+ZCCustomButtons.m
//  Fangzhur
//
//  Created by --Chao-- on 14-6-24.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "UIButton+ZCCustomButtons.h"

@implementation UIButton (ZCCustomButtons)

+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title imageName:(NSString *)imageName bgImageName:(NSString *)bgName
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame     = frame;
    [button setBackgroundImage:[UIImage imageNamed:bgName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:kFontName size:17];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    if (button.imageView.image) {
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    }
    
    return button;
}

+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title fontSize:(CGFloat)fontSize bgImageName:(NSString *)bgName
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame     = frame;
    [button setBackgroundImage:[UIImage imageNamed:bgName] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:kFontName size:fontSize];
    
    return button;
}

+ (UIButton *)buttonWithFrame:(CGRect)frame bgImage:(UIImage *)image
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame     = frame;
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    return button;
}

+ (UIButton *)homeBottomButtonWithTag:(NSInteger)tag title:(NSString *)title imageName:(NSString *)imageName
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, tag * (191 + kAdjustScale), SCREEN_WIDTH, 190 + kAdjustScale);
    button.tag = tag;
    [button setBackgroundColor:RGBColor(217, 217, 217)];
    button.imageEdgeInsets = UIEdgeInsetsMake(-50, 0, 0, 0);
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_h", imageName]] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMidY(button.bounds)+20, SCREEN_WIDTH, 21)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    titleLabel.font = [UIFont fontWithName:kFontName size:19];
    [button addSubview:titleLabel];

    return button;
}

@end
