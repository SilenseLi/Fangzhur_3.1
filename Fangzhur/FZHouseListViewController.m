//
//  FZHouseListViewController.m
//  Fangzhur
//
//  Created by --超-- on 14/11/8.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZHouseListViewController.h"
#import "FZScreenViewController.h"
#import "MJRefresh.h"
#import "FZLocationModel.h"
#import "FZHouseDetailViewController.h"

@interface FZHouseListViewController ()

@property (nonatomic, strong) FZLocationModel *locationModel;
@property (nonatomic, copy) NSString *sortType;
@property (nonatomic, assign) NSInteger page;

@end

@implementation FZHouseListViewController

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.requestArray = [[NSMutableArray alloc] init];
        self.dataArray = [[NSMutableArray alloc] init];
        self.sortType = @"";
        self.locationModel = [FZLocationModel model];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureUI];
    
    if ([self.requestArray.lastObject isEqualToString:@"Search"] && self.requestArray.count == 3) {
        [self sortHousesByDistance];
    }
    else {
        [self.tableView headerBeginRefreshing];
    }
    
    [self.locationModel getCurrentLocation:^(BOOL success, CLLocation *currentLocation) {
        if (success) {
            self.currentLocation = currentLocation;
            [self.tableView reloadData];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self showNavigationBar];
    [self configureNavigationBar];
    
    if (self.navigationItem.rightBarButtonItems.count != 2) {
        return;
    }
    
    //恢复排序按钮默认非选中状态
    for (UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
        UIButton *itemButton = (UIButton *)item.customView;
        if ([itemButton respondsToSelector:@selector(setSelected:)]) {
            itemButton.selected = NO;
        }
    }
    
    self.sortType = @"";
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureNavigationBar
{
    if (self.tagName) {
        [self.navigationController performSelector:@selector(addTitle:) withObject:self.tagName];
    }
    else {
        [self.navigationController performSelector:@selector(addTitle:) withObject:@"房源列表"];
    }
    [self addButtonWithImageName:@"fanhui" target:self action:@selector(popViewController) position:POSLeft];
    
    NSArray *imageNames = nil;
    if (![self.requestArray.lastObject isEqualToString:@"Search"]) {
        imageNames = @[@"btn_jiage", @"btn_weizhi"];
    }
    else {
        imageNames = @[@"btn_jiage"];
    }
    [self addButtonsWithImageNames:imageNames target:self action:@selector(sortButtonClicked:) position:POSRight];
}

- (void)configureUI
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"guide2"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"guide2"];
        [FZGuideView GuideViewWithImage:[UIImage imageNamed:@"guide2"] atView:[UIApplication sharedApplication].keyWindow];
    }
    
    self.bottomButton = kBottomButtonWithName(@"筛选");
    [self.bottomButton addTarget:self action:@selector(gotoNextView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bottomButton];
    
    //上划隐藏
    __block typeof(self) weakSelf = self;
    [self rollingBarWithScrollView:self.tableView finished:^(BOOL isRollingUp) {
        if (isRollingUp) {
            [UIView animateWithDuration:0.2 animations:^{
                CGRect frame = weakSelf.bottomButton.frame;
                frame.origin.y = SCREEN_HEIGHT;
                weakSelf.bottomButton.frame = frame;
            }];
        }
        else {
            [UIView animateWithDuration:0.2 animations:^{
                CGRect frame = weakSelf.bottomButton.frame;
                frame.origin.y = SCREEN_HEIGHT - 49;
                weakSelf.bottomButton.frame = frame;
            }];
        }
    }];
    
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"FZHouseListCell" bundle:nil] forCellReuseIdentifier:@"FZHouseListCell"];
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
    self.waitingView = [[FZWaitingView alloc] init];
    [self.view addSubview:self.waitingView];
}

#pragma mark - 开始进入刷新状态 -

- (void)headerRefreshing
{
    self.page = 1;
    
    [[FZRequestManager manager] getHouseListWithOption:self.requestArray houseType:self.houseType sortType:self.sortType page:self.page complete:^(NSArray *houseListArray)
     {
         [JDStatusBarNotification dismissAfter:1];
         [self.tableView headerEndRefreshing];
         
         if (houseListArray.count != 0) {
             [self.dataArray removeAllObjects];
             
             for (NSDictionary *listDict in houseListArray) {
                 FZHouseListModel *model = [[FZHouseListModel alloc] init];
                 [model setValue:[listDict objectForKey:@"id"] forKey:@"houseID"];
                 [model setValue:self.houseType forKey:@"houseType"];
                 [model setValuesForKeysWithDictionary:listDict];
                 [self.dataArray addObject:model];
             }
             
             if (self.sortType.length == 0) {
                 [self.dataArray setArray:[self.locationModel coordinates:self.dataArray SortedByCurrentLocation:self.currentLocation]];
             }
             
             [self.tableView reloadData];
             [self.waitingView hide];
         }
         else {
             if ([self.tagName isEqualToString:@"私人订制"]) {
                 [self.waitingView loadingFailedWithImage:[UIImage imageNamed:@"Custom"] handler:^{
                     [self headerRefreshing];
                 }];
             }
             else {
                 if ([FZUserInfoWithKey(@"CityURL") rangeOfString:@"bj"].location == NSNotFound) {
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"标签现仅对北京地区开放，其他城市尽请期待!" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                     [alertView show];
                 }
                 [self.waitingView loadingFailedWithImage:[UIImage imageNamed:@"loadFailed"] handler:^{
                     [self headerRefreshing];
                 }];
             }
         }
     }];
}

- (void)footerRefreshing
{
    [[FZRequestManager manager] getHouseListWithOption:self.requestArray houseType:self.houseType sortType:self.sortType page:++self.page complete:^(NSArray *houseListArray)
     {
         for (NSDictionary *listDict in houseListArray) {
             FZHouseListModel *model = [[FZHouseListModel alloc] init];
             [model setValue:[listDict objectForKey:@"id"] forKey:@"houseID"];
             [model setValue:self.houseType forKey:@"houseType"];
             [model setValuesForKeysWithDictionary:listDict];
             [self.dataArray addObject:model];
         }
         if ([self.requestArray.lastObject isEqualToString:@"Search"] &&
             [self.sortType hasPrefix:@"price"] == NO) {
             [self.dataArray setArray:[self.locationModel coordinates:self.dataArray SortedByCurrentLocation:self.currentLocation]];
         }
         [self.tableView reloadData];
         [self.tableView footerEndRefreshing];
     }];
}

- (void)sortHousesByDistance
{
    [[FZRequestManager manager] getHouseListWithOption:self.requestArray houseType:self.houseType sortType:self.sortType page:1 complete:^(NSArray *houseListArray)
     {
         [self.dataArray removeAllObjects];
         [self.waitingView hide];
         
         for (NSDictionary *listDict in houseListArray) {
             FZHouseListModel *model = [[FZHouseListModel alloc] init];
             [model setValue:[listDict objectForKey:@"id"] forKey:@"houseID"];
             [model setValue:self.houseType forKey:@"houseType"];
             [model setValuesForKeysWithDictionary:listDict];
             [self.dataArray addObject:model];
         }
         
         [self.dataArray setArray:[self.locationModel coordinates:self.dataArray SortedByCurrentLocation:self.currentLocation]];
         [self.tableView reloadData];
         [JDStatusBarNotification dismissAfter:1];
         [self.tableView scrollRectToVisible:CGRectMake(0, 0, SCREEN_WIDTH, 1) animated:YES];
     }];
}

#pragma mark - Table view delegate -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showNavigationBar];
    
    FZHouseListCell *listCell = (FZHouseListCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSInteger clickNumber = [listCell.listModel.click_num integerValue];
    listCell.listModel.click_num = [NSString stringWithFormat:@"%d", (int)++clickNumber];
    
    FZHouseDetailViewController *detailController = [[FZHouseDetailViewController alloc] init];
    
    detailController.houselistType = self.requestArray.lastObject;
    detailController.detailModel.houseType = self.houseType;
    detailController.houseType = self.houseType;
    NSInteger houseID = [[tableView cellForRowAtIndexPath:indexPath] tag];
    detailController.detailModel.houseID = [NSString stringWithFormat:@"%d", (int)houseID];
    detailController.detailModel.houseTitle = listCell.HouseInfoLabel.text;
    detailController.detailModel.releaseDate = listCell.dateLabel.text;
    detailController.detailModel.latitude = listCell.listModel.lng;
    detailController.detailModel.longitude = listCell.listModel.lat;
    detailController.detailModel.tag_id = listCell.listModel.tag_id;
    
    [self.navigationController pushViewController:detailController animated:YES];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300 + kAdjustScale;
}

#pragma mark - Table view data source -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FZHouseListCell *listCell = [tableView dequeueReusableCellWithIdentifier:@"FZHouseListCell"];
    [listCell configureCellWithModel:[self.dataArray objectAtIndex:indexPath.row] location:self.currentLocation];
    [listCell.signButton addTarget:self action:@selector(gotoSignAContract:) forControlEvents:UIControlEventTouchUpInside];
    
    return listCell;
}

#pragma mark - 响应事件 -

- (void)sortButtonClicked:(UIButton *)sender
{
    [self.tableView scrollRectToVisible:CGRectMake(0, 64, SCREEN_WIDTH, 1) animated:YES];
    
    if (!sender.selected) {
        sender.selected = YES;
        if (self.navigationItem.rightBarButtonItems.count == 2) {
            UIBarButtonItem *anotherButtonItem = [self.navigationItem.rightBarButtonItems objectAtIndex:(sender.tag * -1 + 1)];
            UIButton *anotherButton = (UIButton *)anotherButtonItem.customView;
            anotherButton.selected = NO;
        }
    }
    
    // 1升序 -1降序
    static NSInteger orderTag = -1;
    
    //TODO:按位置排序
    if (sender.tag == 1) {
        [self.locationModel getCurrentLocation:^(BOOL success, CLLocation *currentLocation) {
            if (!success) {
                sender.selected = NO;
                [JDStatusBarNotification showWithStatus:@"定位服务没有打开!" dismissAfter:2 styleName:JDStatusBarStyleError];
                [self.tableView reloadData];
                return;
            }
            else {
                self.sortType = @"distance";
                self.currentLocation = currentLocation;
                
                [JDStatusBarNotification showWithStatus:@"疯狂加载中..." styleName:JDStatusBarStyleDark];
                [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleWhite];
                [self sortHousesByDistance];
            }
        }];
    }
    //TODO:按价格排序
    else {
        orderTag *= -1;
        if (orderTag > 0) {
            self.sortType = @"price_inc";
        }
        else {
            self.sortType = @"price_desc";
        }
        
        [JDStatusBarNotification showWithStatus:@"疯狂加载中..." styleName:JDStatusBarStyleDark];
        [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self headerRefreshing];
    }
}

- (void)gotoSignAContract:(UIButton *)sender
{

}

- (void)popViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)gotoNextView
{
    FZScreenViewController *screenViewController = [[FZScreenViewController alloc] init];
    screenViewController.screenType = self.houseType;
    screenViewController.bindsController = self;
    FZNavigationController *navController = [[FZNavigationController alloc] initWithRootViewController:screenViewController];
    [self presentViewController:navController animated:YES completion:nil];
}

@end
