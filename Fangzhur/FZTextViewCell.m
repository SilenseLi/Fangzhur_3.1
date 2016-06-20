//
//  FZTextViewCell.m
//  Fangzhur
//
//  Created by --超-- on 14/11/30.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZTextViewCell.h"

@interface FZTextViewCell ()

@property (nonatomic, strong) UIToolbar *keyboardToolbar;

@end

@implementation FZTextViewCell

- (void)awakeFromNib
{
    self.descriptionTextView.layer.cornerRadius = 5;
    self.descriptionTextView.clipsToBounds = YES;
    self.descriptionTextView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Text view delegate -

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.cacheArray replaceObjectAtIndex:self.tag withObject:textView.text];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length == 0) {
        self.tipLabel.text = @"限300字内";
    }
    else {
        self.tipLabel.text = [NSString stringWithFormat:@"剩余%d字", (int)(300 - textView.text.length)];
    }
    
    if (textView.text.length >= 300) {
        return NO;
    }
    
    return YES;
}

@end
