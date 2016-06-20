//
//  FZDefaultTopView.m
//  AgentAPP
//
//  Created by Junk_cheung on 14-5-2.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZDefaultTopView.h"

@implementation FZDefaultTopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        backgroundView.image = [UIImage imageNamed:@"onedaohang.png"];
        [self addSubview:backgroundView];
        
        [self addButtons];
    }
    return self;
}

- (void)addButtons
{
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(0, 0, 160, 36);
    [_leftButton setBackgroundImage:[UIImage imageNamed:@"topxuanzhong.png"] forState:UIControlStateSelected];
    [_leftButton setTitle:@"Left" forState:UIControlStateNormal];
    [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    _leftButton.selected = YES;
    _leftButton.tag = 0;
    [self addSubview:_leftButton];
    [_leftButton addTarget:self action:@selector(topButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(160, 0, 160, 36);
    [_rightButton setBackgroundImage:[UIImage imageNamed:@"topxuanzhong.png"] forState:UIControlStateSelected];
    [_rightButton setTitle:@"Right" forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    _rightButton.tag = 1;
    [self addSubview:_rightButton];
    [_rightButton addTarget:self action:@selector(topButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)topButtonClicked:(id)sender
{
    if (sender == _leftButton && _leftButton.selected == NO) {
        _leftButton.selected = YES;
        _rightButton.selected = NO;
        _selectedIndex = 0;
        
        if (_block != nil) {
            self.block(_leftButton);
        }
        if ([_target respondsToSelector:_action]) {
            [_target performSelector:_action withObject:sender];
        }
    }
    else if (sender == _rightButton && _rightButton.selected == NO) {
        _leftButton.selected = NO;
        _rightButton.selected = YES;
        _selectedIndex = 1;
        
        if (_block != nil) {
            self.block(_rightButton);
        }
        if ([_target respondsToSelector:_action]) {
            [_target performSelector:_action withObject:sender];
        }
    }
}

- (void)selectedButtonChanged:(TopButtonBlock)block
{
    self.block = block;
}

- (void)setLeftTitle:(NSString *)leftTitle
{
    _leftTitle = leftTitle;
    [_leftButton setTitle:_leftTitle forState:UIControlStateNormal];
}

- (void)setRightTitle:(NSString *)rightTitle
{
    _rightTitle = rightTitle;
    [_rightButton setTitle:_rightTitle forState:UIControlStateNormal];
}

- (void)addTarget:(id)target action:(SEL)action
{
    _target = target;
    _action = action;
}

@end
