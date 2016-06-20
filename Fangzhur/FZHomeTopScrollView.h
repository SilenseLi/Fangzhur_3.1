//
//  FZHomeTopScrollView.h
//  Fangzhur
//
//  Created by --超-- on 14/11/2.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSTimer+Addition.h"

@interface FZHomeTopScrollView : UIView <UIScrollViewDelegate>

@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, strong) NSTimer *animationTimer;

/** 
 * @brief 初始化方法
 * @param interval 滚动的时间间, 必须大于0
 */
- (instancetype)initWithFrame:(CGRect)frame duration:(NSTimeInterval)interval;

/** 获取page总数 */
@property (nonatomic, copy) NSInteger (^totalPageCount)(void);

/** 获取pageIndex下的视图 */
@property (nonatomic, copy) UIView* (^contentViewAtIndex)(NSInteger pageIndex);

/** 点击指定视图触发事件 */
@property (nonatomic, copy) void (^tapActionBlock)(NSInteger pageIndex);

- (void)hidePageControl;

@end
