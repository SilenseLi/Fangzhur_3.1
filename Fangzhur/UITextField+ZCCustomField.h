//
//  UITextField+ZCCustomField.h
//  Fangzhur
//
//  Created by --Chao-- on 14-6-24.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (ZCCustomField)

/**
 *  自定义 TextField
 *  @param frame                尺寸
 *  @param imageName            左侧图标名称
 *  @param highlightedImageName 高亮图片名称
 *  @param aString              提示输入信息
 *  @param superView            父视图
 */
+ (UITextField *)textFieldWithFrame:(CGRect)frame imageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName placeholder:(NSString *)aString superView:(UIView *)superView;
/**
 *  自定义 TextField
 *  @param frame                尺寸
 *  @param imageName            左侧图标名称
 *  @param aString              提示输入信息
 *  @param superView            父视图
 */
+ (UITextField *)textFieldWithFrame:(CGRect)frame imageName:(NSString *)imageName placeholder:(NSString *)aString superView:(UIView *)superView;

+ (UITextField *)textFieldWithFrame:(CGRect)frame placeholder:(NSString *)aString superView:(UIView *)superView;

@end
