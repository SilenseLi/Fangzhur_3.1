//
//  FZPersonalCenterViewController.m
//  Fangzhur
//
//  Created by --超-- on 14/11/5.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZPersonalCenterViewController.h"
#import "UIButton+ZCCustomButtons.h"
#import "FZUserInfoView.h"
#import "FZPersonalCenterCell.h"
#import <ShareSDK/ShareSDK.h>
#import "DataBaseManager.h"
#import "FZHowViewController.h"
#import "FZMobileLoginViewController.h"

#define JumpToLoginIfNeeded \
if (!FZUserInfoWithKey(Key_LoginToken) || [FZUserInfoWithKey(Key_BindingTag) isEqualToString:@"Unbind"]) {\
FZMobileLoginViewController *mobileLoginViewController = [[FZMobileLoginViewController alloc] init];\
mobileLoginViewController.title = @"手机登录";\
[self presentViewController:mobileLoginViewController animated:YES completion:^{\
[JDStatusBarNotification showWithStatus:@"使用手机号码登陆，才能进入哦!" dismissAfter:2.5 styleName:JDStatusBarStyleError];\
}];\
return;\
}

@interface FZPersonalCenterViewController ()

@property (nonatomic, strong) UIButton *logoutButton;
@property (nonatomic, strong) NSArray *dataArray;

- (void)configureUI;
- (void)addBottomView;

@end

@implementation FZPersonalCenterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.dataArray = [ZCReadFileMethods dataFromPlist:@"CenterListData" ofType:Array];
    if (![FZUserInfoWithKey(Key_BindingTag) isEqualToString:@"Unbind"]) {
        [[FZRequestManager manager] getUserInfoComplete:NULL];
    }
    
    [self configureUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController performSelector:@selector(addTitle:) withObject:@"个人中心"];
    [self addButtonWithImageName:@"fanhui" target:self action:@selector(dismissPersonalCenter:) position:POSLeft];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureUI
{
    [self addBottomView];
    
    FZUserInfoView *userInfoView = [[[NSBundle mainBundle] loadNibNamed:@"FZUserInfoView" owner:self options:nil] lastObject];
    [userInfoView.helpButton addTarget:self action:@selector(howToMakeProfit) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FZPersonalCenterCell" bundle:nil]
         forCellReuseIdentifier:@"FZPersonalCenterCell"];
    
    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
    self.tableView.tableHeaderView = userInfoView;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 60, 0, 0);
#if 0
    [self rollingBarWithScrollView:self.tableView finished:^(BOOL isRollingUp) {
        if (isRollingUp) {
            [UIView animateWithDuration:0.2 animations:^{
                CGRect frame = self.logoutButton.frame;
                frame.origin.y = SCREEN_HEIGHT;
                self.logoutButton.frame = frame;
            }];
        }
        else {
            [UIView animateWithDuration:0.2 animations:^{
                CGRect frame = self.logoutButton.frame;
                frame.origin.y = SCREEN_HEIGHT - 49;
                self.logoutButton.frame = frame;
            }];
        }
    }];
#endif
}

- (void)addBottomView
{
    self.logoutButton = [UIButton buttonWithFrame:CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49)
                                            title:@"退出登录"
                                         fontSize:17
                                      bgImageName:@"tuichuDL"];
    [self.logoutButton addTarget:self action:@selector(dismissPersonalCenter:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.logoutButton];
}

#pragma mark - Response events - 

- (void)howToMakeProfit
{
    FZHowViewController *howController = [[FZHowViewController alloc] init];
    [self.navigationController pushViewController:howController animated:YES];
}

- (void)dismissPersonalCenter:(UIButton *)sender
{
    // 登出
    if (sender == self.logoutButton) {
        FZUserInfoReset;
        [ShareSDK cancelAuthWithType:ShareTypeWeixiSession];
        [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - Table view delegate -

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 21)];
    bgView.backgroundColor = [UIColor clearColor];
    
    return bgView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JumpToLoginIfNeeded;
    
    NSString *controllerString = [[self.dataArray objectAtIndex:indexPath.section + 3] objectAtIndex:indexPath.row];
    UIViewController *viewController = [[NSClassFromString(controllerString) alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 53;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

#pragma mark - Table view data source -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 2) {
        return 2;
    }
    else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FZPersonalCenterCell *centerCell = [self.tableView dequeueReusableCellWithIdentifier:@"FZPersonalCenterCell"];
    [centerCell configureCellAtIndexPath:indexPath];
    
    return centerCell;
}


@end
