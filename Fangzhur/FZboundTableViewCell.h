//
//  FZboundTableViewCell.h
//  Fangzhur
//
//  Created by fq on 15/1/6.
//  Copyright (c) 2015年 Zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZboundTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *choosebtn;
@property (weak, nonatomic) IBOutlet UILabel *bankcardLabel;
- (IBAction)chooseButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *serviceButton;

@end
