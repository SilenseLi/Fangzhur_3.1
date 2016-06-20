//
//  UIView+VariousView.m
//  Fangzhur
//
//  Created by --超-- on 14-8-29.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "UIView+VariousView.h"

@implementation UIView (VariousView)

+ (id)viewWithFrame:(CGRect)frame cornerRadius:(CGFloat)radius borderColor:(UIColor *)color
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.layer.masksToBounds = YES;
    view.layer.borderWidth   = 1.5;
    view.layer.borderColor   = [color CGColor];
    view.layer.cornerRadius  = radius;
    
    return view;
}

@end
