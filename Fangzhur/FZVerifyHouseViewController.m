//
//  FZVerifyHouseViewController.m
//  Fangzhur
//
//  Created by --超-- on 14/12/4.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZVerifyHouseViewController.h"
#import "RESideMenu.h"

@interface FZVerifyHouseViewController ()

@end

@implementation FZVerifyHouseViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"guide3"];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"guide6"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"guide6"];
        [FZGuideView GuideViewWithImage:[UIImage imageNamed:@"guide6"] atView:[UIApplication sharedApplication].keyWindow];
    }
    
    for (UIView *subview in self.navigationController.navigationBar.subviews) {
        if ([subview isKindOfClass:[UILabel class]]) {
            [subview removeFromSuperview];
            break;
        }
    }
    
    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    [self.tableView removeHeader];
    self.headerView.headerCommunicationButton.enabled = NO;
    self.headerView.headerCommentButton.enabled = NO;
    self.headerView.headerLoveButton.hidden = YES;
    self.headerView.tipLabel.hidden = NO;
    [self.seeHouseButton removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController performSelector:@selector(addTitle:) withObject:@"房源详情"];
    [self addButtonWithImageName:@"fanhui" target:self action:@selector(dismissViewController) position:POSLeft];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Override methods -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (void)dismissViewController
{
    RESideMenu *sideMenuController = (RESideMenu *)self.presentingViewController;
    FZNavigationController *navController = (FZNavigationController *)sideMenuController.contentViewController;
    [self dismissViewControllerAnimated:YES completion:NULL];
    [navController popToRootViewControllerAnimated:NO];
}

@end
