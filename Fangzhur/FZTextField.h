//
//  FZLoginTextField.h
//  Fangzhur
//
//  Created by --超-- on 14/11/3.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZTextField : UITextField

@property (nonatomic, assign) BOOL selected;

- (instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder backGroundImage:(UIImage *)image;

@end
