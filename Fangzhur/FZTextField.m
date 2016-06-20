//
//  FZLoginTextField.m
//  Fangzhur
//
//  Created by --超-- on 14/11/3.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZTextField.h"

@implementation FZTextField

- (instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder backGroundImage:(UIImage *)image
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.placeholder = placeholder;
        self.background = image;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.textColor = [UIColor whiteColor];
        self.font = [UIFont fontWithName:kFontName size:15];
        [self setValue:RGBColor(200, 200, 200) forKeyPath:@"_placeholderLabel.textColor"];
        
        [self.layer setShadowOffset:CGSizeMake(15, 15)];
        self.layer.cornerRadius = 10;
        [self.layer setShadowRadius:10];
        [self.layer setShadowColor:[UIColor whiteColor].CGColor];
        CGPathRef path = CGPathCreateWithRect(CGRectMake(10, 10, CGRectGetWidth(self.bounds) - 20, CGRectGetHeight(self.bounds) - 20), NULL);
        [self.layer setShadowPath:path];
        CGPathRelease(path);
    }
    
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + 10, bounds.origin.y, bounds.size.width - 20, bounds.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + 10, bounds.origin.y, bounds.size.width - 20, bounds.size.height);
}

- (void)setSelected:(BOOL)selected
{
    
    if (selected) {
        [self.layer setShadowOpacity:0.3];
    }
    else {
        [self.layer setShadowOpacity:0];
    }
}

@end
