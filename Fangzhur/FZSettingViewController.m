//
//  FZSettingViewController.m
//  Fangzhur
//
//  Created by --Chao-- on 14-6-23.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZSettingViewController.h"
#import "FZAboutUsViewController.h"
//#import "BPush.h"

@interface FZSettingViewController ()
{
    NSArray *_dataArray;
}

- (void)UIConfig;
- (void)prepareData;
- (void)checkVersion;

@end

@implementation FZSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self UIConfig];
    [self prepareData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self UIConfig];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)UIConfig
{
    [self.navigationController performSelector:@selector(addTitle:) withObject:@"设置"];
    [self addButtonWithImageName:@"fanhui" target:self action:@selector(dismissViewController) position:POSLeft];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)prepareData
{
    _dataArray = [[NSArray alloc] initWithObjects:
                  @"推送通知", @"检查更新", @"给我们评价", @"关于我们", nil];
}

#pragma mark - 网络请求 -

- (void)checkVersion
{
    [[FZRequestManager manager] checkVersionHandler:^(NSString *versionString) {
        if (!versionString) {
            [JDStatusBarNotification showWithStatus:@"版本检查失败，请稍后重试!" dismissAfter:2 styleName:JDStatusBarStyleError];
            return ;
        }
        
        if (![versionString isEqualToString:kAppCurrentVersion]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"最新版本（%@）已上线，\n请您下载更新!", versionString] delegate:self cancelButtonTitle:nil otherButtonTitles:@"去更新", nil];
            alert.delegate = self;
            [alert show];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"已是最新版本" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppDownload]];
    }
}

#pragma mark - Table view delegate -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 3) {
        FZAboutUsViewController *aboutController = [[FZAboutUsViewController alloc] init];
        [self.navigationController pushViewController:aboutController animated:YES];
    }
    else if (indexPath.row == 2) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppComment]];
    }
    else if (indexPath.row == 1) {
        [self checkVersion];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"打开推送通知可以接收到\n最新房源咨询" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alert show];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    if (indexPath.row == 0) {
        UISwitch *pushSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 9, 0, 0)];
        [cell.contentView addSubview:pushSwitch];
        pushSwitch.on = YES;
        [pushSwitch addTarget:self action:@selector(pushOpenOrNot:) forControlEvents:UIControlEventValueChanged];
        NSLog(@"%@", pushSwitch);
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = [_dataArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - Response events -

- (void)dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pushOpenOrNot:(UISwitch *)sender
{
//    if (sender.on) {
//        [BPush bindChannel];
//    }
//    else {
//        [BPush unbindChannel];
//    }
}

@end
