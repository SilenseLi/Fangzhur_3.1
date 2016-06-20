//
//  UITextField+ZCCustomField.m
//  Fangzhur
//
//  Created by --Chao-- on 14-6-24.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "UITextField+ZCCustomField.h"

@implementation UITextField (ZCCustomField)

+ (UITextField *)textFieldWithFrame:(CGRect)frame imageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName placeholder:(NSString *)aString superView:(UIView *)superView
{
    UIImageView *bgImageView            = [[UIImageView alloc] initWithFrame:frame];
    bgImageView.userInteractionEnabled  = YES;
    bgImageView.image                   = [UIImage imageNamed:@"pic_shur.png"];
    
    //|||||||||||||||||||||||||||||||||||||||
    
    UITextField *textField              = [[UITextField alloc] initWithFrame:
                                           CGRectMake(5, 0, frame.size.width - 5, frame.size.height)];
    textField.placeholder               = [NSString stringWithFormat:@" %@", aString];
    textField.leftViewMode              = UITextFieldViewModeAlways;
    textField.leftView                  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]
                                                            highlightedImage:[UIImage imageNamed:highlightedImageName]];
    textField.clearButtonMode           = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment  = UIControlContentVerticalAlignmentCenter;
    
    [superView addSubview:bgImageView];
    [bgImageView addSubview:textField];
    
    return textField;
}

+ (UITextField *)textFieldWithFrame:(CGRect)frame imageName:(NSString *)imageName placeholder:(NSString *)aString superView:(UIView *)superView
{
    return [self textFieldWithFrame:frame imageName:imageName highlightedImageName:nil placeholder:aString superView:superView];
}

+ (UITextField *)textFieldWithFrame:(CGRect)frame placeholder:(NSString *)aString superView:(UIView *)superView
{
    UIImageView *bgImageView            = [[UIImageView alloc] initWithFrame:frame];
    bgImageView.userInteractionEnabled  = YES;
    bgImageView.image                   = [UIImage imageNamed:@"pic_shur.png"];
    
    //|||||||||||||||||||||||||||||||||||||||
    
    UITextField *textField              = [[UITextField alloc] initWithFrame:
                                           CGRectMake(5, 0, frame.size.width - 5, frame.size.height)];
    textField.placeholder               = [NSString stringWithFormat:@" %@", aString];
    textField.clearButtonMode           = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment  = UIControlContentVerticalAlignmentCenter;
    
    [superView addSubview:bgImageView];
    [bgImageView addSubview:textField];
    
    return textField;
}

@end
