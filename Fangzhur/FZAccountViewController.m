//
//  FZAccountViewController.m
//  Fangzhur
//
//  Created by --超-- on 14/12/8.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZAccountViewController.h"
#import "FZUserInfoView.h"
#import "FZAccountCell.h"

@interface FZAccountViewController ()

- (void)configureUI;

@end

@implementation FZAccountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self configureUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController performSelector:@selector(addTitle:) withObject:@"我的账户"];
    [self addButtonWithImageName:@"fanhui" target:self action:@selector(popViewController) position:POSLeft];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureUI
{
    FZUserInfoView *userInfoView = [[[NSBundle mainBundle] loadNibNamed:@"FZUserInfoView" owner:self options:nil] lastObject];
    [userInfoView.helpButton removeFromSuperview];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FZAccountCell" bundle:nil]
         forCellReuseIdentifier:@"FZAccountCell"];
    
    self.tableView.tableHeaderView = userInfoView;
    self.tableView.rowHeight = 44;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Table view delegate -

#pragma mark - Table view data source -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FZAccountCell *accountCell = [self.tableView dequeueReusableCellWithIdentifier:@"FZAccountCell"];
    if (indexPath.row == 0) {
        accountCell.priceLabel.text = FZUserInfoWithKey(Key_UserCash);
        accountCell.titleLabel.text = @"现金账户";
    }
    else {
        accountCell.priceLabel.text = FZUserInfoWithKey(Key_UserTickets);
        accountCell.titleLabel.text = @"房码";
    }
    
    return accountCell;
}


#pragma mark - Response events -

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
