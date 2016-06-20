//
//  FZScrolledNavigationBarController.h
//  Fangzhur
//
//  Created by --超-- on 14/10/22.
//  Copyright (c) 2014年 Zc. All rights reserved.
//
//  导航栏可以随手势隐藏

#import <UIKit/UIKit.h>
#import "FZNavigationController.h"

typedef enum {
    POSLeft = 0,
    POSRight
} FZButtonPosition;

typedef void(^FinishedRolling)(BOOL isRollingUp);


@interface FZScrolledNavigationBarController : UIViewController
<UIGestureRecognizerDelegate>

@property (nonatomic, copy) FinishedRolling rollingBlock;

/** 跟随滚动视图进行展示和隐藏导航栏 */
- (void)rollingBarWithScrollView:(UIScrollView *)scrollView finished:(FinishedRolling)block;
- (void)showNavigationBar;

/**
 *  @brief 为导航栏添加按钮
 *  @param image  按钮图片
 *  @param pos    按钮位置
 */
- (void)addButtonWithImage:(UIImage *)image target:(id)target action:(SEL)action position:(FZButtonPosition)pos;

/** 高亮图名称在其后设置 tag 即可，tag的设置根据项目标准在类内部进行 ,按钮有偏离 */
- (UIButton *)addButtonWithImageName:(NSString *)imageName target:(id)target action:(SEL)action position:(FZButtonPosition)pos;

/**
 *  添加一组导航栏按钮，位于右侧
 *  @param names  图片名称，从右往左
 */
- (void)addButtonsWithImageNames:(NSArray *)names target:(id)target action:(SEL)action position:(FZButtonPosition)pos;

- (void)addBackgroundView;


@end
