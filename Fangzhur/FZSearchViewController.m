//
//  FZSearchViewController.m
//  Fangzhur
//
//  Created by --超-- on 14/11/7.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZSearchViewController.h"
#import "ZCDropDownList.h"
#import "FZSearchHistoryModel.h"
#import "FZHouseListViewController.h"
#import "FZChangeCityViewController.h"

#define HouseListWithRequestArray(array)\
FZHouseListViewController *listViewController = [[FZHouseListViewController alloc] init];\
listViewController.houseType = self.searchType;\
[listViewController.requestArray setArray:array];\
FZNavigationController *navController = [[FZNavigationController alloc] initWithRootViewController:listViewController];\
[self presentViewController:navController animated:YES completion:nil]


@interface FZSearchViewController ()

@property (nonatomic, strong) ZCDropDownList *dropDownList;
@property (nonatomic, strong) FZSearchHeaderView *searchHeader;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, copy) NSString *searchType;
@property (nonatomic, strong) FZSearchHistoryModel *historyModel;

- (void)configureUI;

@end

@implementation FZSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.historyModel = [[FZSearchHistoryModel alloc] init];
    self.searchType = @"1"; //默认是出租
    [self configureUI];
    
    [self.historyModel newestHistoryFromDatabase];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.dropDownList hide];
    [self.historyModel storeInDatabase];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureUI
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"guide5"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"guide5"];
        [FZGuideView GuideViewWithImage:[UIImage imageNamed:@"guide5"] atView:[UIApplication sharedApplication].keyWindow];
    }
    
    [self addButtonWithImageName:@"fanhui" target:self action:@selector(dismissPersonalCenter:) position:POSLeft];
    self.dropDownList = [[ZCDropDownList alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 75, 9, 60, 27)
                                                        Image:[UIImage imageNamed:@"searchTypeBg"]
                                                         list:@[@"出租", @"出售"]];
    [self.dropDownList addTarget:self action:@selector(changeSearchType:)];
    [self.navigationController performSelector:@selector(setCustomView:) withObject:self.dropDownList];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake((kScreenScale - 2) * 10 + 60, 7, 180 + ((kScreenScale - 2) * 80), 30)];
    self.searchBar.delegate = self;
    self.searchBar.backgroundColor = [UIColor clearColor];
    self.searchBar.placeholder = @"发现新生活";
    [self.navigationController performSelector:@selector(setCustomView:) withObject:self.searchBar];
    
    UIImageView *searchBarBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_xiahuaxian"]];
    searchBarBgView.frame = CGRectMake((kScreenScale - 2) * 10 + 60, 33, CGRectGetWidth(self.searchBar.bounds), 3);
    [self.navigationController performSelector:@selector(setCustomView:) withObject:searchBarBgView];
    
    self.searchHeader = [[FZSearchHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
    self.searchHeader.delegate = self;
    self.tableView.tableHeaderView = self.searchHeader;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HistoryCell"];
}


#pragma mark - Table view delegate -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self tableviewTapped];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    HouseListWithRequestArray((@[selectedCell.textLabel.text, @"Search"]));
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.historyModel.historyArray.count;
}

#pragma mark - Table view data source -

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *historyCell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell"];
    
    historyCell.textLabel.text = [self.historyModel.historyArray objectAtIndex:indexPath.row];
    historyCell.textLabel.textColor = [UIColor lightGrayColor];
    historyCell.textLabel.font = [UIFont fontWithName:kFontName size:15];
    
    return historyCell;
}


#pragma mark - 响应事件 -

- (void)dismissPersonalCenter:(UIButton *)sender
{
    [self.searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)changeSearchType:(ZCDropDownList *)list
{
    if (list.willShow == YES) {
        return;
    }
    
    self.searchType = [NSString stringWithFormat:@"%d", (int)list.selectedIndex + 1];
}

- (void)tableviewTapped
{
    [self.searchBar resignFirstResponder];
    [self.dropDownList hide];
    self.searchBar.text = @"";
}

#pragma mark - Search bar delegate -

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    //TODO:空字符串处理
    if (searchBar.text.length == 0) {
        [JDStatusBarNotification showWithStatus:@"请输入正确的内容" dismissAfter:2 styleName:JDStatusBarStyleError];
    }
    else {
        [self.searchBar resignFirstResponder];
        [self.historyModel addHistory:searchBar.text];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        
        HouseListWithRequestArray((@[self.searchBar.text, @"Search"]));
    }
    
    searchBar.text = @"";
}

#pragma mark - Search bar header delegate -

- (void)searchHeaderView:(FZSearchHeaderView *)headerView completedLocation:(CLLocationCoordinate2D)coordinate
{
    HouseListWithRequestArray((@[@(coordinate.longitude), @(coordinate.latitude), @"Search"]));
}

- (void)changeCityButtonClicked
{
    FZChangeCityViewController *cityViewController = [[FZChangeCityViewController alloc] init];
    FZNavigationController *navController = [[FZNavigationController alloc] initWithRootViewController:cityViewController];
    [navController addTitle:@"切换城市"];
    
    [self presentViewController:navController animated:YES completion:nil];
}

@end
