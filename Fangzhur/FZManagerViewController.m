//
//  FZManagerViewController.m
//  Fangzhur
//
//  Created by fq on 14/12/25.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZManagerViewController.h"
#import "FZOrderMenuBar.h"
#import "FZPayManagerTableViewCell.h"
#import "FZPayBoltingModel.h"
#import "FZPayFinishViewController.h"
#import "FZPaymentFirstViewController.h"
#import "ProgressHUD.h"
#import "FZMobileLoginViewController.h"

@interface FZManagerViewController ()

@property (nonatomic, strong) FZOrderMenuBar *topMenu;
@property (nonatomic, strong) FZWaitingView *waitingView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) __block NSInteger currentChannel;

- (void)prepareData;
- (void)configureNavigationBar;
- (void)configureTopMenu;
- (void)configureTableView;

- (void)loadDataOfChannel:(NSInteger)channel page:(NSInteger)page;
- (void)requestOrderInfoWithOrderID:(NSString *)orderID;

@end

@implementation FZManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareData];
    [self configureTopMenu];
    [self configureTableView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configureNavigationBar];
}

- (void)prepareData
{
    self.currentPage = 1;
    self.dataArray = [[NSMutableArray alloc] init];
    [self loadDataOfChannel:0 page:1];
}

- (void)configureNavigationBar
{
    [self.navigationController performSelector:@selector(addTitle:) withObject:@"支付管理"];
    [self addButtonWithImageName:@"fanhui" target:self action:@selector(bakButton:) position:POSLeft];
    
//    UIButton *button = [UIButton buttonWithFrame:CGRectMake(0, 0, 30, 30) title:nil fontSize:17 bgImageName:nil];
//    [button setImage:[UIImage imageNamed:@"SearchIcon"] forState:UIControlStateNormal];
//    button.imageEdgeInsets = UIEdgeInsetsMake(3, 0, 0, 0);
//    [button addTarget:self action:@selector(rightBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)configureTopMenu
{
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
    bgImageView.image        = [UIImage imageNamed:@"HuaDtiao"];
    [self.view addSubview:bgImageView];
    _topMenu = [[FZOrderMenuBar alloc] init];
    _topMenu.titleArray = [NSArray arrayWithObjects:@"已付款", @"未付款", nil];
    [_topMenu changeChannel:^(NSUInteger index) {
        self.currentChannel = index;
        self.currentPage = 1;
        [self loadDataOfChannel:index page:self.currentPage];
        [self reloadView];
    }];
    
    [_topMenu installMenuInView:self.view];
}

- (void)configureTableView
{
    CGRect frame = self.tableView.frame;
    frame.origin.y = 108;
    frame.size.height -= 44;
    self.tableView.frame = frame;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FZPayManagerTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"FZPayManagerTableViewCell"];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf loadDataOfChannel:weakSelf.currentChannel page:1];
    }];
    [self.tableView addFooterWithCallback:^{
        [weakSelf loadDataOfChannel:weakSelf.currentChannel page:++weakSelf.currentPage];
    }];
    
    self.waitingView = [[FZWaitingView alloc] init];
    [self.view addSubview:self.waitingView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FZPayBoltingModel * model=[self.dataArray objectAtIndex:indexPath.row];
    FZPayManagerTableViewCell * payCell=[tableView dequeueReusableCellWithIdentifier:@"FZPayManagerTableViewCell"];
    
    if (self.currentChannel==0){
        [payCell.continueBtn setTitle:@"再次支付" forState:UIControlStateNormal];
    }
    else{
        [payCell.continueBtn setTitle:@"继续支付" forState:UIControlStateNormal];
    }
    
    [payCell.continueBtn addTarget:self action:@selector(continuebutton:) forControlEvents:UIControlEventTouchUpInside];
    payCell.tag=indexPath.row;
    [payCell configureCellWithModel:model];

    return payCell;
}

- (void)continuebutton:(UIButton *)btn
{
    if([btn.titleLabel.text isEqualToString:@"再次支付"]){
        FZPayBoltingModel *model = [self.dataArray objectAtIndex:btn.tag];
        [self requestOrderInfoWithOrderID:model.order_id];
    }
    else if ([btn.titleLabel.text isEqualToString:@"继续支付"]){
        [self RequestContinueUrlOfSection:btn.tag];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    return 280;
}

#pragma mark - Request data -

- (void)loadDataOfChannel:(NSInteger)channel page:(NSInteger)page
{
    //2 已支付  1 未支付
    NSString *type = nil;
    if (channel == 0) {
        type = @"2";
    }
    else {
        type = @"1";
    }
    
    NSDictionary * parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                 FZUserInfoWithKey(Key_MemberID), @"member_id",
                                 FZUserInfoWithKey(Key_LoginToken), @"token",
                                 @"list", @"action",
                                 type, @"type",
                                 [NSString stringWithFormat:@"%d", (int)page], @"page", nil];
    [[AFHTTPRequestOperationManager manager] POST:URLStringByAppending(kOrderInfo) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"列表%@", responseObject);
        
        if ([responseObject objectForKey:@"token"]) {
            FZUserInfoReset;
            JumpToLoginIfNeeded;
            return ;
        }
        
        if (page == 1) {
            [self.dataArray removeAllObjects];
        }
        
        for (NSDictionary *orderinfoDict in [responseObject  objectForKey:@"data"]) {
            FZPayBoltingModel * newModel=[[FZPayBoltingModel alloc] init];
            [newModel setValuesForKeysWithDictionary:orderinfoDict];
            [newModel setValue:[orderinfoDict objectForKey:@"id"] forKey:@"order_id"];
            
            [self.dataArray addObject:newModel];
        }
        
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        [self.waitingView hide];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",operation.responseObject);
        
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        [self.waitingView loadingFailedWithImage:[UIImage imageNamed:@"loadFailed"] handler:^{
            [self.tableView headerBeginRefreshing];
        }];
    }];
}

//继续支付
- (void)RequestContinueUrlOfSection:(NSInteger)section
{
    [ProgressHUD show:@"跳转支付中..." Interaction:NO];
    
    FZPayBoltingModel * model=[self.dataArray objectAtIndex:section];
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:@"apply_payment",@"action",FZUserInfoWithKey(Key_MemberID),@"member_id",FZUserInfoWithKey(Key_LoginToken),@"token",model.order_id,@"id",nil];
    
    [[AFHTTPRequestOperationManager manager] POST:URLStringByAppending(kOrderInfo) parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        [ProgressHUD dismiss];
        
        if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
            FZPayFinishViewController * payViewController=[[FZPayFinishViewController alloc] init];
            payViewController.paymentURLString = [[responseObject objectForKey:@"data"] lastObject];
            [self.navigationController pushViewController:payViewController animated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        FZNetworkingError(@"继续支付");
    }];
}

//获取订单信息
- (void)requestOrderInfoWithOrderID:(NSString *)orderID
{
    [ProgressHUD show:@"获取订单信息中..." Interaction:NO];
    
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"trade_info",@"action",
                             FZUserInfoWithKey(Key_MemberID),@"member_id",
                             FZUserInfoWithKey(Key_LoginToken),@"token",
                             orderID,@"id",nil];
    
    [[AFHTTPRequestOperationManager manager] POST:URLStringByAppending(kOrderInfo) parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        [ProgressHUD dismiss];
        [[EGOCache globalCache] setPlist:responseObject forKey:orderID withTimeoutInterval:NSNotFound];
        
        FZPaymentFirstViewController *payViewController = [[FZPaymentFirstViewController alloc] init];
        payViewController.orderID = orderID;
        FZNavigationController *navController = [[FZNavigationController alloc] initWithRootViewController:payViewController];
        [self presentViewController:navController animated:YES completion:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ProgressHUD dismiss];
        FZNetworkingError(@"再次支付");
    }];
}

#pragma mark - Response events -

- (void)bakButton:(UIButton *)button
{
     
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)reloadView
{
    [UIView animateWithDuration:0.15 animations:^{
        self.tableView.alpha = 0;
    } completion:^(BOOL finished) {
    }];
    
    [UIView animateWithDuration:0.15 animations:^{
        self.tableView.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}


- (void)rightBarButtonClicked:(UIButton *)btn
{
    NSLog(@"搜索");

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
