//
//  FZOrdersViewController.m
//  Fangzhur
//
//  Created by --超-- on 14/12/8.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZOrdersViewController.h"
#import "FZOrderMenuBar.h"
#import "ZCDropDownList.h"
#import "FZLoginViewController.h"
#import "FZInformViewController.h"
#import "FZCompleteViewController.h"

@interface FZOrdersViewController ()
{
    ZCDropDownList *_listItem;
    FZOrderMenuBar *_topMenu;
    NSInteger _currentChannel;
    NSInteger _currentPage;
    NSInteger _currentSubType;//0 全部 1 出租 2 出售
}

@property (nonatomic, strong) NSMutableArray *cellArray;

- (void)UIConfig;
//subType:0 全部 1 出租 2 出售
- (void)loadDataWithChannel:(NSInteger)index subType:(NSInteger)subType page:(NSInteger)page;
- (void)changeOrderSubtype:(ZCDropDownList *)list;

@end

@implementation FZOrdersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _currentPage = 1;
    self.cellArray = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", @"", @"", @"", nil];
    
    [self UIConfig];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController performSelector:@selector(addTitle:) withObject:@"我的订单"];
    [self addButtonWithImageName:@"fanhui" target:self action:@selector(popViewController) position:POSLeft];
    [self addListItem];
    
    if ([[self.cellArray objectAtIndex:_currentChannel] isKindOfClass:[FZOrderTableView class]]) {
        FZOrderTableView *orderCell = [self.cellArray objectAtIndex:_currentChannel];
        [orderCell.tableView scrollRectToVisible:CGRectMake(0, 0, SCREEN_WIDTH, 1) animated:YES];
    }
    
    [self loadDataWithChannel:0 subType:0 page:1];
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

- (void)UIConfig
{
    [self reverseTableView];
    self.tableView.rowHeight = 44;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
    bgImageView.image        = [UIImage imageNamed:@"HuaDtiao"];
    [self.view addSubview:bgImageView];
    _topMenu = [[FZOrderMenuBar alloc] init];
    _topMenu.titleArray = [NSArray arrayWithObjects:
                           @"全部的订单", @"发布的订单", @"进行的订单",
                           @"完成的订单", @"退款的订单", @"订单回收站", nil];
    [_topMenu addTarget:self action:@selector(changeChannel:)];
    [_topMenu installMenuInView:self.view];
    
    [self.tableView registerClass:[FZOrderTableView class] forCellReuseIdentifier:@"FZOrderTableView"];
}

- (void)addListItem
{
    _listItem = [[ZCDropDownList alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 75, 12, 60, 27)
                                         defaultTitle:@"全部"
                                                 list:@[@"全部", @"出租", @"出售"]];
    [_listItem addTarget:self action:@selector(changeOrderSubtype:)];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:_listItem];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)reloadView
{
#warning 后期完善
//    [self loadDataWithChannel:_currentChannel subType:0 page:1];
}

#pragma mark - 切换订单类型 -

- (void)changeChannel:(UIButton *)sender
{
    if (_currentChannel == sender.tag) {
        return;
    }
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    _currentChannel = sender.tag;
    [_listItem reset];
    [self loadDataWithChannel:sender.tag subType:0 page:1];
}

- (void)changeOrderSubtype:(ZCDropDownList *)list
{
    if (list.willShow) {
        return;
    }
    
    _currentSubType = list.selectedIndex;
    [self loadDataWithChannel:_currentChannel subType:list.selectedIndex page:1];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.tableView.userInteractionEnabled = YES;
    
    if (_currentChannel == (scrollView.contentOffset.y / SCREEN_WIDTH)) {
        return;
    }
    
    NSLog(@"%f", scrollView.contentOffset.y);
    _currentChannel = (scrollView.contentOffset.y / SCREEN_WIDTH);
    [_topMenu changeSelectedItem:_currentChannel];
    [self loadDataWithChannel:_currentChannel subType:0 page:1];
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 举报订单 -

- (void)informOrderWithID:(NSString *)orderId agentInfo:(NSString *)info
{
    FZInformViewController *informController = [[FZInformViewController alloc] init];
    informController.orderNum  = orderId;
    informController.agentInfo = info;
    FZNavigationController *navController = [[FZNavigationController alloc] initWithRootViewController:informController];
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - 确认完成服务 -

- (void)gotoCompleteService:(FZServingOrderCell *)cell
{
    FZCompleteViewController *completeController = [[FZCompleteViewController alloc] init];
    completeController.orderCell = [cell copy];
    completeController.orderID   = cell.orderModel.orderID;
    FZNavigationController *navController = [[FZNavigationController alloc] initWithRootViewController:completeController];
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - Table view delegate -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_WIDTH;
}

#pragma mark - Table view data source -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FZOrderTableView *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%d", indexPath.row]];
    
    if (!cell) {
        cell = [[FZOrderTableView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%d", indexPath.row]];
        cell.transform = CGAffineTransformMakeRotation(M_PI / 2);
        cell.tag = indexPath.row;
        cell.delegate = self;
    }
    
    if ([[self.cellArray objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]) {
        [self.cellArray replaceObjectAtIndex:indexPath.row withObject:cell];
    }
    
    return cell;
}

#pragma mark - 网络请求 -

- (void)loadDataWithChannel:(NSInteger)index subType:(NSInteger)subType page:(NSInteger)page
{
    NSString *type = nil;
    if (index == 4) {//退款订单
        type = @"21";
    }
    else if (index == 5) {
        type = @"10";
    }
    else {
        type = [NSString stringWithFormat:@"%d", index];
    }
    
    //=======================================================
    [[FZRequestManager manager] getOrdersWithType:type subtype:[NSString stringWithFormat:@"%d", subType] page:page complete:^(NSArray *orderArray) {
        FZOrderTableView *currentCell = [self.cellArray objectAtIndex:index];
        
        if (page == 1) {
            [currentCell.dataArray removeAllObjects];
        }
        
        if (!orderArray) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示\n-------------------------" message:@"您的账号在异地登陆\n请重新登录" delegate:self cancelButtonTitle:nil otherButtonTitles:@"去登陆", nil];
            [alertView show];
            
            FZUserInfoReset;
            return ;
        }
        
        for (NSDictionary *infoDict in orderArray) {
            FZOrdersModel *model = [[FZOrdersModel alloc] init];
            [model setValuesForKeysWithDictionary:infoDict];
            model.orderID = [infoDict objectForKey:@"id"];
            if ([infoDict objectForKey:@"rob_list"]) {
                [currentCell.agentArray addObjectsFromArray:[infoDict objectForKey:@"rob_list"]];
            }
            
            [currentCell.dataArray addObject:model];
        }
        
        [currentCell.tableView reloadData];
        [currentCell.tableView headerEndRefreshing];
        [currentCell.tableView footerEndRefreshing];
    }];
}

- (void)orderTableView:(FZOrderTableView *)cell startRefresh:(RefreshType)type
{
    if (type == DOWN) {
        [self loadDataWithChannel:_currentChannel subType:0 page:++_currentPage];
    }
    else {
        _currentPage = 1;
        [self loadDataWithChannel:_currentChannel subType:_currentSubType page:_currentPage];
    }
}


//重新登录
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    FZLoginViewController *loginController = [[FZLoginViewController alloc] init];
    [self presentViewController:loginController animated:YES completion:^{
        [self.navigationController popToRootViewControllerAnimated:NO];
    }];
}

@end
