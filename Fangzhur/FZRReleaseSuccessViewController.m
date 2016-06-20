//
//  FZRReleaseSuccessViewController.m
//  SelfBusiness
//
//  Created by --Chao-- on 14-6-11.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZRReleaseSuccessViewController.h"

@interface FZRReleaseSuccessViewController ()

- (void)UIConfig;

@end

@implementation FZRReleaseSuccessViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self UIConfig];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController performSelector:@selector(addTitle:) withObject:@""];
    [self addButtonWithImageName:@"fanhui" target:self action:@selector(popViewController) position:POSLeft];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化 -

- (void)UIConfig
{
    FZRReleaseSuccessView *successView = [[FZRReleaseSuccessView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT - 64)];
    successView.delegate = self;
    successView.tipLabel.text = [NSString stringWithFormat:kReleaseSuccessTipInfo, _orderId];
    [self.view addSubview:successView];
}

#pragma mark - FZRReleaseSuccessViewDelegate -

- (void)gotoCheckMyOrders
{
    FZPersonalCenterViewController *centerController = [[FZPersonalCenterViewController alloc] init];
    FZNavigationController *navController = [[FZNavigationController alloc] initWithRootViewController:centerController];
    [self presentViewController:navController animated:YES completion:^{
        [self.navigationController popToRootViewControllerAnimated:NO];
    }];
}

- (void)backButtonClicked
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Response events -

- (void)popViewController
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
