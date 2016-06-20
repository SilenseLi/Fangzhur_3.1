//
//  UITextField+CustomTextField.h
//  AgentAPP
//
//  Created by L Suk on 14-4-28.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (CustomTextField)

/**
 * @brief 根据传入的尺寸，输入提示，以及左视图初始化text field
 */
+ (id)textFieldWithFrame:(CGRect)frame placeholder:(NSString *)aString iconView:(UIImageView *)leftView;
+ (id)textFieldWithFrame:(CGRect)frame placeholder:(NSString *)aString;

@end
