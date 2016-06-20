//
//  FZFriendsCenterView.m
//  AgentAPP
//
//  Created by L Suk on 14-4-30.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZFriendsCenterView.h"
#import "FZFriendsTipView.h"

#define kShareViewWidth 80
#define kShareViewHeight 100
#define Space (SCREEN_WIDTH - 80 * 3) / 4

@implementation FZFriendsCenterView

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
    self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height + 200);
    self.showsVerticalScrollIndicator = NO;
    
    FZFriendsTipView *tipView = [[FZFriendsTipView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130)];
    [self addSubview:tipView];
    
    _codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 75, 160, 150, 150)];
    _codeImageView.image = [UIImage imageNamed:@"code"];
    _codeImageView.layer.borderWidth = 2;
    _codeImageView.layer.borderColor = [[UIColor grayColor] CGColor];
    [self addSubview:_codeImageView];
    
    NSArray *titleArray = [NSArray arrayWithObjects:
                           @"发给微信好友",
                           @"分享朋友圈",
                           @"发给QQ好友",
                           @"分享微博",
                           @"发短信给好友", nil];
    for (int i = 0; i < 5; i++) {
        UIView *shareView = [[UIView alloc] initWithFrame:
                             CGRectMake(Space + i % 3 * (kShareViewWidth + Space), 330 + i / 3 * (kShareViewWidth + 30),
                                        kShareViewWidth, kShareViewHeight)];
        [self addSubview:shareView];
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        shareButton.frame = CGRectMake(0, 0 + kAdjustScale, kShareViewWidth, kShareViewHeight - 30);
        [shareButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"shareIcon%d", i + 1]]
                     forState:UIControlStateNormal];
        shareButton.tag = i;
        [shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:shareButton];
        
        UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60 + kAdjustScale, 80, 40)];
        titlelabel.text = [titleArray objectAtIndex:i];
        titlelabel.backgroundColor = [UIColor clearColor];
        titlelabel.font = [UIFont systemFontOfSize:13];
        titlelabel.textAlignment = NSTextAlignmentCenter;
        [shareView addSubview:titlelabel];
    }
}

- (void)shareButtonClicked:(UIButton *)sender
{
    if ([_target respondsToSelector:_action]) {
        [_target performSelector:_action withObject:self withObject:sender];
    }
}

- (void)addTarget:(id)target action:(SEL)action
{
    _target = target;
    _action = action;
}

@end
