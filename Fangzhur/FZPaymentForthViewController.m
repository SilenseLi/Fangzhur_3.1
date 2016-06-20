//
//  FZPaymentForthViewController.m
//  Fangzhur
//
//  Created by --超-- on 15/1/15.
//  Copyright (c) 2015年 Zc. All rights reserved.
//

#import "FZPaymentForthViewController.h"
#import "FZboundTableViewCell.h"
#import "FZTextFieldCell.h"
#import "FZScreenTitleLabel.h"
#import "JCheckPhoneNumber.h"
#import "ProgressHUD.h"
#import "FZGenerateOrderViewController.h"
#import "FZLabelCell.h"
#import "FZBoundViewController.h"

@interface FZPaymentForthViewController ()

@property (nonatomic, strong) FZboundTableViewCell *boundCell;
@property (nonatomic, strong) UIButton *codeButton;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger counter;

- (void)prepareData;
- (void)configureNavigationBar;
- (void)configureTableView;

@end

@implementation FZPaymentForthViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareData];
    [self configureTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configureNavigationBar];
}

- (void)prepareData
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
    [self.timer setFireDate:[NSDate distantFuture]];
    self.counter = 60;
}

- (void)configureNavigationBar
{
    [self.navigationController performSelector:@selector(addTitle:) withObject:@"付款人信息"];
    [self addButtonWithImageName:@"fanhui" target:self action:@selector(backButtonClicked) position:POSLeft];
}

- (void)configureTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"FZTextFieldCell" bundle:nil]
         forCellReuseIdentifier:@"FZTextFieldCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FZboundTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"FZboundTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FZLabelCell" bundle:nil]
         forCellReuseIdentifier:@"FZLabelCell"];
    
    UIButton *footerButton = kFooterButtonWithName(@"下一步");
    [footerButton addTarget:self action:@selector(gotoNextStep) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = footerButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == self.paymentModel.forthCacheArray.count) {
        return 100;
    }
    else {
        return 70;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == self.paymentModel.forthCacheArray.count) {
        return 1;
    }
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == self.paymentModel.forthCacheArray.count) {
        return nil;
    }
    
    FZScreenTitleLabel *titleLabel = [[FZScreenTitleLabel alloc] init];
    titleLabel.text = [[self.paymentModel sectionTitlesOfController:self] objectAtIndex:section];;
    return titleLabel;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.paymentModel.forthCacheArray.count + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.section == self.paymentModel.forthCacheArray.count) {
        self.boundCell = [tableView dequeueReusableCellWithIdentifier:@"FZboundTableViewCell"];
        [self.boundCell.serviceButton addTarget:self action:@selector(treatyButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        cell = self.boundCell;
    }
    else if (indexPath.section == 0) {
        FZLabelCell *labelCell = [self.tableView dequeueReusableCellWithIdentifier:@"FZLabelCell"];
        labelCell.titleLabel.text = self.paymentModel.forthCacheArray[0];
        cell = labelCell;
    }
    else {
        FZTextFieldCell *textFieldCell = [tableView dequeueReusableCellWithIdentifier:@"FZTextFieldCell"];
        textFieldCell.cacheArray = self.paymentModel.forthCacheArray;
        for (UIView *subview in textFieldCell.contentView.subviews) {
            if ([subview isKindOfClass:[UIButton class]]) {
                [subview removeFromSuperview];
                break;
            }
        }
        
        textFieldCell.textField.placeholder =
        [self.paymentModel sectionContentsOfController:self section:indexPath.section];
        textFieldCell.textField.text = [self.paymentModel.forthCacheArray objectAtIndex:indexPath.section];
        [textFieldCell hideSideLabel];
        if (indexPath.section == 1) {
            textFieldCell.textField.keyboardType = UIKeyboardAppearanceDefault;
        }
        else if (indexPath.section == 2) {
            textFieldCell.textField.keyboardType = UIKeyboardTypeAlphabet;
        }
        else {
            textFieldCell.textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        
        if (indexPath.section == 4) {
            if (!self.codeButton) {
                self.codeButton = [UIButton buttonWithFrame:CGRectMake(SCREEN_WIDTH - 130, 7, 100, 30) title:@"获取验证码" fontSize:15 bgImageName:@"dibutiao_bg"];
                [self.codeButton setTitle:@"已发送" forState:UIControlStateDisabled];
                [self.codeButton addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
            }
            [textFieldCell.contentView addSubview:self.codeButton];
        }
        
        cell = textFieldCell;
    }
    
    cell.tag = indexPath.section;
    return cell;
}

#pragma mark - Response events -

// 如果有必填项没有填入数据，那么回滚到相应位置
- (BOOL)checkImportantCell
{
    NSInteger sectionNumber = self.paymentModel.forthCacheArray.count;
    
    for (int i = 0; i < sectionNumber; i++) {
        if ([self.paymentModel.forthCacheArray[i] length] == 0) {
            [JDStatusBarNotification showWithStatus:@"信息输入不完整" dismissAfter:2 styleName:JDStatusBarStyleError];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
            return NO;
        }
    }
    
    if ([self.paymentModel.forthCacheArray[2] length] > 18) {
        [JDStatusBarNotification showWithStatus:@"身份证号码输入有误" dismissAfter:2 styleName:JDStatusBarStyleError];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        return NO;
    }
    if (sectionNumber > 3) {//没有登录的时候要验证手机号
        NSString *phone = self.paymentModel.forthCacheArray[3];
        if (![JCheckPhoneNumber isMobileNumber:phone]) {
            phone = @"";
            [JDStatusBarNotification showWithStatus:@"手机号码格式错误" dismissAfter:2 styleName:JDStatusBarStyleError];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            return NO;
        }
    }
    if (!self.boundCell.choosebtn.selected) {
        [JDStatusBarNotification showWithStatus:@"请接受服务协议" dismissAfter:2 styleName:JDStatusBarStyleError];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.paymentModel.forthCacheArray.count] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        return NO;
    }
    
    return YES;
}

- (void)getCode
{
    NSString *phone = self.paymentModel.forthCacheArray[3];
    if (![JCheckPhoneNumber isMobileNumber:phone]) {
        [JDStatusBarNotification showWithStatus:@"手机号码格式错误" dismissAfter:2 styleName:JDStatusBarStyleError];
        return;
    }
    
    self.codeButton.enabled = NO;
    [[FZRequestManager manager] getCheckCodeOfUser:phone complete:^(BOOL success, id responseObject) {
        if (success) {
            self.counter = 60;
            [self.timer setFireDate:[NSDate distantPast]];
        }
        else {
            self.codeButton.enabled = YES;
        }
    }];
}

- (void)updateCounter:(NSTimer *)timer
{
    self.counter--;
    
    if (self.counter == 0) {
        [self.timer setFireDate:[NSDate distantFuture]];
        self.codeButton.enabled = YES;
    }
    
    [self.codeButton setTitle:[NSString stringWithFormat:@"已发送，%ds", (int)self.counter] forState:UIControlStateDisabled];
}


- (void)treatyButtonClicked
{
    FZBoundViewController *boundController = [[FZBoundViewController alloc] init];
    [self.navigationController pushViewController:boundController animated:YES];
}

- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)gotoNextStep
{
    if (![self checkImportantCell]) {
        return;
    }
    
    if (!FZUserInfoWithKey(Key_LoginToken)) {
        [ProgressHUD show:@"正在验证用户信息..." Interaction:NO];
        [[FZRequestManager manager] loginWithUserName:self.paymentModel.forthCacheArray[3] password:self.paymentModel.forthCacheArray[4] status:nil helpCode:@"空" complete:^(BOOL success, id userInfo) {
            [ProgressHUD dismiss];
            
            [[NSUserDefaults standardUserDefaults] setObject:self.paymentModel.forthCacheArray[3] forKey:Key_UserName];
            [[NSUserDefaults standardUserDefaults] setObject:[userInfo objectForKey:@"token"] forKey:Key_LoginToken];
            [[NSUserDefaults standardUserDefaults] setObject:[userInfo objectForKey:@"memberid"] forKey:Key_MemberID];
            [[NSUserDefaults standardUserDefaults] setObject:[userInfo objectForKey:@"role_type"] forKey:Key_RoleType];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:Key_HeadImage];
            
            FZGenerateOrderViewController *orderViewController = [[FZGenerateOrderViewController alloc] init];
            orderViewController.paymentModel = self.paymentModel;
            [self.navigationController pushViewController:orderViewController animated:YES];
            
            [[FZRequestManager manager] getUserInfoComplete:NULL];
        }];
    }
    else {
        FZGenerateOrderViewController *orderViewController = [[FZGenerateOrderViewController alloc] init];
        orderViewController.paymentModel = self.paymentModel;
        [self.navigationController pushViewController:orderViewController animated:YES];
    }
}

@end
