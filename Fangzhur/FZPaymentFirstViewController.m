        //
//  FZPaymentFirstViewController.m
//  Fangzhur
//
//  Created by --超-- on 15/1/10.
//  Copyright (c) 2015年 Zc. All rights reserved.
//

#import "FZPaymentFirstViewController.h"
#import "FZScreenTitleLabel.h"
#import "FZScreenPickerCell.h"
#import "FZLabelCell.h"
#import "FZTextFieldCell.h"
#import "CommunityNameViewController.h"
#import "FZRentListViewController.h"
#import "FZMobileLoginViewController.h"
#import "FZPaymentSecondViewController.h"

#define ShowError(string)\
[JDStatusBarNotification showWithStatus:string dismissAfter:2 styleName:JDStatusBarStyleError]

@interface FZPaymentFirstViewController ()
<ChooseCommunityDelegate, FZTextFieldCellDelegate>

- (void)loadCommunityInfo;
- (void)configureNavigationBar;
- (void)configureTableView;

@end

@implementation FZPaymentFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.paymentModel = [[FZPaymentModel alloc] initWithHouseNumber:self.houseNumber];
    if (self.orderID) {
        [self.paymentModel getAndStoreCacheDataWithOrderID:self.orderID];
    }
    
    [self configureTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configureNavigationBar];
}

- (void)loadHouseDataWithHouseNumber:(NSString *)houseNumber
{
    self.houseNumber = houseNumber;
    
    if (houseNumber) {
        [self.paymentModel.firstCacheArray replaceObjectAtIndex:0 withObject:self.houseNumber];
        [self loadCommunityInfo];
    }
}

- (void)configureNavigationBar
{
    [self.navigationController performSelector:@selector(addTitle:) withObject:@"支付"];
    [self addButtonWithImageName:@"fanhui" target:self action:@selector(backButtonClicked) position:POSLeft];
    UIButton *button = [UIButton buttonWithFrame:CGRectMake(0, 0, 70, 30) title:@"收藏" fontSize:17 bgImageName:nil];
    button.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 0);
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(gotoContractHouseList) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)configureTableView
{
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self.tableView registerClass:[FZScreenPickerCell class] forCellReuseIdentifier:@"FZScreenPickerCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FZLabelCell" bundle:nil] forCellReuseIdentifier:@"FZLabelCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FZTextFieldCell" bundle:nil] forCellReuseIdentifier:@"FZTextFieldCell"];
    
    UIButton *footerButton = kFooterButtonWithName(@"下一步");
    [footerButton addTarget:self action:@selector(gotoNextStep) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = footerButton;
}

#pragma mark - 根据编号获取订单信息 -

- (void)loadCommunityInfo
{
    [JDStatusBarNotification showWithStatus:@"获取订单信息中，请稍后..."];
    [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleWhite];
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    
    [[FZRequestManager manager] getCommunityInfoWithHouseNumber:self.houseNumber houseType:@"1" complete:^(BOOL success, id responseObject) {
        [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
        if ([[self.paymentModel.firstCacheArray objectAtIndex:0] length] == 0) {
            return ;
        }
        
        if (success && responseObject) {
            [JDStatusBarNotification showWithStatus:@"信息已更新" dismissAfter:2];
            
            [self.paymentModel.firstCacheArray replaceObjectAtIndex:1 withObject:[responseObject objectForKey:@"borough_name"]];
            [self.paymentModel.firstCacheArray replaceObjectAtIndex:2 withObject:[responseObject objectForKey:@"borough_address"]];
        }
        else if (responseObject) {
            ShowError(@"不存在该房源编号!");
            [self.paymentModel.firstCacheArray replaceObjectAtIndex:0 withObject:@""];
        }
        
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view delegate -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        CommunityNameViewController *communityController = [[CommunityNameViewController alloc] init];
        communityController.nameDelegate = self;
        FZNavigationController *navController = [[FZNavigationController alloc] initWithRootViewController:communityController];
        [self presentViewController:navController animated:YES completion:nil];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FZScreenTitleLabel *titleLabel = [[FZScreenTitleLabel alloc] init];
    titleLabel.text = [[self.paymentModel sectionTitlesOfController:self] objectAtIndex:section];
    return titleLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.paymentModel.firstCacheArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = nil;
    
    if (indexPath.section == 1 || indexPath.section == 2) {
        FZLabelCell *labelCell = [tableView dequeueReusableCellWithIdentifier:@"FZLabelCell"];
        labelCell.tag = indexPath.section;
        labelCell.titleLabel.text = [self.paymentModel.firstCacheArray objectAtIndex:indexPath.section];
        
        cell = labelCell;
    }
    else {
        FZTextFieldCell *textfieldCell = [tableView dequeueReusableCellWithIdentifier:@"FZTextFieldCell"];
        textfieldCell.delegate = self;
        textfieldCell.cacheArray = self.paymentModel.firstCacheArray;
        textfieldCell.textField.placeholder =
        [self.paymentModel sectionContentsOfController:self section:indexPath.section];
        textfieldCell.textField.text = [self.paymentModel.firstCacheArray objectAtIndex:indexPath.section];
        textfieldCell.tag = indexPath.section;
        cell = textfieldCell;
        
        if (indexPath.section != 3) {
            [textfieldCell hideSideLabel];
        }
    }
    
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    return cell;
}


#pragma mark - Community search delegate -

- (void)selectCommunityName:(NSString *)name communityID:(NSString *)communityID address:(NSString *)address
{
    [self.paymentModel.firstCacheArray replaceObjectAtIndex:1 withObject:name];
    
    //自己重新选择小区后，房源编号要清空，区域归位
    self.houseNumber = @"";
    [self.paymentModel.firstCacheArray replaceObjectAtIndex:0 withObject:@""];
    [self.paymentModel.firstCacheArray replaceObjectAtIndex:2 withObject:address];
    [self.tableView reloadData];
}

- (void)textFieldCell:(FZTextFieldCell *)cell didEndEditing:(NSString *)text
{
    if (cell.tag == 0) {
        self.houseNumber = text;
        [self loadHouseDataWithHouseNumber:self.houseNumber];
    }
}

#pragma mark - Response events -

// 如果有必填项没有填入数据，那么回滚到相应位置
- (BOOL)checkImportantCell
{
    if ([[self.paymentModel.firstCacheArray objectAtIndex:1] isEqualToString:@"选择"]) {
        [JDStatusBarNotification showWithStatus:@"小区信息不完整" dismissAfter:2 styleName:JDStatusBarStyleError];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        return NO;
    }
    if ([[self.paymentModel.firstCacheArray objectAtIndex:3] isEqualToString:@"0"] ||
        [[self.paymentModel.firstCacheArray objectAtIndex:3] length] == 0) {
        [JDStatusBarNotification showWithStatus:@"房屋面积没有填入" dismissAfter:2 styleName:JDStatusBarStyleError];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        return NO;
    }
    
    return YES;
}

- (void)backButtonClicked
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)gotoContractHouseList
{
    JumpToLoginIfNeeded;
    
    FZRentListViewController *rentController = [[FZRentListViewController alloc] init];
    FZNavigationController *navController = [[FZNavigationController alloc] initWithRootViewController:rentController];
    [self presentViewController:navController animated:YES completion:NULL];
}

- (void)gotoNextStep
{
    if ([self checkImportantCell] == NO) {
        return;
    }

    FZPaymentSecondViewController *secondController = [[FZPaymentSecondViewController alloc] init];
    secondController.paymentModel = self.paymentModel;
    [self.navigationController pushViewController:secondController animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
