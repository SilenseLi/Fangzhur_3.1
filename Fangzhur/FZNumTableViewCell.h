//
//  FZNumTableViewCell.h
//  Fangzhur
//
//  Created by fq on 15/1/28.
//  Copyright (c) 2015年 Zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZNumTableViewCell : UITableViewCell
- (IBAction)ClickButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;

@end
