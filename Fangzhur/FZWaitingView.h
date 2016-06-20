//
//  FZWaitingView.h
//  Fangzhur
//
//  Created by --超-- on 14/12/10.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZWaitingView : UIView

@property (nonatomic, copy) void (^loadFailedHandler)();

- (void)show;
- (void)hide;
- (void)loadingFailedWithImage:(UIImage *)image handler:(void (^)())handler;

@end
