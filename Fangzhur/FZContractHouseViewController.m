//
//  FZContractHouseViewController.m
//  Fangzhur
//
//  Created by --超-- on 14/12/4.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZContractHouseViewController.h"
#import "ZCDropDownList.h"
#import "FZContractTipViewController.h"
#import "FZContractViewController.h"
#import "FZContractListCell.h"

@interface FZContractHouseViewController ()

@property (nonatomic, strong) ZCDropDownList *dropDownList;
@property (nonatomic, copy) NSString *hosueType;

@end

@implementation FZContractHouseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.requestArray addObject:@"Contract"];
    self.houseType = @"1";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController performSelector:@selector(addTitle:) withObject:@"收藏房源"];
    self.navigationItem.rightBarButtonItems = nil;
    [self addListItem];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.dropDownList hide];
    [self showNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Override methods -

- (void)configureUI
{
    [super configureUI];
    
    [self.bottomButton removeFromSuperview];
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
    FZContractViewController *contractViewController = [[FZContractViewController alloc] init];
    contractViewController.houseType = self.houseType;
    contractViewController.houseNumber = [sender titleForState:UIControlStateDisabled];
    [self.navigationController pushViewController:contractViewController animated:YES];
}

- (void)gotoNextView
{
    FZContractTipViewController *contractTipViewController = [[FZContractTipViewController alloc] init];
    [self.navigationController pushViewController:contractTipViewController animated:YES];
}

- (void)popViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - New methods -

- (void)addListItem
{
    self.dropDownList = [[ZCDropDownList alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 75, 12, 60, 27)
                                                 defaultTitle:@"出租"
                                                         list:@[@"出租", @"出售"]];
    [self.dropDownList addTarget:self action:@selector(changeHouseType:)];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:self.dropDownList];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)changeHouseType:(ZCDropDownList *)sender
{
    if (sender.willShow) {
        return;
    }
    
    if (sender.selectedIndex == 0) {
        self.houseType = @"1";
    }
    else {
        self.houseType = @"2";
    }
    
    [self headerRefreshing];
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

@end
