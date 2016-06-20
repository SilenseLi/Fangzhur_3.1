//
//  FZOrderMenuBar.m
//  Fangzhur
//
//  Created by --Chao-- on 14-7-4.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZOrderMenuBar.h"

#define ITEM_WIDTH 80
#define ITEM_HEIGHT 44
#define SPACE_WIDTH 20

@interface FZOrderMenuBar ()
{
    //标记选中项
    UILabel *_flagLabel;
}

@end

@implementation FZOrderMenuBar

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 64, SCREEN_WIDTH, ITEM_HEIGHT);
    }
    
    return self;
}

- (void)addTarget:(id)target action:(SEL)action
{
    _target = target;
    _action = action;
}

- (void)installMenuInView:(UIView *)view
{
    self.contentSize = CGSizeMake((ITEM_WIDTH * _titleArray.count) + (SPACE_WIDTH * (_titleArray.count - 1)) + 30, ITEM_HEIGHT);
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator   = NO;
    
    //============================================
    
    if (_titleArray.count == 2) {
        for (int i = 0; i < _titleArray.count; i++) {
            UIButton *buttonItem       = [UIButton buttonWithType:UIButtonTypeCustom];
            buttonItem.frame           = CGRectMake(15 + ((SCREEN_WIDTH - 30 - ITEM_WIDTH * 2) + ITEM_WIDTH) * i, 0, ITEM_WIDTH, ITEM_HEIGHT);
            buttonItem.tag             = i;
            buttonItem.backgroundColor = [UIColor clearColor];
            
            [buttonItem setTitle:[_titleArray objectAtIndex:i] forState:UIControlStateNormal];
            [buttonItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            buttonItem.titleLabel.font = [UIFont systemFontOfSize:15];
            [buttonItem addTarget:self action:@selector(buttonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:buttonItem];
        }
    }
    else {
        for (int i = 0; i < _titleArray.count; i++) {
            UIButton *buttonItem       = [UIButton buttonWithType:UIButtonTypeCustom];
            buttonItem.frame           = CGRectMake(15 + (SPACE_WIDTH + ITEM_WIDTH) * i, 0, ITEM_WIDTH, ITEM_HEIGHT);
            buttonItem.tag             = i;
            buttonItem.backgroundColor = [UIColor clearColor];
            
            [buttonItem setTitle:[_titleArray objectAtIndex:i] forState:UIControlStateNormal];
            [buttonItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            buttonItem.titleLabel.font = [UIFont systemFontOfSize:15];
            [buttonItem addTarget:self action:@selector(buttonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:buttonItem];
        }
    }
    
    _flagLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, ITEM_HEIGHT - 4, ITEM_WIDTH, 2)];
    _flagLabel.backgroundColor = kDefaultColor;
    [self addSubview:_flagLabel];
    
    [view addSubview:self];
}

- (void)buttonItemClicked:(UIButton *)sender
{
    if (self.channelBlock) {
        self.channelBlock(sender.tag);
    }
    [self adjustButtonPosition:sender];
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame     = _flagLabel.frame;
        frame.origin.x   = sender.frame.origin.x;
        _flagLabel.frame = frame;
    }];
    
    if ([_target respondsToSelector:_action]) {
        [_target performSelector:_action withObject:sender];
    }
}

- (void)changeChannel:(ChangeChannelBlock)block
{
    self.channelBlock = block;
}

- (void)changeSelectedItem:(NSInteger)index
{
    UIButton *selectedButton = (UIButton *)[self.subviews objectAtIndex:index];
    [self adjustButtonPosition:selectedButton];
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame     = _flagLabel.frame;
        frame.origin.x   = selectedButton.frame.origin.x;
        _flagLabel.frame = frame;
    }];
}

- (void)adjustButtonPosition:(UIButton *)sender
{
    CGFloat buttonEndPos = sender.frame.origin.x + sender.frame.size.width;
    if (buttonEndPos >= SCREEN_WIDTH) {
        [self setContentOffset:CGPointMake(buttonEndPos - SCREEN_WIDTH + 15, 0) animated:YES];
    }
    else if (sender.frame.origin.x < self.contentOffset.x) {
        [self setContentOffset:CGPointMake(sender.frame.origin.x - 15, 0) animated:YES];
    }
}

@end
