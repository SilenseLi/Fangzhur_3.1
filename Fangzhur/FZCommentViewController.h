//
//  FZCommentViewController.h
//  Fangzhur
//
//  Created by --超-- on 14/12/7.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZRootTableViewController.h"
#import "FZCommentListCell.h"
#import "RDRStickyKeyboardView.h"

#define DynamicLabelSizeOf(string)\
[string sizeWithFont:[UIFont fontWithName:kFontName size:15] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, 999) lineBreakMode:NSLineBreakByWordWrapping]

@interface FZCommentViewController : FZRootTableViewController

@property (nonatomic, strong) NSMutableArray *commentArray;
@property (nonatomic, strong) NSDictionary *referenceDict;
@property (nonatomic, strong) NSMutableArray *cellHeightArray;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) FZCommentListCell *selectedCell;
@property (nonatomic, strong) RDRStickyKeyboardView *commentBoard;
@property (nonatomic, strong) FZWaitingView *waitingView;
// yes 表示是对现有评论进行回复 no 表示对房源进行新评论
@property (nonatomic, assign) BOOL isReply;

@property (nonatomic, copy) NSString *houseID;
@property (nonatomic, copy) NSString *houseType;

- (void)requestForCommentListOfPage:(NSInteger)page;
- (void)dismissViewController;

- (void)replyAction;
- (void)headerRefreshing;
- (void)footerRefreshing;

@end
