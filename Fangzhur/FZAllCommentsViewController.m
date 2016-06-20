//
//  FZAllCommentsViewController.m
//  Fangzhur
//
//  Created by --超-- on 14/12/19.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZAllCommentsViewController.h"

@interface FZAllCommentsViewController ()

@end

@implementation FZAllCommentsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = nil;
    
    UIMenuItem *replyItem = [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(replyAction)];
    [UIMenuController sharedMenuController].menuItems = @[replyItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - override methods -

- (void)requestForCommentListOfPage:(NSInteger)page
{
    [[FZRequestManager manager] getAllCommentsWithPage:page complete:^(BOOL success, NSArray *commentList, NSDictionary *referenceDict) {
        [self.waitingView hide];
        
        if (page == 1) {
            [self.commentArray removeAllObjects];
            [self.cellHeightArray removeAllObjects];
        }
        
        if (success) {
            [[FZRequestManager manager] markCommentsReaded];
            [[FZRequestManager manager] getMessageNumber:^(NSString *newMessageNum) {
            }];
            
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

- (void)dismissViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
