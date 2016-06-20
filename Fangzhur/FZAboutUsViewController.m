//
//  FZAboutUsViewController.m
//  Fangzhur
//
//  Created by --超-- on 14-7-23.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZAboutUsViewController.h"
#import "AdjustLineSpacing.h"

@interface FZAboutUsViewController ()

- (void)UIConfig;

@end

@implementation FZAboutUsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self UIConfig];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController performSelector:@selector(addTitle:) withObject:@"关于我们"];
    [self addButtonWithImageName:@"fanhui" target:self action:@selector(backToSetting) position:POSLeft];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)UIConfig
{
    UILabel *aboutUsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, SCREEN_WIDTH - 40, 300)];
    aboutUsLabel.font = [UIFont fontWithName:kFontName size:15];
    aboutUsLabel.numberOfLines = 0;
    aboutUsLabel.backgroundColor = [UIColor clearColor];
    aboutUsLabel.text = @"      房主儿（fangzhur）创建于2013年5月，总部设在北京市，房主儿是一个为具有房屋租售需求的个人提供在线服务与交易的智能平台，个人用户可以通过网站和手机应用程序，发布、搜索、评论房源并完成在线看房、私密沟通、价格评估、租赁支付、买卖申请等程序，同时通过智能匹配实现个性化圈层生活社区，满足人们的生活理想，实现真正服务于个人，让房产交易回归到以我为中心的自主选择交易时代。";
    aboutUsLabel.attributedText = [AdjustLineSpacing adjustString:aboutUsLabel.text withLineSpacing:5];
    [self.view addSubview:aboutUsLabel];
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 380, SCREEN_WIDTH - 40, 21)];
    versionLabel.font = [UIFont fontWithName:kFontName size:15];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.backgroundColor = [UIColor clearColor];
    versionLabel.text = [NSString stringWithFormat:@"版本号：%@", kAppCurrentVersion];
    [self.view addSubview:versionLabel];
    
    UIButton *webButton = [UIButton buttonWithFrame:CGRectMake(20, 410, SCREEN_WIDTH - 40, 21) title:@"官方网址：http://www.fangzhur.com" fontSize:15 bgImageName:nil];
    [webButton setTitleColor:kDefaultColor forState:UIControlStateNormal];
    [webButton addTarget:self action:@selector(openOfficialSite) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:webButton];
}

#pragma mark - Reponse events -

- (void)openOfficialSite
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.fangzhur.com"]];
}

- (void)backToSetting
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
