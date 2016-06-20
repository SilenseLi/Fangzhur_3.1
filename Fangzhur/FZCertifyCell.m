//
//  FZCertifyCell.m
//  Fangzhur
//
//  Created by --Chao-- on 14-7-2.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZCertifyCell.h"
#import "UIImageView+WebCache.h"
#import "ImageTool.h"

@implementation FZCertifyCell

- (void)awakeFromNib
{
    [self fixImageViews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fixImageViews
{
    _headImageView.clipsToBounds = YES;
    _headImageView.layer.cornerRadius = 30;
    _headImageView.layer.borderColor = [RGBColor(220, 220, 220) CGColor];
    _headImageView.layer.borderWidth = 2;
    
    _identityImageView.clipsToBounds   = YES;
    _identityImageView.backgroundColor = [UIColor lightGrayColor];
}

- (void)addTarget:(id)target action:(SEL)action
{
    _target = target;
    _action = action;
}

- (IBAction)uploadPicture:(UIButton *)sender
{
    _selectedIndex = sender.tag;
    if ([_target respondsToSelector:_action]) {
        [_target performSelector:_action withObject:self];
    }
}

- (void)updateHeadImage:(NSString *)imageURL buttonStatus:(NSString *)status
{
    if (imageURL) {
        [_headImageView setImageWithURL:[NSURL URLWithString:URLStringByAppending(imageURL)]
                       placeholderImage:[UIImage imageNamed:@"icon_toux.png"]];
        [[ImageTool shareTool] resizeImage:_headImageView.image withSize:CGSizeMake(60, 60)];
    }
    
    //======================================
    
    if (status.intValue == 1) {
        [_headButton setTitle:@"审核通过, 重新上传?" forState:UIControlStateNormal];
    }
    else if (status.intValue == 2) {
        _headButton.enabled = NO;
    }
    else {
        [_headButton setTitle:@"上传头像" forState:UIControlStateNormal];
    }
}

- (void)updateIdentityImage:(NSString *)imageURL buttonStatus:(NSString *)status
{
    if (imageURL) {
        [_identityImageView setImageWithURL:[NSURL URLWithString:URLStringByAppending(imageURL)]
                           placeholderImage:[UIImage imageNamed:@"icon_toux.png"]];
        [[ImageTool shareTool] resizeImage:_identityImageView.image withSize:CGSizeMake(60, 60)];
    }
    
    //==================================
    
    if (status.intValue == 1) {
        [_identityButton setTitle:@"审核通过, 重新上传?" forState:UIControlStateNormal];
    }
    else if (status.intValue == 2) {
        _identityButton.enabled = NO;
    }
    else {
        [_identityButton setTitle:@"上传身份证" forState:UIControlStateNormal];
    }
}



@end
