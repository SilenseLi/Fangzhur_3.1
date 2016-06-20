//
//  UIButton+ZCCustomButtons.h
//  Fangzhur
//
//  Created by --Chao-- on 14-6-24.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ZCCustomButtons)
/**
 *  自定义Button
 *  @param frame     尺寸
 *  @param title     标题
 *  @param imageName logo名字
 *  @param bgName    背景图片名称
 *
 *  @return Button实例
 */
+ (UIButton *)buttonWithFrame:(CGRect)frame
                        title:(NSString *)title
                    imageName:(NSString *)imageName
                  bgImageName:(NSString *)bgName;

/**
 *  自定义Button
 *  @param frame  尺寸
 *  @param title  标题
 *  @param bgName 背景图片名称
 *
 *  @return Button实例
 */
+ (UIButton *)buttonWithFrame:(CGRect)frame
                        title:(NSString *)title
                     fontSize:(CGFloat)fontSize
                  bgImageName:(NSString *)bgName;

+ (UIButton *)buttonWithFrame:(CGRect)frame
                      bgImage:(UIImage *)image;

/** 首页底部 Button */
+ (UIButton *)homeBottomButtonWithTag:(NSInteger)tag title:(NSString *)title imageName:(NSString *)imageName;

@end
