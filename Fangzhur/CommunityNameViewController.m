//
//  SearchResultViewController.m
//  base
//
//  Created by isabella tong on 14-2-10.
//  Copyright (c) 2014年 wbw. All rights reserved.
//

#import "CommunityNameViewController.h"

@interface CommunityNameViewController ()
{
    __block NSMutableArray *_searchArray;
    __block NSArray *_dataArray;
}

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation CommunityNameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _searchArray = [[NSMutableArray alloc] init];
    _dataArray = [[NSArray alloc] init];

    [self addButtonWithImageName:@"fanhui" target:self action:@selector(backToReleaseHouse) position:POSLeft];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(80, 7, SCREEN_WIDTH - 140, 30)];
    self.searchBar.delegate = self;
    self.searchBar.backgroundColor = [UIColor clearColor];
    self.searchBar.placeholder = @"小区名或地区名";
    [self.searchBar becomeFirstResponder];
    
    UIImageView *searchBarBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_xiahuaxian"]];
    searchBarBgView.frame = CGRectMake(80, 33, SCREEN_WIDTH - 140, 3);
    
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicatorView.frame = CGRectMake(SCREEN_WIDTH - 60, 0, 44, 44);
    [self.indicatorView stopAnimating];
    
    [self.navigationController performSelector:@selector(setCustomView:) withObject:self.searchBar];
    [self.navigationController performSelector:@selector(setCustomView:) withObject:searchBarBgView];
    [self.navigationController performSelector:@selector(setCustomView:) withObject:self.indicatorView];
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CommunityCell"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.searchBar resignFirstResponder];
}

#pragma mark - Response events -

- (void)backToReleaseHouse
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
    [self searchCommunitiesWithKey:searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self searchCommunitiesWithKey:searchText];
}


#pragma mark ============================================= tableView的代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommunityCell"];

    if (_searchArray.count != 0) {
        cell.textLabel.text = [_searchArray objectAtIndex:indexPath.row];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.searchBar resignFirstResponder];
    
    NSDictionary *dic = [_dataArray objectAtIndex:indexPath.row];
    [self dismissViewControllerAnimated:YES completion:^{
        [_nameDelegate selectCommunityName:[_searchArray objectAtIndex:indexPath.row] communityID:[dic objectForKey:@"id"] address:[dic objectForKey:@"borough_address"]];
    }];
}

#pragma mark - Go to search -

- (void)searchCommunitiesWithKey:(NSString *)key
{
    [self.indicatorView startAnimating];
    
    [[FZRequestManager manager] getCommunitiesWithKey:key complete:^(NSArray *communityArray) {
        [self.indicatorView stopAnimating];
        _dataArray = communityArray;
        [_searchArray removeAllObjects];
        
        for (int i = 0; i < _dataArray.count; i++) {
            NSDictionary *dic = [_dataArray objectAtIndex:i];
            NSString *name = [dic objectForKey:@"borough_name"];
            [_searchArray addObject:name];
        }
        
        [self.tableView reloadData];
    }];
}


@end
