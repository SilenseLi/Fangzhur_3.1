//
//  FZNavigationController.h
//  Fangzhur
//
//  Created by --超-- on 14/10/30.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZNavigationController : UINavigationController
<UIGestureRecognizerDelegate, UINavigationControllerDelegate>

/** 自定义 navigation bar 的背景浮层 */
@property (nonatomic, readonly) UIImageView *backgroundlayer;
/** 添加自定义视图 */
@property (nonatomic, strong) UIView *customView;

/** 设置导航栏的背景图片 */
- (void)setNavigationBarWithImage:(UIImage *)image;

/** 在导航栏添加Logo */
- (void)addLogoAtFrame:(CGRect)frame;

/** 添加自定义标题 */
- (void)addTitle:(NSString *)title;

@end
