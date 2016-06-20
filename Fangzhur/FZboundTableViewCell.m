//
//  FZboundTableViewCell.m
//  Fangzhur
//
//  Created by fq on 15/1/6.
//  Copyright (c) 2015年 Zc. All rights reserved.
//

#import "FZboundTableViewCell.h"

@implementation FZboundTableViewCell

- (void)awakeFromNib {
    self.choosebtn.selected = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)chooseButton:(UIButton *)sender {
    sender.selected = !sender.selected;

}
@end
