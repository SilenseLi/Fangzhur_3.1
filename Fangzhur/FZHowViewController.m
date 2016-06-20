//
//  FZHowViewController.m
//  Fangzhur
//
//  Created by --Chao-- on 14-7-2.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZHowViewController.h"

@interface FZHowViewController ()

- (void)UIConfig;

@end

@implementation FZHowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self UIConfig];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = @"如何赚取收益";
    [self.navigationController performSelector:@selector(addTitle:) withObject:@""];
    [self addButtonWithImageName:@"fanhui" target:self action:@selector(popViewController) position:POSLeft];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)UIConfig
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 64, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 64)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH - 20, SCREEN_HEIGHT + 100);
    [self.view addSubview:scrollView];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(scrollView.bounds), 500)];
    tipLabel.text = @"1. 分享您的互助码（手机号），好友注册即可参加房码抽奖，最高可获得1万元房码大奖，房码可以在“房主儿”抵房租和服务费。同时，好友抽中多少房码，也赠送您多少房码。\n\n2.发布房源\n发布房主房源，即可加入“七天闪电成交计划”，让房屋快速成交，让更多找房者直接联系房主。不仅如此，房源通过“自助交易”成交，您可获得高达800元现金补贴！\n\n3.申请社工\n选择你熟悉的小区，申请成为该小区社工，真诚的回答用户的问题，房主儿网就补贴该小区所有房产交易的1%送给您！\n如果该小区有10笔房产交易通过房主儿网成交，相当于房主儿网补贴的服务费的10%作为现金收益送给您！\n该功能目前需要通过网站完成操作。\n\n4.积分排行榜\n您可以参与积分排行榜，通过发布房源、邀请好友、连续登陆等方式迅速获得积分上的增长，前100名用户，房主儿网直接补贴从1万元到1元不等的奖励，积分排行榜将不定期公布！还有比直接拿到现金更直接的么？！\n积分排行榜可以通过网站进行查询。";
    tipLabel.font            = [UIFont fontWithName:kFontName size:15];
    tipLabel.numberOfLines   = 0;
    tipLabel.lineBreakMode   = NSLineBreakByWordWrapping;
    tipLabel.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:tipLabel];
}

#pragma mark - Response events -

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
