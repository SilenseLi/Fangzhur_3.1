//
//  FZCounterCell.m
//  Fangzhur
//
//  Created by --超-- on 14/11/28.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZCounterCell.h"

@interface FZCounterCell ()

@property (nonatomic, assign) NSInteger counter;

@end

@implementation FZCounterCell

- (void)awakeFromNib
{
    self.bgImageView.layer.cornerRadius = 5;
    self.bgImageView.clipsToBounds = YES;
    self.subtructButton.enabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCell
{
    if ([[self.cacheArray objectAtIndex:self.tag] intValue] == 0) {
        self.subtructButton.enabled = NO;
    }
    else {
        self.subtructButton.enabled = YES;
    }
}

- (IBAction)adjustCounter:(UIButton *)sender
{
    // 读取上次的计数，防止计数器混乱
    self.counter = [[self.cacheArray objectAtIndex:self.tag] intValue];
    
    if (self.tag == 4 && sender == self.subtructButton) {
        if (self.counter <= 1) {
            self.subtructButton.enabled = NO;
            return;
        }
    }
    else {
        if (self.counter <= 0 && sender == self.subtructButton) {
            self.subtructButton.enabled = NO;
            return;
        }
    }
    if (self.counter == 123) {
        self.addButton.enabled = NO;
        return;
    }
    
    if (sender.tag == 1) {// Subtract
        self.addButton.enabled = YES;
        self.displayLabel.text = [NSString stringWithFormat:@"%d", --(self.counter)];
    }
    else {// Add
        self.subtructButton.enabled = YES;
        self.displayLabel.text = [NSString stringWithFormat:@"%d", ++(self.counter)];
    }
    
    [self.cacheArray replaceObjectAtIndex:self.tag withObject:self.displayLabel.text];
}


@end
