//
//  FZCommentListCell.h
//  Fangzhur
//
//  Created by --超-- on 14/12/5.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZCommentModel.h"

@interface FZCommentListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) UILabel *contentLabel;

- (void)configureCellWithModel:(FZCommentModel *)model;
- (void)installReplyViewWithReferenceDict:(NSDictionary *)referenceDict;

@end
