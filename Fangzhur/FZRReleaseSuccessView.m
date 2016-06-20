//
//  FZRReleaseSuccessView.m
//  SelfBusiness
//
//  Created by --Chao-- on 14-6-11.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZRReleaseSuccessView.h"
#import "AdjustLineSpacing.h"

@interface FZRReleaseSuccessView ()

- (void)UIConfig;

@end

@implementation FZRReleaseSuccessView

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
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 64 + 15, SCREEN_WIDTH - 30, 100)];
    _tipLabel.backgroundColor = [UIColor clearColor];
    _tipLabel.numberOfLines = 0;
    _tipLabel.text = [NSString stringWithFormat:kReleaseSuccessTipInfo, nil];
    _tipLabel.font = [UIFont fontWithName:kFontName size:16];
    _tipLabel.attributedText = [AdjustLineSpacing adjustString:_tipLabel.text withLineSpacing:10];
    [self addSubview:_tipLabel];
    
    //=================================
    
    NSArray *titleArray = [NSArray arrayWithObjects:@"查看我的订单", @"返   回", nil];
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(30, 300 + 55 * i, SCREEN_WIDTH - 60, 40);
        [button setBackgroundImage:[UIImage imageNamed:@"kaishi_btn"] forState:UIControlStateNormal];
        [button setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

- (void)buttonClicked:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
        {
            [_delegate gotoCheckMyOrders];
        }
            break;
            
        default:
        {
            [_delegate backButtonClicked];
        }
            break;
    }
}

@end
