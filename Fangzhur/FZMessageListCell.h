//
//  FZMessageListCell.h
//  Fangzhur
//
//  Created by --超-- on 14/12/19.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZMessageModel.h"

@interface FZMessageListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;

- (void)configureCellWithMessageModel:(FZMessageModel *)messageModel;

@end
