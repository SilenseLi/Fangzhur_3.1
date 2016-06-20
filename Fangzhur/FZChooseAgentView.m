//
//  FZChooseAgentView.m
//  Fangzhur
//
//  Created by --超-- on 14-7-22.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZChooseAgentView.h"

@interface FZChooseAgentView ()
{
    UIView *_maskView;
}

- (void)UIConfig;

@end

@implementation FZChooseAgentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _agentModel = [[FZAgentModel alloc] init];
        [self UIConfig];
    }
    
    return self;
}


- (void)UIConfig
{
    self.backgroundColor = [UIColor clearColor];
    
    _maskView = [[UIView alloc] initWithFrame:self.bounds];
    _maskView.backgroundColor = [UIColor blackColor];
    _maskView.alpha = 0.9;
    [self addSubview:_maskView];
    
    _agentView        = [[[NSBundle mainBundle] loadNibNamed:@"FZAgentView" owner:self options:nil] lastObject];
    _agentView.center = self.center;
    [self addSubview:_agentView];
    
    
    _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT - 50, SCREEN_WIDTH - 40, 35)];
    [_nextButton setTitle:@"下一个" forState:UIControlStateNormal];
    [_nextButton setTitleColor:RGBColor(220, 220, 220) forState:UIControlStateNormal];
    [self addSubview:_nextButton];
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

@end
