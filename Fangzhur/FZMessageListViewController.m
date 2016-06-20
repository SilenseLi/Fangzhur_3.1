//
//  FZMessageListViewController.m
//  Fangzhur
//
//  Created by --超-- on 14/12/19.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZMessageListViewController.h"
#import "FZMessageListCell.h"
#import "FZMessageModel.h"
#import "FZChattingViewController.h"
#import "FZAllCommentsViewController.h"
#import "FZOfficialViewController.h"

@interface FZMessageListViewController ()

@property (nonatomic, strong) FZWaitingView *waitingView;
@property (nonatomic, strong) NSMutableArray *dataArray;

- (void)configureUI;
- (void)requestMessageListData;

@end

@implementation FZMessageListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureUI];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:Key_NewMessage];
    self.dataArray = [[NSMutableArray alloc] init];
    [self requestMessageListData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController performSelector:@selector(addTitle:) withObject:@"消息列表"];
    [self addButtonWithImageName:@"fanhui" target:self action:@selector(dismissViewController) position:POSLeft];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureUI
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"FZMessageListCell" bundle:nil]
         forCellReuseIdentifier:@"FZMessageListCell"];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addHeaderWithCallback:^{
        [weakSelf requestMessageListData];
    }];
    
    self.waitingView = [[FZWaitingView alloc] init];
    [self.view addSubview:self.waitingView];
}

- (void)requestMessageListData
{
    [[FZRequestManager manager] getMessageList:
     ^(BOOL success, NSString *newMessageNum, NSArray *listArray, id responseObject) {
         [self.waitingView hide];
         
         if (success) {
             [self.dataArray removeAllObjects];
             
             for (NSDictionary *messageDict in listArray) {
                 FZMessageModel *model = [[FZMessageModel alloc] init];
                 [model setValuesForKeysWithDictionary:messageDict];
                 [self.dataArray addObject:model];
             }
             
             [self.tableView reloadData];
         }
         
         [self.tableView headerEndRefreshing];
    }];
}

#pragma mark - Response events -

- (void)dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view delegate -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        FZAllCommentsViewController *allCommentsViewController = [[FZAllCommentsViewController alloc] init];
        [self.navigationController pushViewController:allCommentsViewController animated:YES];
        
        return;
    }
    if (indexPath.row == 1) {
        FZOfficialViewController *officalViewController = [[FZOfficialViewController alloc] init];
        [self.navigationController pushViewController:officalViewController animated:YES];
        
        return;
    }
    
    FZMessageListCell *messageCell = (FZMessageListCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    FZMessageModel *messageModel = [self.dataArray objectAtIndex:indexPath.row - 2];
    FZChattingViewController *messageViewController = [[FZChattingViewController alloc] init];
    messageViewController.house_id = messageModel.house_id;
    messageViewController.house_type = messageModel.house_type;
    messageViewController.sender_id = messageModel.sender_id;
    messageViewController.partnerImage = messageCell.headerImageView.image;
    [self.navigationController pushViewController:messageViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

#pragma mark - Table view data source -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FZMessageListCell *listCell = [tableView dequeueReusableCellWithIdentifier:@"FZMessageListCell"];

    if (indexPath.row == 0) {
        listCell.headerImageView.image = [UIImage imageNamed:@"pinglun_btn"];
        listCell.nameLabel.text = @"评论";
        listCell.contentLabel.text = @"点击查看所有评论";
        dateExchange([[NSDate date] timeIntervalSince1970], listCell.dateLabel.text);
    }
    else if (indexPath.row == 1) {
        listCell.headerImageView.image = [UIImage imageNamed:@"officialLogo"];
        listCell.nameLabel.text = @"房主儿网官方";
        listCell.contentLabel.text = @"您好，很高兴您能使用房主儿网App，有什么问题可以直接在这里进行提问，我们会帮您解决所有问题。";
        dateExchange([[NSDate date] timeIntervalSince1970], listCell.dateLabel.text);
    }
    else {
        FZMessageModel *model = [self.dataArray objectAtIndex:indexPath.row - 2];
        [listCell configureCellWithMessageModel:model];
    }
    
    return listCell;
}


@end
