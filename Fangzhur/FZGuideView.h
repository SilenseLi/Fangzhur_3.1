//
//  FZGuideView.h
//  Fangzhur
//
//  Created by --超-- on 14-7-27.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^GuideViewBlock)();

@interface FZGuideView : UIImageView

@property (nonatomic, copy) GuideViewBlock block;

+ (FZGuideView *)GuideViewWithImage:(UIImage *)image atView:(UIView *)view;
- (void)guideViewDismiss:(GuideViewBlock)block;

@end
