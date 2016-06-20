//
//  FZWaitingView.m
//  Fangzhur
//
//  Created by --超-- on 14/12/10.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZWaitingView.h"
#import "PulsingHaloLayer.h"

@interface FZWaitingView ()

@property (nonatomic, strong) PulsingHaloLayer *waitingLayer;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation FZWaitingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
    }
    
    return self;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = RGBColor(240, 240, 240);
        
        [self addWaitingLayer];
    }
    
    return self;
}

- (void)addWaitingLayer
{
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jiazaidonghua"]];
    self.imageView.frame = CGRectMake(CGRectGetMidX(self.bounds) - 50, CGRectGetMidY(self.bounds) - 50, 100, 100);
    [self addSubview:self.imageView];
    
    self.waitingLayer = [[PulsingHaloLayer alloc] initWithRepeatCount:INFINITY];
    self.waitingLayer.position = self.center;
    [self.layer insertSublayer:self.waitingLayer below:self.imageView.layer];
    
    self.waitingLayer.backgroundColor = kDefaultColor.CGColor;
    self.waitingLayer.radius = SCREEN_HEIGHT / 2.0f;
}

#pragma mark - Animation -

- (void)show
{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.alpha = 1;
    self.imageView.frame = CGRectMake(CGRectGetMidX(self.bounds) - 50, CGRectGetMidY(self.bounds) - 50, 100, 100);
}

- (void)hide
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alpha = 0;
        self.frame = CGRectMake(0, -300, SCREEN_WIDTH, SCREEN_HEIGHT + 300);
        self.imageView.frame = CGRectMake(CGRectGetMidX(self.bounds) - 100, CGRectGetMidY(self.bounds) - 100, 200, 200);
    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
    }];
}

- (void)loadingFailedWithImage:(UIImage *)image handler:(void (^)())handler;
{
    self.frame = [UIScreen mainScreen].bounds;
    self.alpha = 1;
    self.imageView.frame = CGRectMake(CGRectGetMidX(self.bounds) - 50, CGRectGetMidY(self.bounds) - 50, 100, 100);
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.tag = 1;
    imageView.frame = [UIScreen mainScreen].bounds;
    [self addSubview:imageView];
    
    self.loadFailedHandler = handler;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self viewWithTag:1]) {
        [[self viewWithTag:1] removeFromSuperview];
        
        self.loadFailedHandler();
    }
}

@end
