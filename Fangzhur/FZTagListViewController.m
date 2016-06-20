//
//  FZTagListViewController.m
//  Fangzhur
//
//  Created by --超-- on 14/11/17.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZTagListViewController.h"
#import "FZSearchViewController.h"
#import "FZHouseListViewController.h"
#import "FZTagListCell.h"
#import "FZTagModel.h"

@interface FZTagListViewController ()

@property (nonatomic, strong) FZTagModel *tagModel;

- (void)configureUI;

@end

@implementation FZTagListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tagModel = [[FZTagModel alloc] init];
    [self configureUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController performSelector:@selector(addTitle:) withObject:[NSString stringWithFormat:@"    %@", FZUserInfoWithKey(Key_CityName)]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureUI
{
    UIButton *backButton = [self addButtonWithImageName:@"fanhui_brn" target:self action:@selector(popTagListViewController) position:POSLeft];
    backButton.contentMode = UIViewContentModeLeft;
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    [self addButtonWithImageName:@"sousuo" target:self action:@selector(jumpToSearchView) position:POSRight];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"FZTagListCell" bundle:nil] forCellReuseIdentifier:@"FZTagListCell"];
}

#pragma mark - Table view delegate -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FZHouseListViewController *houseListViewController = [[FZHouseListViewController alloc] init];
    houseListViewController.tagName = [self.tagModel.tagArray objectAtIndex:indexPath.row * 2 + 1];
    [houseListViewController.requestArray addObject:[NSString stringWithFormat:@"%d", [[tableView cellForRowAtIndexPath:indexPath] tag]]];
    [houseListViewController.requestArray addObject:FZUserInfoWithKey(Key_MemberID)];
    if (indexPath.row == 0) {
        [houseListViewController.requestArray addObject:@"PersonalCustom"];
    }
    else {
        [houseListViewController.requestArray addObject:@"Tag"];
    }
    houseListViewController.houseType = self.houseType;
    
    FZNavigationController *navController = [[FZNavigationController alloc] initWithRootViewController:houseListViewController];
    [self presentViewController:navController animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 221 + kAdjustScale;
}

#pragma mark - Table view data source -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tagModel.tagArray.count / 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FZTagListCell *tagCell = [tableView dequeueReusableCellWithIdentifier:@"FZTagListCell"];
    tagCell.tag = [[self.tagModel.tagArray objectAtIndex:indexPath.row * 2] integerValue];
    [tagCell configureCellWithTagID:[self.tagModel.tagArray objectAtIndex:indexPath.row * 2]
                            tagName:[self.tagModel.tagArray objectAtIndex:indexPath.row * 2 + 1]];
    
    return tagCell;
}

#pragma mark - 响应事件 -

- (void)popTagListViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)jumpToSearchView
{
    FZSearchViewController *searchViewController = [[FZSearchViewController alloc] init];
    FZNavigationController *navController = [[FZNavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:navController animated:YES completion:nil];
}

@end
