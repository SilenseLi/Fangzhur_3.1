//
//  FZDefaultTopView.h
//  AgentAPP
//
//  Created by Junk_cheung on 14-5-2.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TopButtonBlock)(UIButton *topButton);

//320 * 40
@interface FZDefaultTopView : UIView
{
    UIButton *_leftButton;
    UIButton *_rightButton;
    NSString *_leftTitle;
    NSString *_rightTitle;
    TopButtonBlock _block;
}

@property (nonatomic, retain) UIButton *leftButton;
@property (nonatomic, retain) UIButton *rightButton;
@property (nonatomic, copy) NSString *leftTitle;
@property (nonatomic, copy) NSString *rightTitle;
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, copy) TopButtonBlock block;

- (id)initWithFrame:(CGRect)frame;
- (void)addTarget:(id)target action:(SEL)action;
- (void)selectedButtonChanged:(TopButtonBlock)block;


@end
