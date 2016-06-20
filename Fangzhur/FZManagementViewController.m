//
//  FZManagementViewController.m
//  Fangzhur
//
//  Created by --超-- on 14-7-19.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZManagementViewController.h"
#import "FZHouseDetailModel.h"
#import "FZDealViewController.h"
#import "ZCDropDownList.h"

@interface FZManagementViewController ()
{
    FZOrderMenuBar *_topMenu;
    ZCDropDownList *_listItem;
    FZHTTPRequest *_request;
    NSString *_houseType;//房源类型
    NSMutableArray *_dataArray;
    
    NSInteger _currentPage;
    NSString *_houseID;
}

@property (nonatomic, strong) FZWaitingView *waitingView;
@property (nonatomic, assign) __block NSInteger currenChannel;

- (void)UIConfig;
- (void)prepareData;
- (void)loadDataWithTag:(NSInteger)tag Channel:(NSInteger)channel action:(NSString *)action;

@end

@implementation FZManagementViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareData];
    [self UIConfig];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController performSelector:@selector(addTitle:) withObject:@"房源管理"];
    [self addButtonWithImageName:@"fanhui" target:self action:@selector(backToPersonalCenter) position:POSLeft];
    [self loadDataWithTag:0 Channel:self.currenChannel action:@"list"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_listItem hide];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareData
{
    _currentPage = 1;
    _dataArray = [[NSMutableArray alloc] init];
    _houseType = @"1";
}

- (void)UIConfig
{
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
    bgImageView.image        = [UIImage imageNamed:@"HuaDtiao"];
    [self.view addSubview:bgImageView];
    _topMenu = [[FZOrderMenuBar alloc] init];
    _topMenu.titleArray = [NSArray arrayWithObjects:@"已发布", @"待审核", @"已过期", @"已成交", @"未通过", @"已下架", nil];
    [_topMenu changeChannel:^(NSUInteger index) {
        self.currenChannel = index;
        
        [self loadDataWithTag:0 Channel:index action:@"list"];
        [self reloadView];
    }];
    [_topMenu installMenuInView:self.view];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FZManagementCell" bundle:nil] forCellReuseIdentifier:@"FZManagementCell"];
    self.tableView.frame = CGRectMake(0, 44 + 64, SCREEN_WIDTH, SCREEN_HEIGHT - 108);
    self.tableView.backgroundColor = RGBColor(230, 230, 230);
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addHeaderWithCallback:^{
        [weakSelf loadDataWithTag:0 Channel:weakSelf.currenChannel action:@"list"];
    }];
    
    [self addListItem];
    
    self.waitingView = [[FZWaitingView alloc] init];
    [self.view addSubview:self.waitingView];
}

- (void)addListItem
{
    _listItem = [[ZCDropDownList alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 75, 12, 60, 27)
                                         defaultTitle:@"出租"
                                                 list:@[@"出租", @"出售"]];
    [_listItem addTarget:self action:@selector(changeListType:)];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:_listItem];
    self.navigationItem.rightBarButtonItem = buttonItem;
}


- (void)backToPersonalCenter
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeListType:(ZCDropDownList *)list
{
    if (list.willShow) {
        return;
    }
    
    [self reloadView];
    if (list.selectedIndex == 0) {
        _houseType = @"1";
    }
    else {
        _houseType = @"2";
    }
    
    [self loadDataWithTag:0 Channel:self.currenChannel action:@"list"];
}

- (void)reloadView
{
    [UIView animateWithDuration:0.15 animations:^{
        self.tableView.alpha = 0;
    } completion:^(BOOL finished) {
    }];
    
    if (_dataArray.count == 0) {
        return;
    }
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
}

#pragma mark - 网络请求 -

- (void)loadDataWithTag:(NSInteger)tag Channel:(NSInteger)channel action:(NSString *)action
{
    if (tag == 0) {
        [_dataArray removeAllObjects];
    }
    
    if ([_houseType isEqualToString:@"1"]) {
        _request   = [[FZHTTPRequest alloc] initWithURLString:URLStringByAppending(kRentManagement) cacheInterval:0];
    }
    else {
        _request   = [[FZHTTPRequest alloc] initWithURLString:URLStringByAppending(kSaleManagement) cacheInterval:0];
    }
    _request.tag = tag;
    [_request addTarget:self action:@selector(requestFinished:)];
    if ([action isEqualToString:@"list"]) {
        [_request startPostWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
                                           action, @"action",
                                           [NSString stringWithFormat:@"%d", (channel + 1)], @"type",
                                           FZUserInfoWithKey(Key_LoginToken), @"token",
                                           FZUserInfoWithKey(Key_UserName), @"username",
                                           FZUserInfoWithKey(Key_MemberID), @"member_id", nil]];
    }
    else {
        [_request startPostWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
                                           action, @"action",
                                           _houseID, @"id",
                                           [NSString stringWithFormat:@"%d", (channel + 1)], @"type",
                                           FZUserInfoWithKey(Key_LoginToken), @"token",
                                           FZUserInfoWithKey(Key_UserName), @"username",
                                           FZUserInfoWithKey(Key_MemberID), @"member_id", nil]];
    }
}

- (void)requestFinished:(FZHTTPRequest *)request
{
    [self.waitingView hide];
    [self.tableView headerEndRefreshing];
    
    [UIView animateWithDuration:0.8 animations:^{
        self.tableView.alpha = 1;
    }];
    
    if (request.error) {
        return;
    }
    
    if (request.downloadedData) {
        id resultData = [NSJSONSerialization JSONObjectWithData:request.downloadedData options:NSJSONReadingMutableContainers error:nil];
        if ([resultData isKindOfClass:[NSDictionary class]]) {
            NSDictionary *resultDict = (NSDictionary *)resultData;
            NSLog(@"房源管理%@", resultDict);
            
            if (request.tag == 0) {//请求列表数据
                NSArray *listArray = [resultDict objectForKey:@"fanhui"];
                
                for (NSDictionary *infoDict in listArray) {
                    FZHouseDetailModel *model = [[FZHouseDetailModel alloc] init];
                    model.houseID = [infoDict objectForKey:@"id"];
                    model.houseType = _houseType;
                    [model setValuesForKeysWithDictionary:infoDict];
                    [_dataArray addObject:model];
                }
            }
            else if (request.tag == 1) {//刷新
                if ([[resultDict objectForKey:@"fanhui"] intValue] == 1) {
                    [JDStatusBarNotification showWithStatus:@"房源已刷新" dismissAfter:2];
                    [self loadDataWithTag:0 Channel:self.currenChannel action:@"list"];
                }
                else {
                    [JDStatusBarNotification showWithStatus:@"请不要进行频繁刷新!" dismissAfter:2];
                }
            }
            else if (request.tag == 3) {//下架
                if ([[resultDict objectForKey:@"fanhui"] intValue] == 1) {
                    [JDStatusBarNotification showWithStatus:@"该房源已下架" dismissAfter:2];
                    [self loadDataWithTag:0 Channel:self.currenChannel action:@"list"];
                }
                else {
                    [JDStatusBarNotification showWithStatus:@"下架失败，请稍后重试!" dismissAfter:2 styleName:JDStatusBarStyleError];
                }
            }
            
            [self.tableView reloadData];
        }
        else {
            NSLog(@"%@", [[NSString alloc] initWithData:request.downloadedData encoding:NSUTF8StringEncoding]);
        }
    }
}

#pragma mark - Table view delegate -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.currenChannel == 0) {
        return 210;
    }
    else if (self.currenChannel == 2) {
        return 220;
    }
    
    return 160;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FZManagementCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FZManagementCell"];
    cell.delegate = self;
    [cell fillDataWithType:_houseType Model:[_dataArray objectAtIndex:indexPath.row]];
    
    if (self.currenChannel == 2) {//已过期
        cell.buttonView.hidden  = YES;
        cell.againButton.hidden = NO;
        CGRect frame = cell.bgView.frame;
        frame.size.height = 205;
        cell.bgView.frame = frame;
    }
    else if(self.currenChannel == 0){
        cell.buttonView.hidden  = NO;
        cell.againButton.hidden = YES;
        CGRect frame = cell.bgView.frame;
        frame.size.height = 195;
        cell.bgView.frame = frame;

    }
    else {
        cell.buttonView.hidden = YES;
        CGRect frame = cell.bgView.frame;
        frame.size.height = 150;
        cell.bgView.frame = frame;
    }
    [self tableView:tableView heightForRowAtIndexPath:indexPath];
    
    return cell;
}

//=========================

- (void)manageReleasedHouse:(NSString *)houseID selectedIndex:(NSUInteger)index
{
    _houseID = houseID;
    
    switch (index) {
        case 1: {//刷新
            [self loadDataWithTag:index Channel:self.currenChannel action:@"refresh"];
        }
            break;
        case 2: {//成交
            FZDealViewController *dealController = [[FZDealViewController alloc] init];
            dealController.houseType = _houseType;
            dealController.houseID   = _houseID;
            [self.navigationController pushViewController:dealController animated:YES];
        }
            break;
        case 3: {//下架
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"是否确认下架该房源?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            alertView.delegate = self;
            alertView.tag = index;
            [alertView show];
        }
            break;
        case 4: {//修改
//            FZReleaseHousesViewController *releaseController = [[FZReleaseHousesViewController alloc] init];
//            [self.navigationController pushViewController:releaseController animated:YES];
        }
            break;
    }
}

- (void)releaseAgain:(NSString *)houseID
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"是否确认重新发布该房源?\n(申请成功后，请到待审核的房源中查看)" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alertView.delegate = self;
    [alertView show];
}

#pragma mark - Alert view delegate -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (alertView.tag == 3) {//下架请求
            [self loadDataWithTag:3 Channel:self.currenChannel action:@"notsell"];
            
        }
        else {
            [self loadDataWithTag:5 Channel:self.currenChannel action:@"onsell"];
        }
    }
}

@end
