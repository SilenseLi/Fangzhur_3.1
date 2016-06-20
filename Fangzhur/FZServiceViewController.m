//
//  FZServiceViewController.m
//  Fangzhur
//
//  Created by fq on 15/1/6.
//  Copyright (c) 2015年 Zc. All rights reserved.
//

#import "FZServiceViewController.h"

@interface FZServiceViewController ()

- (void)configureNavigationBar;
- (void)configerUI;


@end

@implementation FZServiceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configerUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configureNavigationBar];
}

- (void)configureNavigationBar
{
    [self addButtonWithImageName:@"fanhui" target:self action:@selector(backButtonClicked) position:POSLeft];
    [self.navigationController performSelector:@selector(addTitle:) withObject:@"用户服务协议"];
}

- (void)configerUI
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"OrderServe"
                                                     ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 64, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 64)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(scrollView.bounds), 0)];
    tipLabel.text=content;
    tipLabel.font            = [UIFont fontWithName:kFontName size:15];
    tipLabel.numberOfLines   = 0;
    tipLabel.lineBreakMode   = NSLineBreakByWordWrapping;
    tipLabel.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:tipLabel];
    
    CGRect tipLabelFrame = [tipLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(scrollView.frame), 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:kFontName size:15]} context:nil];
    tipLabel.frame=CGRectMake(0, 0, tipLabelFrame.size.width, tipLabelFrame.size.height);
    scrollView.contentSize=tipLabelFrame.size;
}

- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
