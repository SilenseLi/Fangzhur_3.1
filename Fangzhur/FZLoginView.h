//
//  FZLoginView.h
//  Fangzhur
//
//  Created by --超-- on 14/11/2.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FZLoginViewDelegate;

typedef NS_ENUM(NSInteger, FZLoginMode) {
    FZLoginModeDefault, //免注册登录
    FZLoginModeWeixin,  //微信登录
    FZLoginModeWeibo,   //新浪微博登录
};

@interface FZLoginView : UIImageView

@property (nonatomic, weak) id<FZLoginViewDelegate> delegate;

- (void)addLogoAnimation;

@end

@protocol FZLoginViewDelegate <NSObject>

/** 点击返回按钮时调用 */
- (void)loginView:(FZLoginView *)loginView backButtonClicked:(UIButton *)sender;

/** 根据不同的登录类型进行相应操作 */
- (void)loginView:(FZLoginView *)loginView loginButtonClicked:(UIButton *)sender loginMode:(FZLoginMode)loginMode;

/** 点击公布声明时调用 */
- (void)loginView:(FZLoginView *)loginView declarationButtonClicked:(UIButton *)sender;

@end
