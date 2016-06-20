//
//  FZInformViewController.m
//  Fangzhur
//
//  Created by --超-- on 14-7-18.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZInformViewController.h"
#import "FZInformCell.h"
#import "FZOrdersViewController.h"

@interface FZInformViewController () <UITextViewDelegate>
{
    FZInformCell *_informCell;
}

- (void)UIConfig;

@end

@implementation FZInformViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self UIConfig];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController performSelector:@selector(addTitle:) withObject:@"举报"];
    [self addButtonWithImageName:@"fanhui" target:self action:@selector(backToOrderList) position:POSLeft];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)UIConfig
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"FZInformCell" bundle:nil] forCellReuseIdentifier:@"FZInformCell"];
}

- (void)backToOrderList
{
    [_informCell.describeTextView resignFirstResponder];
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}


#pragma mark - Table view delegate -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 450;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     _informCell = [tableView dequeueReusableCellWithIdentifier:@"FZInformCell"];
    _informCell.describeTextView.delegate = self;
    [_informCell fillDataWithAgentInfo:_agentInfo orderNum:_orderNum];
    [_informCell.submitButton addTarget:self action:@selector(submitInformResult) forControlEvents:UIControlEventTouchUpInside];
    
    return _informCell;
}

#pragma mark - 举报订单 -

- (void)submitInformResult
{
    [_informCell.describeTextView resignFirstResponder];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self getInformType], @"type",
                                _informCell.describeTextView.text, @"desc",
                                _orderNum, @"id",
                                FZUserInfoWithKey(Key_LoginToken), @"token",
                                FZUserInfoWithKey(Key_UserName), @"username",
                                FZUserInfoWithKey(Key_MemberID), @"member_id", nil];
    [[FZRequestManager manager] informOrderWithParameters:parameters complete:^(BOOL success, id responseObject) {
        if (success) {
            [JDStatusBarNotification showWithStatus:@"举报成功" dismissAfter:2];
        }
        else {
            [JDStatusBarNotification showWithStatus:@"举报失败" dismissAfter:2 styleName:JDStatusBarStyleError];
        }
    }];
}

- (NSString *)getInformType
{
    if ([_informCell.typeField.text isEqualToString:@"举报顾问"] ||
        [_informCell.typeField.text length] == 0) {
        return @"1";
    }
    else {
        return @"2";
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.tableView setContentOffset:CGPointMake(0, 230) animated:YES];
}

@end
