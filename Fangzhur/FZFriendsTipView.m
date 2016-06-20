//
//  FZFriendsTipView.m
//  AgentAPP
//
//  Created by L Suk on 14-4-30.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZFriendsTipView.h"

@interface FZFriendsTipView ()
{
    //控制视图的出现和消失
    UIButton *_tipButton;
    NSTimer *_timer;
}

- (void)UIConfig;

@end

@implementation FZFriendsTipView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self UIConfig];
    }
    return self;
}

- (void)UIConfig
{
    UIImageView *maskView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130)];
    maskView.image = [UIImage imageNamed:@"Wenben"];
    [self addSubview:maskView];
    
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, SCREEN_WIDTH - 10, 130)];
    _tipLabel.backgroundColor = [UIColor clearColor];
    _tipLabel.text = kFangzhurAboutTipString;
    _tipLabel.textAlignment = NSTextAlignmentLeft;
    _tipLabel.textColor = [UIColor whiteColor];
    _tipLabel.font = [UIFont systemFontOfSize:14];
    _tipLabel.numberOfLines = 0;
    [self addSubview:_tipLabel];
}

@end
