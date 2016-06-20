//
//  FZRentListViewController.m
//  Fangzhur
//
//  Created by --超-- on 15/1/20.
//  Copyright (c) 2015年 Zc. All rights reserved.
//

#import "FZRentListViewController.h"
#import "FZContractListCell.h"
#import "FZPaymentFirstViewController.h"

@interface FZRentListViewController ()

- (void)configureNavigationBar;

@end

@implementation FZRentListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.requestArray addObject:@"Contract"];
    self.houseType = @"1";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configureNavigationBar];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self showNavigationBar];
}

- (void)configureNavigationBar
{
    [self.navigationController performSelector:@selector(addTitle:) withObject:@"收藏房源"];
    [self addButtonWithImageName:@"fanhui" target:self action:@selector(backButtonClicked) position:POSLeft];
    self.navigationItem.rightBarButtonItems = nil;
}

#pragma mark - Override methods -

- (void)configureUI
{
    [super configureUI];
    [self.bottomButton setTitle:@"付房租" forState:UIControlStateNormal];
    [self.view bringSubviewToFront:self.bottomButton];
    [self.tableView removeFooter];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"FZContractListCell" bundle:nil]
         forCellReuseIdentifier:@"FZContractListCell"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 340 + kAdjustScale;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FZContractListCell *listCell = [tableView dequeueReusableCellWithIdentifier:@"FZContractListCell"];
    [listCell configureCellWithModel:[self.dataArray objectAtIndex:indexPath.row] location:self.currentLocation];
    [listCell.signButton setTitle:@"现在去支付" forState:UIControlStateNormal];
    [listCell.signButton addTarget:self action:@selector(gotoSignAContract:) forControlEvents:UIControlEventTouchUpInside];
    
    return listCell;
}


- (void)headerRefreshing
{
    [[FZRequestManager manager] getHouseListWithOption:self.requestArray houseType:self.houseType sortType:nil page:0 complete:^(NSArray *houseListArray) {
        [self.dataArray removeAllObjects];
        
        if (!houseListArray) {
            [self.tableView headerEndRefreshing];
            [self.waitingView loadingFailedWithImage:[UIImage imageNamed:@"Favourite"] handler:^{
                [self headerRefreshing];
            }];
        }
        else {
            for (NSDictionary *listDict in houseListArray) {
                FZHouseListModel *model = [[FZHouseListModel alloc] init];
                [model setValue:[listDict objectForKey:@"id"] forKey:@"houseID"];
                [model setValue:self.houseType forKey:@"houseType"];
                [model setValuesForKeysWithDictionary:listDict];
                [self.dataArray addObject:model];
            }
            
            [self.waitingView hide];
        }
        
        [self.tableView reloadData];
        [JDStatusBarNotification dismissAfter:1];
        [self.tableView headerEndRefreshing];
    }];
}

- (void)gotoSignAContract:(UIButton *)sender
{
    FZNavigationController *navController = (FZNavigationController *)self.presentingViewController;
    FZPaymentFirstViewController *firstController =
    (FZPaymentFirstViewController *)navController.viewControllers.lastObject;
    [firstController loadHouseDataWithHouseNumber:[sender titleForState:UIControlStateDisabled]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)gotoNextView
{
    FZPaymentFirstViewController *firstController = [[FZPaymentFirstViewController alloc] init];
    [self.navigationController pushViewController:firstController animated:YES];
}

- (void)backButtonClicked
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
