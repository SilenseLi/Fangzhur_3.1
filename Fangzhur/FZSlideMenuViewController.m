//
//  FZSlideMenuViewController.m
//  Fangzhur
//
//  Created by --Chao-- on 14-6-3.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZSlideMenuViewController.h"
#import "UIButton+ZCCustomButtons.h"
#import <RESideMenu.h>
#import <UIViewController+RESideMenu.h>
#import "FZSideMenuCell.h"
#import "FZSideMenuHeader.h"
#import "FZLoginViewController.h"
#import "FZPersonalCenterViewController.h"
#import "FZShareViewController.h"
#import "FZSettingViewController.h"
#import "FZMessageListViewController.h"
#import "FZContractHouseViewController.h"
#define LINE_COLOR RGBColor(40, 70, 118)

@interface FZSlideMenuViewController ()

@property (nonatomic, strong) FZSideMenuHeader *headerView;
@property (nonatomic, strong) NSDictionary *dataDict;

- (void)addHeadSection;
- (void)headerViewSelected;

@end

@implementation FZSlideMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataDict = [ZCReadFileMethods dataFromPlist:@"SideMenuData" ofType:Dictionary];
    [self addHeadSection];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"FZSideMenuCell" bundle:nil] forCellReuseIdentifier:@"FZSideMenuCell"];

    UIButton *setButton = [UIButton buttonWithFrame:CGRectMake(10, 20, 44, 44) bgImage:[UIImage imageNamed:@"shezhi_btn"]];
    if (kScreenScale == 3) {
        setButton.frame = CGRectMake(20, 30, 30, 30);
    }
    [setButton addTarget:self action:@selector(gotoSettingView) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:setButton];
    
    UIImage *logoImage = [UIImage imageNamed:@"SideMenuLogo"];
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:logoImage];
    logoImageView.frame = CGRectMake(SCREEN_WIDTH - 200 - kAdjustScale, SCREEN_HEIGHT - 160 - kAdjustScale, logoImage.size.width, logoImage.size.height);
    [[UIApplication sharedApplication].windows.firstObject addSubview:logoImageView];
}

- (void)viewWillLayoutSubviews
{
    self.tableView.frame                = CGRectMake(0, 0, SCREEN_WIDTH - 90, SCREEN_HEIGHT);
    self.tableView.separatorStyle       = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate             = self;
    self.tableView.dataSource           = self;
    self.tableView.opaque               = NO;
    self.tableView.backgroundColor      = [UIColor clearColor];
}

#pragma mark - 头像 -

- (void)addHeadSection
{
    self.headerView = [[FZSideMenuHeader alloc] initWithTarget:self action:@selector(headerViewSelected)];
    self.tableView.tableHeaderView = self.headerView;
}

- (void)headerViewSelected
{
    //没有登录跳到登录界面
    if (!FZUserInfoWithKey(Key_LoginToken)) {
        FZLoginViewController *loginViewController = [[FZLoginViewController alloc] init];
        [self presentViewController:loginViewController animated:YES completion:^{
            [self.sideMenuViewController hideMenuViewController];
        }];
    }
    //登录后跳转到个人中心
    else {
        FZPersonalCenterViewController *centerViewController = [[FZPersonalCenterViewController alloc] init];
        FZNavigationController *navController = [[FZNavigationController alloc] initWithRootViewController:centerViewController];
        [self presentViewController:navController animated:YES completion:^{
            [self.sideMenuViewController hideMenuViewController];
        }];
    }
    
}

#pragma mark - 跳转设置 -

- (void)gotoSettingView
{
    FZSettingViewController *settingViewController = [[FZSettingViewController alloc] init];
    FZNavigationController *navController = [[FZNavigationController alloc] initWithRootViewController:settingViewController];
    
    [self.sideMenuViewController.contentViewController presentViewController:navController animated:YES completion:nil];
}


#pragma mark - Table view delegate -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            if (!FZUserInfoWithKey(Key_LoginToken)) {
                FZLoginViewController *loginViewController = [[FZLoginViewController alloc] init];
                [self presentViewController:loginViewController animated:YES completion:^{
                    [self.sideMenuViewController hideMenuViewController];
                    [JDStatusBarNotification showWithStatus:@"请先登录，再进行相关操作" dismissAfter:2];
                }];
                
                return;
            }
            
            FZMessageListViewController *messageListViewController = [[FZMessageListViewController alloc] init];
            FZNavigationController *navController = [[FZNavigationController alloc] initWithRootViewController:messageListViewController];
            [self presentViewController:navController animated:YES completion:^{
                [self.sideMenuViewController hideMenuViewController];
            }];
        }
            break;
        case 1: {
            FZShareViewController *shareViewController = [[FZShareViewController alloc] init];
            FZNavigationController *navController = [[FZNavigationController alloc] initWithRootViewController:shareViewController];
            [self presentViewController:navController animated:YES completion:^{
                [self.sideMenuViewController hideMenuViewController];
            }];
        }
            break;
        case 2: {
            FZContractHouseViewController *ContractHouseViewController = [[FZContractHouseViewController alloc] init];
            FZNavigationController *navController = [[FZNavigationController alloc] initWithRootViewController:ContractHouseViewController];
            [self presentViewController:navController animated:YES completion:^{
                [self.sideMenuViewController hideMenuViewController];
            }];
        }
            break;
        case 3:{makeAPhoneCall(@"4000981985");}
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

#pragma mark - Table view data source -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FZSideMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FZSideMenuCell"];
    [cell configureRow:indexPath.row WithData:self.dataDict];
    
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
