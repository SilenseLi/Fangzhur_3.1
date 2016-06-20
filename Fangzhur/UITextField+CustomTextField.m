//
//  UITextField+CustomTextField.m
//  AgentAPP
//
//  Created by L Suk on 14-4-28.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "UITextField+CustomTextField.h"

@implementation UITextField (CustomTextField)

+ (id)textFieldWithFrame:(CGRect)frame placeholder:(NSString *)aString iconView:(UIImageView *)leftView
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.placeholder = aString;
    textField.background = [UIImage imageNamed:@"pic_shur.png"];
    textField.clearButtonMode = UITextFieldViewModeAlways;
    
    //设置左视图
    leftView.contentMode = UIViewContentModeCenter;
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    return textField;
}

+ (id)textFieldWithFrame:(CGRect)frame placeholder:(NSString *)aString
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.placeholder = aString;
    textField.background = [UIImage imageNamed:@"shuru_quan"];
    textField.clearButtonMode = UITextFieldViewModeAlways;
    
    return textField;
}

@end
