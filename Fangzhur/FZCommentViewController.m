//
//  FZCommentViewController.m
//  Fangzhur
//
//  Created by --超-- on 14/12/7.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZCommentViewController.h"
#import "IQKeyboardManager.h"

@interface FZCommentViewController () <UIActionSheetDelegate>

- (void)configureUI;

@end

@implementation FZCommentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self configureUI];
    
    self.commentArray = [[NSMutableArray alloc] init];
    self.cellHeightArray = [[NSMutableArray alloc] init];
    self.currentPage = 1;
    self.isReply = NO;
    [self requestForCommentListOfPage:1];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureUI
{
    [self.navigationController performSelector:@selector(addTitle:) withObject:@"评论"];
    [self addButtonWithImageName:@"fanhui" target:self action:@selector(dismissViewController) position:POSLeft];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 44);
    button.titleLabel.font = [UIFont fontWithName:kFontName size:17];
    [button setTitle:@"写评论" forState:UIControlStateNormal];
    button.titleEdgeInsets = UIEdgeInsetsMake(6, 0, 0, 0);
    [button setTitleColor:kDefaultColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(writeComment) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonItem;
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    [self.tableView registerNib:[UINib nibWithNibName:@"FZCommentListCell" bundle:nil]
         forCellReuseIdentifier:@"FZCommentListCell"];
    
    UIMenuItem *replyItem = [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(replyAction)];
    UIMenuItem *reportItem = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(reportAction)];
    [UIMenuController sharedMenuController].menuItems = @[replyItem, reportItem];
    
    [self setupCommentBoard];
    
    self.waitingView = [[FZWaitingView alloc] init];
    [self.view addSubview:self.waitingView];
}

- (void)setupCommentBoard
{
    self.commentBoard = [[RDRStickyKeyboardView alloc] initWithScrollView:nil];
    self.commentBoard.frame = self.view.bounds;
    [self.commentBoard.inputView.rightButton addTarget:self action:@selector(didTapSend) forControlEvents:UIControlEventTouchUpInside];
    [self.commentBoard.inputView.leftButton addTarget:self action:@selector(didTapCancel) forControlEvents:UIControlEventTouchUpInside];
    self.commentBoard.hidden = YES;
    [self.view addSubview:self.commentBoard];
}

- (void)requestForCommentListOfPage:(NSInteger)page
{
    [[FZRequestManager manager] getCommentListWithHouseID:self.houseID houseType:self.houseType page:page complete:^(BOOL success, NSArray *commentList, NSDictionary *referenceDict) {
        [self.waitingView hide];
        
        if (page == 1) {
            [self.commentArray removeAllObjects];
            [self.cellHeightArray removeAllObjects];
        }
        
        if (success) {
            for (NSDictionary *commentInfo in commentList) {
                FZCommentModel *model = [[FZCommentModel alloc] init];
                [model setValuesForKeysWithDictionary:commentInfo];
                model.commentID = [commentInfo objectForKey:@"id"];
                [self.commentArray addObject:model];
                
                // 在数据下来的时候，进行楼层高度的计算
                CGFloat cellHeight = 50 + DynamicLabelSizeOf(model.content).height;
                if (model.comment_id_str.length != 0 && referenceDict.allKeys.count != 0) {
                    NSArray *replyIDArray = [model.comment_id_str componentsSeparatedByString:@","];
                    for (NSString *replyID in replyIDArray) {
                        NSDictionary *commentInfo = [referenceDict objectForKey:replyID];
                        cellHeight += (55 + DynamicLabelSizeOf([commentInfo objectForKey:@"content"]).height);
                    }
                    [self.cellHeightArray addObject:[NSNumber numberWithFloat:cellHeight]];
                }
                else {
                    [self.cellHeightArray addObject:[NSNumber numberWithFloat:cellHeight + 10]];
                }
            }
            self.referenceDict = referenceDict;
            
            [self.tableView footerEndRefreshing];
            [self.tableView headerEndRefreshing];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Table view delegate -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedCell = (FZCommentListCell *)[tableView cellForRowAtIndexPath:indexPath];
    //这里把cell做为第一响应 (cell默认是无法成为responder,需要重写canBecomeFirstResponder方法)
    [self.selectedCell becomeFirstResponder];
    [[UIMenuController sharedMenuController] setTargetRect:CGRectMake(CGRectGetMidX(self.selectedCell.frame), CGRectGetMidY(self.selectedCell.frame), 1, 1) inView:self.tableView];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cellHeightArray.count < indexPath.row + 1) {
        return 0;
    }
    return [[self.cellHeightArray objectAtIndex:indexPath.row] floatValue];
}

#pragma mark - Table view data source -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FZCommentListCell *commentListCell = [tableView dequeueReusableCellWithIdentifier:@"FZCommentListCell"];
    
    for (UIView *subview in commentListCell.contentView.subviews) {
        if (![subview isKindOfClass:[UILabel class]]) {
            [subview removeFromSuperview];
        }
    }
    
    FZCommentModel *model = [self.commentArray objectAtIndex:indexPath.row];
    commentListCell.tag = model.commentID.intValue;
    [commentListCell configureCellWithModel:model];

    //如果有回复，进行评论盖楼
    if (model.comment_id_str.length != 0 && self.referenceDict.allKeys.count != 0) {
        [commentListCell installReplyViewWithReferenceDict:self.referenceDict];
    }

    NSLog(@"%@", self.cellHeightArray);
    
    return commentListCell;
}

#pragma mark - Response events -

- (void)headerRefreshing
{
    self.currentPage = 1;
    [self requestForCommentListOfPage:1];
}

- (void)footerRefreshing
{
    [self requestForCommentListOfPage:++(self.currentPage)];
}

- (void)writeComment
{
    if ([FZUserInfoWithKey(Key_RoleType) integerValue] == 4) {
        [JDStatusBarNotification showWithStatus:@"您没有相应权限!" dismissAfter:2 styleName:JDStatusBarStyleError];
        return;
    }
    self.isReply = NO;
    [self.commentBoard showKeyboard];
}

- (void)replyAction
{
    self.isReply = YES;
    [self.commentBoard showKeyboard];
}

- (void)reportAction
{
    UIActionSheet *appraiseSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"是房主", @"未接通", @"已成交", @"错误房源", @"中介冒充房东", nil];
    appraiseSheet.tintColor = kDefaultColor;
    [appraiseSheet showInView:self.view];
    
    //一定要在评价窗口弹出后，取消观察者，防止其他通知，激活观察者执行错误的方法
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 5) {
        return;
    }
    
    [[FZRequestManager manager] appraiseHouseWithHouseID:self.houseID houseType:self.houseType appraiseType:[NSString stringWithFormat:@"%d", (int)(buttonIndex + 1)] complete:^(BOOL success, id responseObject) {
        if (success) {
            [JDStatusBarNotification showWithStatus:@"评价成功" dismissAfter:2];
        }
    }];
}

- (void)didTapCancel
{
    self.isReply = NO;
    [self.commentBoard hideKeyboard];
}

- (void)didTapSend
{
    [self.commentBoard hideKeyboard];
    [JDStatusBarNotification showWithStatus:@"发送中..."];
    [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    if (self.isReply) {
        self.isReply = NO;
        
        [[FZRequestManager manager] replyComment:self.commentBoard.inputView.textView.text withCommentID:[NSString stringWithFormat:@"%d", (int)self.selectedCell.tag] complete:^(BOOL success) {
            if (success) {
                [JDStatusBarNotification showWithStatus:@"回复成功" dismissAfter:2];
                [self requestForCommentListOfPage:1];
            }
            else {
                [JDStatusBarNotification showWithStatus:@"发送失败，请稍后重试"
                                           dismissAfter:2
                                              styleName:JDStatusBarStyleError];
            }
        }];
    }
    else {
        [[FZRequestManager manager] sendComment:self.commentBoard.inputView.textView.text withHouseID:self.houseID houseType:self.houseType complete:^(BOOL success) {
            if (success) {
                [JDStatusBarNotification showWithStatus:@"已提交" dismissAfter:2 styleName:JDStatusBarStyleDark];
                [self.tableView headerBeginRefreshing];
            }
        }];
    }
    
    [self.commentBoard clearTextView];
}

- (void)dismissViewController
{
    [self.commentBoard hideKeyboard];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
