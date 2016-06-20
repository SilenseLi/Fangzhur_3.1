//
//  FZGuideView.m
//  Fangzhur
//
//  Created by --超-- on 14-7-27.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZGuideView.h"

@implementation FZGuideView

+ (FZGuideView *)GuideViewWithImage:(UIImage *)image atView:(UIView *)view
{
    FZGuideView *guideView = [[self alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    guideView.image        = image;
    guideView.contentMode = UIViewContentModeScaleToFill;
    guideView.userInteractionEnabled = YES;
    [view addSubview:guideView];
    
    return guideView;
}

- (void)guideViewDismiss:(GuideViewBlock)block
{
    self.block = block;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
    
    if (self.block) {
        self.block();
    }
}

@end
