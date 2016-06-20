//
//  FZGenerateOrderViewController.m
//  Fangzhur
//
//  Created by --超-- on 15/1/17.
//  Copyright (c) 2015年 Zc. All rights reserved.
//

#import "FZGenerateOrderViewController.h"
#import "FZDealNumTableViewCell.h"
#import "FZPayFinishViewController.h"
#import "ProgressHUD.h"
#import "FZLabelCell.h"
#import "FZNumTableViewCell.h"

@interface FZGenerateOrderViewController ()

- (void)configureNavigationBar;
- (void)configureTableView;

@end

@implementation FZGenerateOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureTableView];
    [self viewDidLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configureNavigationBar];
}

- (void)configureNavigationBar
{
    [self.navigationController performSelector:@selector(addTitle:) withObject:@"交易信息"];
    [self addButtonWithImageName:@"fanhui" target:self action:@selector(backButtonClicked) position:POSLeft];
}

- (void)configureTableView
{
    self.view.backgroundColor=[UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"FZDealNumTableViewCell" bundle:nil] forCellReuseIdentifier:@"FZDealNumTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FZLabelCell" bundle:nil] forCellReuseIdentifier:@"FZLabelCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FZNumTableViewCell" bundle:nil] forCellReuseIdentifier:@"FZNumTableViewCell"];
    UIButton *footerButton = kBottomButtonWithName(@"易宝支付");
    [footerButton addTarget:self action:@selector(payButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:footerButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0){
    return 330;
    }
    else if (indexPath.row==1){
        return 44;
    }
    else
        return 149;

}
-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell * Cell=nil;
    if(indexPath.row == 0){
    FZDealNumTableViewCell *orderCell = [tableView dequeueReusableCellWithIdentifier:@"FZDealNumTableViewCell"];
    [orderCell configureCellWithPaymentModel:self.paymentModel];
        Cell= orderCell;
    }
    
    else if (indexPath.row == 1 ){
        FZLabelCell * labelCell=[tableView dequeueReusableCellWithIdentifier:@"FZLabelCell"];

        Cell=labelCell;
    }
    else{
        FZNumTableViewCell * NmuTableViewCell=[tableView dequeueReusableCellWithIdentifier:@"FZNumTableViewCell"];
        Cell= NmuTableViewCell;
    }
    return Cell;
}

#pragma mark - Response events -

- (void)payButtonClicked
{
    [ProgressHUD show:@"支付跳转中..." Interaction:NO];
    
    [[FZRequestManager manager] requestPaymentURLByParameters:self.paymentModel.requestParameters handler:^(BOOL success, NSString *URLString, NSString *errorMessage) {
        [ProgressHUD dismiss];
        
        if (success) {
            FZPayFinishViewController *finishViewController = [[FZPayFinishViewController alloc] init];
            finishViewController.paymentURLString = URLString;
            [self.navigationController pushViewController:finishViewController animated:YES];
        }
        else {
            [JDStatusBarNotification showWithStatus:errorMessage dismissAfter:2 styleName:JDStatusBarStyleError];
        }
    }];
}

- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
