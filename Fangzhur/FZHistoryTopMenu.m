//
//  FZHistoryTopMenu.m
//  Fangzhur
//
//  Created by --Chao-- on 14-7-3.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZHistoryTopMenu.h"

#define ITEM_WIDTH 60
#define ITEM_HEIGHT 44

@interface FZHistoryTopMenu ()
{
    //标记选中项
    UILabel *_flagLabel;
}

@end

@implementation FZHistoryTopMenu

- (id)init
{
    self = [super init];
    if (self) {
        self.frame               = CGRectMake(0, 64, SCREEN_WIDTH, ITEM_HEIGHT);
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        bgImageView.image        = [UIImage imageNamed:@"onedaohang.png"];
        bgImageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        bgImageView.layer.borderWidth = 0.5f;
        
        [self addSubview:bgImageView];
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
    self.contentSize = CGSizeMake(ITEM_WIDTH * _titleArray.count, ITEM_HEIGHT);
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator   = NO;
    
    //============================================
    
    CGFloat spaceWidth = ((SCREEN_WIDTH) - (ITEM_WIDTH * _titleArray.count)) / (_titleArray.count + 1);
    for (int i = 0; i < _titleArray.count; i++) {
        UIButton *buttonItem       = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonItem.frame           = CGRectMake(spaceWidth + (spaceWidth + ITEM_WIDTH) * i, 0, ITEM_WIDTH, ITEM_HEIGHT);
        buttonItem.tag             = i;
        buttonItem.backgroundColor = [UIColor clearColor];
        
        [buttonItem setTitle:[_titleArray objectAtIndex:i] forState:UIControlStateNormal];
        [buttonItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        buttonItem.titleLabel.font = [UIFont systemFontOfSize:15];
        [buttonItem addTarget:self action:@selector(buttonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:buttonItem];
    }
    
    _flagLabel = [[UILabel alloc] initWithFrame:CGRectMake(spaceWidth, ITEM_HEIGHT - 6, ITEM_WIDTH, 2)];
    _flagLabel.backgroundColor = kDefaultColor;
    [self addSubview:_flagLabel];
    
    [view addSubview:self];
}

- (void)buttonItemClicked:(UIButton *)sender
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame     = _flagLabel.frame;
        frame.origin.x   = sender.frame.origin.x;
        _flagLabel.frame = frame;
    }];
    
    if ([_target respondsToSelector:_action]) {
        [_target performSelector:_action withObject:sender];
    }
}

- (void)changeSelectedItem:(NSInteger)index
{
    UIButton *selectedButton = (UIButton *)[self.subviews objectAtIndex:index + 1];
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame     = _flagLabel.frame;
        frame.origin.x   = selectedButton.frame.origin.x;
        _flagLabel.frame = frame;
    }];
}

@end
