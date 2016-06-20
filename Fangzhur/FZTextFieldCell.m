//
//  FZTextFieldCell.m
//  Fangzhur
//
//  Created by --超-- on 14/11/30.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZTextFieldCell.h"

@implementation FZTextFieldCell

- (void)awakeFromNib
{
    self.bgImageView.layer.cornerRadius = 5;
    self.bgImageView.clipsToBounds = YES;
    self.textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.textField.delegate = self;
}

- (void)showSideLabel
{
    self.leftLabel.hidden = NO;
    self.rightLabel.hidden = NO;
}

- (void)hideSideLabel
{
    self.leftLabel.hidden = YES;
    self.rightLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Text field delegate -

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.cacheArray replaceObjectAtIndex:self.tag withObject:textField.text];
    [self.delegate textFieldCell:self didEndEditing:textField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Keyboard delegate -

-(void)doneButtonClicked
{
    [self.textField resignFirstResponder];
}

-(void)numberKeyboardBackspace
{
    if (self.textField.text.length != 0) {
        self.textField.text = [self.textField.text substringToIndex:self.textField.text.length - 1];
    }
}

-(void)numberKeyboardInput:(NSInteger)number
{
    if (self.textField.text.length >= 15) {
        return;
    }
    
    self.textField.text = [self.textField.text stringByAppendingString:[NSString stringWithFormat:@"%d", (int)number]];
}


@end
