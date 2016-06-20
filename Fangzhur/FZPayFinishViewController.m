//
//  FZPayFinishViewController.m
//  Fangzhur
//
//  Created by fq on 15/1/7.
//  Copyright (c) 2015年 Zc. All rights reserved.
//

#import "FZPayFinishViewController.h"

@interface FZPayFinishViewController () <UIWebViewDelegate>

- (void)configureNavigationBar;

@end

@implementation FZPayFinishViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.paymentURLString]];
    [self.view addSubview:webView];
    webView.delegate = self;
    [webView loadRequest:request];
    
    UIButton *button = kBottomButtonWithName(@"返回");
    
    [button addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configureNavigationBar];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [JDStatusBarNotification dismiss];
}

- (void)configureNavigationBar
{
    [self.navigationController performSelector:@selector(addTitle:) withObject:@"易宝支付"];
    [self addButtonWithImageName:@"fanhui" target:self action:@selector(backButtonClicked) position:POSLeft];
    
    UIButton *button = [UIButton buttonWithFrame:CGRectMake(0, 0, 70, 30) title:@"刷新" fontSize:17 bgImageName:nil];
    button.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 0);
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(refreshWebView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

#pragma mark - Web view delegate -

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [JDStatusBarNotification showWithStatus:@"加载中..."];
    [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleWhite];
    [JDStatusBarNotification showProgress:0.5];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [JDStatusBarNotification showProgress:1];
    [JDStatusBarNotification dismissAfter:2];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [JDStatusBarNotification showWithStatus:@"页面加载失败" dismissAfter:2 styleName:JDStatusBarStyleError];
}

#pragma mark - Response events -

- (void)refreshWebView
{
    [webView reload];
}

- (void)backButtonClicked
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}


@end
