//
//  FZUserInfoView.m
//  Fangzhur
//
//  Created by --超-- on 14/11/6.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZUserInfoView.h"
#import <UIImageView+WebCache.h>

@implementation FZUserInfoView

- (void)awakeFromNib
{
    NSString *imageURLString = nil;
    if ([FZUserInfoWithKey(Key_BindingTag) isEqualToString:@"Unbind"]) {
        imageURLString = FZUserInfoWithKey(Key_HeadImage);
    }
    else {
        imageURLString = URLStringByAppending(FZUserInfoWithKey(Key_HeadImage));
    }
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:imageURLString]
                          placeholderImage:[UIImage imageNamed:@"moren_touxiang"]];
    
    self.userNameLabel.text = FZUserInfoWithKey(Key_UserName);
    if ([FZUserInfoWithKey(Key_RoleType) integerValue] == 4) {
        self.userTypeLabel.text = @"经纪人";
    }
    else {
        self.userTypeLabel.text = @"普通用户";
    }

    self.userCashLabel.text = [NSString stringWithFormat:@"%@ 元", FZUserInfoWithKey(Key_UserCash)];
    self.userCreditsLabel.text = [NSString stringWithFormat:@"%@", FZUserInfoWithKey(Key_UserCredits)];
    self.userTicketsLabel.text = [NSString stringWithFormat:@"%@ 元", FZUserInfoWithKey(Key_UserTickets)];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    _headImageView.clipsToBounds      = YES;
    _headImageView.layer.cornerRadius = 30;
    _headImageView.layer.borderColor  = [[UIColor whiteColor] CGColor];
    _headImageView.layer.borderWidth  = 1.5f;
}

@end
