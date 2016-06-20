//
//  FZUpdateInfoCell.m
//  Fangzhur
//
//  Created by --Chao-- on 14-7-3.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZUpdateInfoCell.h"

@implementation FZUpdateInfoCell

- (void)awakeFromNib
{
    _realNameField.delegate = self;
    _nickField.delegate     = self;
    _sexPickerControl.alpha = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)addTarget:(id)target action:(SEL)action
{
    _target = target;
    _action = action;
}

- (void)showSexControl
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = _sexPickerControl.frame;
        frame.origin.x = 147;
        _sexPickerControl.frame = frame;
        _sexPickerControl.alpha = 1;
    }];
}

- (void)hideSexControl
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = _sexPickerControl.frame;
        frame.origin.x = 320;
        _sexPickerControl.frame = frame;
        _sexPickerControl.alpha = 0;
    }];
}

- (IBAction)centerButtonClicked:(UIButton *)sender
{
    if ([_target respondsToSelector:_action]) {
        [_target performSelector:_action withObject:sender];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self resignKeyboard];
    return YES;
}

- (void)resignKeyboard
{
    [_realNameField resignFirstResponder];
    [_nickField resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resignKeyboard];
    if (_sexPickerControl.alpha == 1) {
        [self hideSexControl];
    }
}


@end
