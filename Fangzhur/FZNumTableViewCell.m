//
//  FZNumTableViewCell.m
//  Fangzhur
//
//  Created by fq on 15/1/28.
//  Copyright (c) 2015年 Zc. All rights reserved.
//

#import "FZNumTableViewCell.h"

@implementation FZNumTableViewCell

- (void)awakeFromNib {
    self.chooseBtn.selected = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)ClickButton:(UIButton *)sender {
    sender.selected = !sender.selected;

}
@end
