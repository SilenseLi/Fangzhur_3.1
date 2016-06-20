//
//  FZCommentReplyView.h
//  Fangzhur
//
//  Created by --超-- on 14/12/7.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZCommentModel.h"

@interface FZCommentReplyView : UIView

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *floorLabel;
@property (nonatomic, strong) UILabel *contentLabel;

- (instancetype)initWithFrame:(CGRect)frame commentModel:(FZCommentModel *)model floor:(NSInteger)floor;

@end
