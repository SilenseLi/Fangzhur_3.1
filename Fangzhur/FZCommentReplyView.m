//
//  FZCommentReplyView.m
//  Fangzhur
//
//  Created by --超-- on 14/12/7.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZCommentReplyView.h"

#define DynamicLabelSizeOf(string)\
        [string sizeWithFont:[UIFont fontWithName:kFontName size:15] constrainedToSize:CGSizeMake(CGRectGetWidth(self.bounds) - 10, 999) lineBreakMode:NSLineBreakByWordWrapping]

@interface FZCommentReplyView ()

@property (nonatomic, strong) FZCommentModel *commentModel;
@property (nonatomic, assign) NSInteger floor;

@end

@implementation FZCommentReplyView

- (instancetype)initWithFrame:(CGRect)frame commentModel:(FZCommentModel *)model floor:(NSInteger)floor
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.commentModel = model;
        self.floor = floor;
        
        [self addNameLabel];
        [self addFloorLabel];
        [self addContentLabel];
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + 30 + CGRectGetHeight(self.contentLabel.bounds) + 10);
    }
    
    return self;
}

- (void)layoutSubviews
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.layer.borderColor = [RGBColor(230, 230, 230) CGColor];
    self.layer.borderWidth = 0.5f;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;

    [super layoutSubviews];
}

- (void)addNameLabel
{
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5 + CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds) - 100, 21)];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.font = [UIFont fontWithName:kFontName size:17];
    self.nameLabel.text = [self.commentModel stringByHidePhoneTail];
    [self addSubview:self.nameLabel];
}

- (void)addFloorLabel
{
    self.floorLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - 75, 5 + CGRectGetHeight(self.bounds), 60, 21)];
    self.floorLabel.backgroundColor = [UIColor clearColor];
    self.floorLabel.font = [UIFont fontWithName:kFontName size:15];
    self.floorLabel.textColor = [UIColor darkGrayColor];
    self.floorLabel.text = [NSString stringWithFormat:@"%d", self.floor];
    self.floorLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.floorLabel];
}

- (void)addContentLabel
{
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, self.nameLabel.frame.origin.y + 25, CGRectGetWidth(self.bounds) - 100, DynamicLabelSizeOf(self.commentModel.content).height)];
    self.contentLabel.backgroundColor = [UIColor clearColor];
    self.contentLabel.font = [UIFont fontWithName:kFontName size:15];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.contentLabel.textColor = [UIColor darkGrayColor];
    self.contentLabel.text = self.commentModel.content;
    [self addSubview:self.contentLabel];
}

@end
