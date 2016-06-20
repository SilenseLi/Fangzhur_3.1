//
//  FZContractTipViewController.m
//  Fangzhur
//
//  Created by --超-- on 14/12/14.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZContractTipViewController.h"
#import "AdjustLineSpacing.h"
#import "FZRSelfHelperViewController.h"
#import "FZContractViewController.h"

@interface FZContractTipViewController ()

- (void)configureUI;

@end

@implementation FZContractTipViewController

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.houseNumber = @"";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self configureUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController performSelector:@selector(addTitle:) withObject:@"签约服务"];
    [self addButtonWithImageName:@"fanhui" target:self action:@selector(popViewController) position:POSLeft];
    UIButton *button = [UIButton buttonWithFrame:CGRectMake(0, 0, 40, 30) title:@"流程" fontSize:17 bgImageName:nil];
    [button setImage:[UIImage imageNamed:@"lc_btn"] forState:UIControlStateNormal];
    button.titleEdgeInsets = UIEdgeInsetsMake(5, -20, 0, 0);
    button.imageEdgeInsets = UIEdgeInsetsMake(3, 35, 0, 0);
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureUI
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"guide4"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"guide4"];
        [FZGuideView GuideViewWithImage:[UIImage imageNamed:@"guide4"] atView:[UIApplication sharedApplication].keyWindow];
    }
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + 100);
    [self.view addSubview:self.scrollView];
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, CGRectGetWidth(self.scrollView.bounds) - 20, 20)];
    topLabel.backgroundColor = [UIColor clearColor];
    topLabel.textColor = kDefaultColor;
    topLabel.font = [UIFont fontWithName:kFontName size:16];
    topLabel.text = @"所有努力为了让签约和支付变得更安全";
    [self.scrollView addSubview:topLabel];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, CGRectGetWidth(self.scrollView.bounds) - 20, 500)];
    tipLabel.text = @"\n1.为了保证房主信息的真实，以免浪费您的时间，我们提前为您验证房主的信息。\n\n2.为了让您避免不必要的麻烦，我们将作为第三方见证人，并使房源的文字图片具有法律依据。\n\n3.为了让您减轻房租支付的压力，我们为您提供便捷的在线信用支付，使您可以实现分期支付房租，从而轻松拥有美好生活。\n\n4.为了让您顺利的完成交易，我们的优质顾问按照标准化的流程提供每一个细节的服务，及时的提醒您环节中的准备事项和问题规避，让交易快速高效。更重要的是我们帮您节省了高额的中介费。";
    tipLabel.font            = [UIFont fontWithName:kFontName size:14];
    tipLabel.numberOfLines   = 0;
    tipLabel.lineBreakMode   = NSLineBreakByWordWrapping;
    tipLabel.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:tipLabel];
    
    tipLabel.attributedText = [AdjustLineSpacing adjustString:tipLabel.text withLineSpacing:5];
    [tipLabel sizeToFit];
    
    UIButton *bottomButton = kBottomButtonWithName(@"签约代办");
    [bottomButton addTarget:self action:@selector(gotoNextStep) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomButton];
}

#pragma mark - Response events -

- (void)rightBarButtonClicked
{
    FZRSelfHelperViewController *helperViewController = [[FZRSelfHelperViewController alloc] init];
    FZNavigationController *navController = [[FZNavigationController alloc] initWithRootViewController:helperViewController];
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)gotoNextStep
{
    FZContractViewController *contractViewController = [[FZContractViewController alloc] init];
    contractViewController.houseType = self.houseType;
    contractViewController.houseNumber = self.houseNumber;
    [self.navigationController pushViewController:contractViewController animated:YES];
}

- (void)popViewController
{
    if (self.navigationController.viewControllers.count != 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
