//
//  FZRReleaseSuccessView.h
//  SelfBusiness
//
//  Created by --Chao-- on 14-6-11.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FZRReleaseSuccessViewDelegate;

//发布成功的视图
@interface FZRReleaseSuccessView : UIView

@property (nonatomic, retain) UILabel *tipLabel;
@property (nonatomic, assign) id<FZRReleaseSuccessViewDelegate> delegate;

@end

@protocol FZRReleaseSuccessViewDelegate <NSObject>

- (void)gotoCheckMyOrders;
- (void)backButtonClicked;

@end
