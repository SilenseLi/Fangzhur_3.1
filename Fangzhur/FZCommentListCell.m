//
//  FZCommentListCell.m
//  Fangzhur
//
//  Created by --超-- on 14/12/5.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZCommentListCell.h"
#import "FZCommentReplyView.h"

@interface FZCommentListCell ()

//存放所有引用楼层的id
@property (nonatomic, strong) NSArray *referenceIDArray;
//引用评论模型数组
@property (nonatomic, strong) NSMutableArray *commentArray;

@end

#pragma mark - 盖楼 -

@implementation FZCommentListCell

- (void)awakeFromNib
{
    self.commentArray = [[NSMutableArray alloc] init];
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 49, SCREEN_WIDTH - 30, 21)];
    self.contentLabel.backgroundColor = [UIColor clearColor];
    self.contentLabel.textColor = [UIColor darkGrayColor];
    self.contentLabel.font = [UIFont fontWithName:kFontName size:15];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:self.contentLabel];
}

- (void)drawRect:(CGRect)rect
{
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)configureCellWithModel:(FZCommentModel *)model
{
    self.nameLabel.text = [model stringByHidePhoneTail];
    dateExchange([model.created_on doubleValue], self.dateLabel.text);
    
    CGSize contentLabelSize = [model.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:kFontName size:15]} context:nil].size;
    self.contentLabel.frame = CGRectMake(17, 49, contentLabelSize.width, contentLabelSize.height);
    self.contentLabel.text = model.content;
    self.referenceIDArray = [model.comment_id_str componentsSeparatedByString:@","];
}

- (void)installReplyViewWithReferenceDict:(NSDictionary *)referenceDict
{
    if ([self.referenceIDArray.lastObject length] == 0) {
        return;
    }
    
    [self.commentArray removeAllObjects];

    for (NSString *key in self.referenceIDArray) {
        NSDictionary *commentInfo = [referenceDict objectForKey:key];
        FZCommentModel *model = [[FZCommentModel alloc] init];
        [model setValue:[commentInfo objectForKey:@"id"] forKey:model.commentID];
        [model setValuesForKeysWithDictionary:commentInfo];
        [self.commentArray addObject:model];
    }
    
    CGFloat height = [self addFloorWithCommentArray:self.commentArray floorIndex:self.commentArray.count - 1];
    CGSize contentLabelSize = [self.contentLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:kFontName size:15]} context:nil].size;
    self.contentLabel.frame = CGRectMake(17, 49 + height, contentLabelSize.width, contentLabelSize.height);
    
    CGRect frame = self.frame;
    frame.size.height = height + self.contentLabel.frame.size.height + 60;
    self.frame = frame;
}

- (CGFloat)addFloorWithCommentArray:(NSArray *)commentArray floorIndex:(NSInteger)floorIndex;
{
    CGFloat x = 15;
    if (floorIndex < 4) {
        x = 15 + (commentArray.count - floorIndex) * 2;
    }
    CGFloat y = 50;
    if (floorIndex < 4) {
        y = 50 + (commentArray.count - floorIndex) * 2;
    }
    CGFloat height = 0;
    if (floorIndex != 0) {
        height = [self addFloorWithCommentArray:commentArray floorIndex:floorIndex - 1];
    }
    
    FZCommentModel *model = [commentArray objectAtIndex:floorIndex];
    
    FZCommentReplyView *replyView = [[FZCommentReplyView alloc] initWithFrame:CGRectMake(x, y, SCREEN_WIDTH - 2 * x, height) commentModel:model floor:floorIndex + 1];
    [self.contentView insertSubview:replyView atIndex:0];
    
    return replyView.frame.size.height + 10;
}

//为了让菜单显示，目标视图必须在responder链中，很多UIKit视图默认并无法成为一个responder，
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

@end
