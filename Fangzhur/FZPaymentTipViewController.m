//
//  FZPaymentTipViewController.m
//  Fangzhur
//
//  Created by --超-- on 15/1/10.
//  Copyright (c) 2015年 Zc. All rights reserved.
//

#import "FZPaymentTipViewController.h"
#import "FZPayHomeTableViewCell.h"
#import "FZPaymentFirstViewController.h"
#import "FZManagerViewController.h"
#import "FZMobileLoginViewController.h"

@interface FZPaymentTipViewController ()

- (void)configureNavigationBar;
- (void)configureTableView;
- (void)addBottomButton;

@end

@implementation FZPaymentTipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureTableView];
    [self addBottomButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self configureNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureNavigationBar
{
    UIButton *backButton = [self addButtonWithImageName:@"fanhui_brn" target:self action:@selector(backbuttonClicked) position:POSLeft];
    backButton.contentMode = UIViewContentModeLeft;
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    
    UIButton *button = [UIButton buttonWithFrame:CGRectMake(0, 0, 70, 30) title:@"支付管理" fontSize:17 bgImageName:nil];
    button.titleEdgeInsets = UIEdgeInsetsMake(5, -15, 0, 0);
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)configureTableView
{
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect tableViewFrame = self.tableView.frame;
    tableViewFrame.size.height = SCREEN_HEIGHT - 64 - 49;
    self.tableView.frame = tableViewFrame;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FZPayHomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"FZPayHomeTableViewCell"];
}

- (void)addBottomButton
{
    UIButton *footerButton = kBottomButtonWithName(@"付房租");
    [footerButton addTarget:self action:@selector(gotoPayment) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:footerButton];
}

#pragma mark - Table view delegate -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FZPayHomeTableViewCell *payHopmeCell = [tableView dequeueReusableCellWithIdentifier:@"FZPayHomeTableViewCell"];
    return payHopmeCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (kScreenScale == 3) {
        return 800;
    }
    else {
        return 700;
    }
}

#pragma mark - Response events -

- (void)backbuttonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonClicked
{
    JumpToLoginIfNeeded;
    
    FZManagerViewController *managerController = [[FZManagerViewController alloc] init];
    FZNavigationController *navController = [[FZNavigationController alloc] initWithRootViewController:managerController];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)gotoPayment
{
    FZPaymentFirstViewController *firstController = [[FZPaymentFirstViewController alloc] init];
    FZNavigationController *navController = [[FZNavigationController alloc] initWithRootViewController:firstController];
    [self presentViewController:navController animated:YES completion:nil];
}

@end
