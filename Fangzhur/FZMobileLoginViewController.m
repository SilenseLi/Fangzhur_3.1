//
//  FZMobileLoginViewController.m
//  Fangzhur
//
//  Created by --超-- on 14/11/3.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZMobileLoginViewController.h"
#import "FZChooseTagViewController.h"

@interface FZMobileLoginViewController ()



@end

@implementation FZMobileLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mobileLoginView = [[FZMobileLoginView alloc] initWithImage:[UIImage imageNamed:@"loginBG"] title:self.title];
    self.mobileLoginView.delegate = self;
    [self.view addSubview:self.mobileLoginView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Mobile view delegate -

- (void)MobileLoginViewButton:(UIButton *)sender mode:(FZMobileLoginButtonMode)mode
{
    switch (mode) {
        case FZMobileLoginButtonModeBack://返回上级界面
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case FZMobileLoginButtonModeLogin: {//登录
            UIViewController *homeViewController = self.presentingViewController.presentingViewController;
            UIViewController *loginViewController = self.presentingViewController;
            NSLog(@"%@", self.presentingViewController);
            if ([self.presentingViewController isKindOfClass:[NSClassFromString(@"FZLoginViewController") class]]) {
                FZChooseTagViewController *tagViewController = [[FZChooseTagViewController alloc] init];
                FZNavigationController *navController = [[FZNavigationController alloc] initWithRootViewController:tagViewController];
                [navController addTitle:@"选择标签"];
                
                [self dismissViewControllerAnimated:NO completion:nil];
                [loginViewController dismissViewControllerAnimated:NO completion:^{
                    [homeViewController presentViewController:navController animated:YES completion:nil];
                }];
            }
            
            [self dismissViewControllerAnimated:NO completion:nil];
        }
            break;
        case FZMobileLoginButtonModeCheck://获取验证码
            if (![[EGOCache globalCache] plistForKey:Key_Tag]) {
                [[FZRequestManager manager] getAllTags];
            }
            
            break;  
        default:
            break;
    }
}

@end
