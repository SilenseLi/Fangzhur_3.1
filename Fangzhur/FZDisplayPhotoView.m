//
//  FZDisplayPhotoView.m
//  Fangzhur
//
//  Created by --超-- on 14/12/3.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZDisplayPhotoView.h"

@implementation FZDisplayPhotoView

- (void)awakeFromNib
{
    _maximumNumber = 6;
    [self resetPhotoButton];
}

- (void)resetPhotoButton
{
    for (int i = 0; i < self.maximumNumber; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:i + 1];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 15;
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [button setImage:[UIImage imageNamed:@"photo"] forState:UIControlStateNormal];
        [button setTitle:@"0" forState:UIControlStateNormal];
        
        if (i == 0) {
            button.hidden = NO;
        }
        else {
            button.hidden = YES;
        }
    }
}

- (IBAction)photoButtonClicked:(UIButton *)sender
{
    self.photoButtonHandler(sender);
}

@end
