//
//  FZMobileLoginViewModel.h
//  Fangzhur
//
//  Created by --超-- on 14/11/3.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FZMobileLoginView;
@protocol FZMobileLoginViewModelDelegate;

@interface FZMobileLoginViewModel : NSObject
<UITextFieldDelegate>

/** 与模型关联的视图层 */
@property (nonatomic, weak) FZMobileLoginView *owner;
/** 倒计时计时器 */
@property (nonatomic, readonly) NSInteger counter;
@property (nonatomic, assign) id<FZMobileLoginViewModelDelegate> delegate;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, copy, readonly) NSString *userName;
@property (nonatomic, copy, readonly) NSString *password;
@property (nonatomic, copy, readonly) NSString *helpCode;
@property (nonatomic, copy, readonly) NSString *status;

- (instancetype)initWithOwner:(FZMobileLoginView *)owner;

/** 开始倒计时，并请求登录密码 */
- (void)timerFired;

/** 请求登录 */
- (void)startRequestForLoginComplete:(void (^)(BOOL success))responseBlock;

@end

@protocol FZMobileLoginViewModelDelegate <NSObject>

- (void)counterUpdating:(NSInteger)counter;

@end