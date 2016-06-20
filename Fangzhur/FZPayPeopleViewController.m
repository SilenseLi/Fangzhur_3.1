//
//  FZPayPeopleViewController.m
//  Fangzhur
//
//  Created by fq on 14/12/26.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZPayPeopleViewController.h"
#import "FZPayPeopleTableViewCell.h"
#import "FZTPayTableViewCell.h"
#import "FZPayBoltingModel.h"

@interface FZPayPeopleViewController ()

- (void)configerUI;

@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) FZWaitingView *waitingView;

@end

@implementation FZPayPeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configerUI];

    [self RequestReceiver];
    self.dataArray=[[NSMutableArray alloc] init];
    self.tableView.separatorStyle=UITableViewCellAccessoryNone;
    self.tableView.backgroundColor=[UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController performSelector:@selector(addTitle:) withObject:@"收款人记录"];
}

- (void)configerUI
{
    [self.navigationController performSelector:@selector(addTitle:) withObject:@"收款人记录"];
    [self addButtonWithImageName:@"fanhui" target:self action:@selector(backBtn:) position:POSLeft];
    UIButton *button = [UIButton buttonWithFrame:CGRectMake(0, 0, 20, 20) title:@"" fontSize:17 bgImageName:nil];
    button.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"search_"]];
    button.titleEdgeInsets = UIEdgeInsetsMake(5, -20, 0, 0);
    button.imageEdgeInsets = UIEdgeInsetsMake(3, 35, 0, 0);
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonItem;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FZPayPeopleTableViewCell" bundle:nil] forCellReuseIdentifier:@"FZPayPeopleTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FZTPayTableViewCell" bundle:nil] forCellReuseIdentifier:@"FZTPayTableViewCell"];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addHeaderWithCallback:^{
        [weakSelf RequestReceiver];
    }];
    
    self.waitingView = [[FZWaitingView alloc] init];
    [self.view addSubview:self.waitingView];
}

- (void)RequestReceiver
{
    NSDictionary * paramsDict=[NSDictionary dictionaryWithObjectsAndKeys:FZUserInfoWithKey(Key_MemberID),@"member_id",FZUserInfoWithKey(Key_LoginToken),@"token",@"owner_list",@"action",nil];
    [[AFHTTPRequestOperationManager manager] POST:URLStringByAppending(kOrderInfo) parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.dataArray removeAllObjects];
        [self.waitingView hide];
        
        for (NSDictionary * orderReceive in [responseObject objectForKey:@"data"]) {
            FZPayBoltingModel * Receivemodel=[[FZPayBoltingModel alloc] init];
            [Receivemodel setValuesForKeysWithDictionary:orderReceive];
            [self.dataArray addObject:Receivemodel];
        }
        
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.waitingView loadingFailedWithImage:[UIImage imageNamed:@"loadFailed"] handler:^{
            [self.tableView headerBeginRefreshing];
        }];
        
        [self.tableView headerEndRefreshing];
        
        FZNetworkingError(@"收款人记录");
    }];
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FZPayBoltingModel *model = [self.dataArray objectAtIndex:indexPath.row];
    FZPayPeopleTableViewCell *cell = (FZPayPeopleTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    [self.paymentModel.thirdCacheArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%d", model.owner_type.intValue - 1]];
    [self.paymentModel.thirdCacheArray replaceObjectAtIndex:1 withObject:model.bank_membername];
    [self.paymentModel.thirdCacheArray replaceObjectAtIndex:2 withObject:model.bank_card_no];
    [self.paymentModel.thirdCacheArray replaceObjectAtIndex:3 withObject:cell.banNmaLabel.text];
    [self.paymentModel.thirdCacheArray replaceObjectAtIndex:4 withObject:model.bank_address];
    [self.paymentModel.thirdCacheArray replaceObjectAtIndex:5 withObject:model.owner_phone];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    FZPayBoltingModel * model=[self.dataArray objectAtIndex:indexPath.row];
    
    FZPayPeopleTableViewCell * peopleCell=[tableView dequeueReusableCellWithIdentifier:@"FZPayPeopleTableViewCell"];
    
    [peopleCell configerCellWithModel:model];
    
    peopleCell.tag=indexPath.row;

    return peopleCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 201;
}


- (void)rightBarButtonClicked:(UIButton *)button
{
    
    NSLog(@"=========");
}

- (void)backBtn:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
