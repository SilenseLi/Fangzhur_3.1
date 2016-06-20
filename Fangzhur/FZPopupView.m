//
//  FZPopupView.m
//  Fangzhur
//
//  Created by --超-- on 14/11/26.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZPopupView.h"
#import "UIButton+ZCCustomButtons.h"

@interface FZPopupView ()

@property (nonatomic, strong) FZHouseDetailModel *detailModel;

@end

@implementation FZPopupView

static FZPopupView *popupView;

- (void)drawRect:(CGRect)rect
{
    // create a new blank canvas
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context       = UIGraphicsGetCurrentContext();
    
    UIColor *topColor    = RGBAColor(50, 20, 10, 0.2);
    UIColor *bottomColor = RGBAColor(30, 30, 30, 0.7);
    
    NSArray *gradientColors = [NSArray arrayWithObjects:
                               (id)topColor.CGColor,
                               (id)bottomColor.CGColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, NULL);
    
    //裁剪自定义图形区域路径
    UIBezierPath *roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:0];
    [roundedRectanglePath addClip];
    
    // 线性渐变填充画布
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, SCREEN_HEIGHT), 0);
    
    //Release
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

+ (void)viewWillDisappear
{
    popupView = nil;
}

+ (void)showWithModel:(FZHouseDetailModel *)detailModel
{
    if (!popupView) {
        popupView.detailModel = detailModel;
        
        popupView = [[FZPopupView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        popupView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
        popupView.alpha = 0;
        [[[UIApplication sharedApplication] keyWindow] addSubview:popupView];
        
        popupView.tableView = [[FZPopupTableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 400)];
        popupView.tableView.detailModel = detailModel;
        [popupView addSubview:popupView.tableView];
        
        popupView.closeButton = [UIButton buttonWithFrame:CGRectMake((SCREEN_WIDTH - 100) / 2.0f, SCREEN_HEIGHT, 100, 30) title:nil imageName:@"guanbi" bgImageName:nil];
        [popupView.closeButton addTarget:popupView action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [popupView addSubview:popupView.closeButton];
    }
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        popupView.alpha = 1;
        popupView.tableView.frame = CGRectMake(0, SCREEN_HEIGHT - 450, SCREEN_WIDTH, 400);
        popupView.closeButton.frame = CGRectMake((SCREEN_WIDTH - 100) / 2.0f, SCREEN_HEIGHT - 40, 100, 30);
    } completion:nil];
}

+ (void)dismiss
{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        popupView.alpha = 0;
        popupView.tableView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 400);
        popupView.closeButton.frame = CGRectMake((SCREEN_WIDTH - 100) / 2.0f, SCREEN_HEIGHT, 100, 30);
    } completion:nil];
}


#pragma mark - 响应事件 -

- (void)closeButtonClicked
{
    [FZPopupView dismiss];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [FZPopupView dismiss];
}

@end
