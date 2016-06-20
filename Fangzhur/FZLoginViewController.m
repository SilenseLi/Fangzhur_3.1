//
//  FZLoginViewController.m
//  Fangzhur
//
//  Created by --超-- on 14/11/2.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZLoginViewController.h"
#import "FZMobileLoginViewController.h"
#import <JDStatusBarNotification.h>
#import "FZThirdLoginModel.h"
#import "FZNetworkingManager.h"
#import "FZChooseTagViewController.h"
#import "FZStatementViewController.h"
#import "ProgressHUD.h"

@interface FZLoginViewController ()

@property (nonatomic, strong) FZLoginView *loginView;
@property (nonatomic, strong) FZThirdLoginModel *loginModel;

@end

@implementation FZLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [FZNetworkingManager showNetworkingUnreachableStatus];
    [[FZRequestManager manager] getAllTags];
    
    self.loginView = [[FZLoginView alloc] initWithImage:[UIImage imageNamed:@"loginBG"]];
    self.loginView.delegate = self;
    [self.view addSubview:self.loginView];
    self.loginModel = [[FZThirdLoginModel alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.loginView addLogoAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Login view delegate -

- (void)loginView:(FZLoginView *)loginView backButtonClicked:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)loginView:(FZLoginView *)loginView loginButtonClicked:(UIButton *)sender loginMode:(FZLoginMode)loginMode
{
    FZChooseTagViewController *tagViewController = [[FZChooseTagViewController alloc] init];
    FZNavigationController *navController = [[FZNavigationController alloc] initWithRootViewController:tagViewController];
    [navController addTitle:@"手机登录"];
    
    //登录
    switch (loginMode) {
        case FZLoginModeDefault: {
            FZMobileLoginViewController *mobileLoginViewController = [[FZMobileLoginViewController alloc] init];
            mobileLoginViewController.title = @"手机登录";
            [self presentViewController:mobileLoginViewController animated:YES completion:NULL];
        }
            break;
        case FZLoginModeWeibo: {
            [self.loginModel userLoginWithType:ThirdTypeWeibo completed:^(BOOL success) {
                if (success) {
                    [ProgressHUD dismiss];
                    [self dismissViewControllerAnimated:NO completion:nil];
                    [self.presentingViewController presentViewController:navController animated:YES completion:nil];
                }
                else {
                    [ProgressHUD showError:@"登录失败"];
                }
            }];
        }
            break;
        case FZLoginModeWeixin: {
            [self.loginModel userLoginWithType:ThirdTypeWeixin completed:^(BOOL success) {
                if (success) {
                    [ProgressHUD dismiss];
                    [self dismissViewControllerAnimated:NO completion:nil];
                    [self.presentingViewController presentViewController:navController animated:YES completion:nil];
                }
                else {
                    [ProgressHUD showError:@"登录失败"];
                }
            }];
        }
            
        default:
            break;
    }    

    if (![[EGOCache globalCache] plistForKey:Key_Tag]) {
        [[FZRequestManager manager] getAllTags];
    }
}

- (void)loginView:(FZLoginView *)loginView declarationButtonClicked:(UIButton *)sender
{
    FZStatementViewController *statementViewController = [[FZStatementViewController alloc] init];
    FZNavigationController *navController = [[FZNavigationController alloc] initWithRootViewController:statementViewController];
    [self presentViewController:navController animated:YES completion:nil];
}




@end
