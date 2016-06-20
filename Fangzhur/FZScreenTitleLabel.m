//
//  FZScreenTitleLabel.m
//  Fangzhur
//
//  Created by --超-- on 14/11/9.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZScreenTitleLabel.h"
#import <QuartzCore/QuartzCore.h>

@interface FZScreenTitleLabel ()

@end

@implementation FZScreenTitleLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
        self.numberOfLines = 0;
        self.lineBreakMode = NSLineBreakByWordWrapping;
        self.font = [UIFont fontWithName:kFontName size:17];
        
        //设置遮罩层
        CAGradientLayer *maskLayer = [CAGradientLayer layer];
        maskLayer.frame = self.bounds;
        maskLayer.colors = @[(id)[[UIColor blackColor] CGColor],
                             (id)[[UIColor clearColor] CGColor]];
        maskLayer.locations = @[@0.6, @1.0];
        maskLayer.startPoint = CGPointMake(0.0, 0.0);
        maskLayer.endPoint = CGPointMake(0.0, 1.0);
        self.layer.mask = maskLayer;
    }
    
    return self;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 90);
        self.backgroundColor = RGBColor(240, 240, 240);
        self.textAlignment = NSTextAlignmentCenter;
        self.numberOfLines = 0;
        self.lineBreakMode = NSLineBreakByWordWrapping;
        self.font = [UIFont fontWithName:kFontName size:17];
        
        //设置遮罩层
        CAGradientLayer *maskLayer = [CAGradientLayer layer];
        maskLayer.frame = self.bounds;
        maskLayer.colors = @[(id)[[UIColor blackColor] CGColor],
                             (id)[[UIColor clearColor] CGColor]];
        maskLayer.locations = @[@0.7, @1.0];
        maskLayer.startPoint = CGPointMake(0.0, 0.0);
        maskLayer.endPoint = CGPointMake(0.0, 1.0);
        self.layer.mask = maskLayer;
    }
    
    return self;
}

@end
