//
//  FZPaymentThirdViewController.m
//  Fangzhur
//
//  Created by --超-- on 15/1/12.
//  Copyright (c) 2015年 Zc. All rights reserved.
//

#import "FZPaymentThirdViewController.h"
#import "THContactPickerViewController.h"
#import "IQActionSheetPickerView.h"
#import "FZScreenPickerCell.h"
#import "FZLabelCell.h"
#import "FZTextFieldCell.h"
#import "FZboundTableViewCell.h"
#import "FZScreenTitleLabel.h"
#import "JCheckPhoneNumber.h"
#import "FZPaymentForthViewController.h"
#import "FZServiceViewController.h"
#import "FZPayPeopleViewController.h"

@interface FZPaymentThirdViewController ()
<UITextFieldDelegate, FZTextFieldCellDelegate, IQActionSheetPickerViewDelegate>

@property (nonatomic, strong) IQActionSheetPickerView *pickerView;
@property (nonatomic, strong) FZboundTableViewCell *boundCell;

- (void)prepareData;
- (void)configureNavigationBar;
- (void)configureTableView;

@end

@implementation FZPaymentThirdViewController

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
    [self.tableView reloadData];
}

- (void)prepareData
{
    if(![[EGOCache globalCache] hasCacheForKey:@"Banklist"]){
        [[FZRequestManager manager] requestBankListHandler:^(NSArray *bankArray) {
            for (NSDictionary *bankInfoDict in [[EGOCache globalCache] plistForKey:@"Banklist"]) {
                [self.paymentModel.bankIDArray addObject:[bankInfoDict objectForKey:@"id"]];
                [self.paymentModel.bankNameArray addObject:[bankInfoDict objectForKey:@"name"]];
            }
        }];
    }
    else {
        for (NSDictionary *bankInfoDict in [[EGOCache globalCache] plistForKey:@"Banklist"]) {
            [self.paymentModel.bankIDArray addObject:[bankInfoDict objectForKey:@"id"]];
            [self.paymentModel.bankNameArray addObject:[bankInfoDict objectForKey:@"name"]];
        }
    }
}

- (void)configureNavigationBar
{
    [self.navigationController performSelector:@selector(addTitle:) withObject:@"房东账号信息"];
    [self addButtonWithImageName:@"fanhui" target:self action:@selector(backButtonClicked) position:POSLeft];
    
    UIButton *button = [UIButton buttonWithFrame:CGRectMake(0, 0, 70, 30) title:@"收款人" fontSize:17 bgImageName:nil];
    button.titleEdgeInsets = UIEdgeInsetsMake(5, -10, 0, 0);
    button.imageEdgeInsets = UIEdgeInsetsMake(3, 35, 0, 0);
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)configureTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"FZTextFieldCell" bundle:nil]
         forCellReuseIdentifier:@"FZTextFieldCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FZboundTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"FZboundTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FZLabelCell" bundle:nil]
         forCellReuseIdentifier:@"FZLabelCell"];
    [self.tableView registerClass:[FZScreenPickerCell class]
           forCellReuseIdentifier:@"FZScreenPickerCell"];
    
    UIButton *footerButton = kFooterButtonWithName(@"下一步");
    [footerButton addTarget:self action:@selector(gotoNextStep) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = footerButton;
    
    self.pickerView = [[IQActionSheetPickerView alloc] initWithTitle:@"开户银行" delegate:self];
    [self.pickerView setTitlesForComponenets:@[self.paymentModel.bankNameArray]];
}

#pragma mark - Table view delegate -

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 6) {
        return nil;
    }
    
    FZScreenTitleLabel *titleLabel = [[FZScreenTitleLabel alloc] init];
    titleLabel.text = [[self.paymentModel sectionTitlesOfController:self] objectAtIndex:section];
    return titleLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == self.paymentModel.thirdCacheArray.count) {
        return 100;
    }
    return 70;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == self.paymentModel.thirdCacheArray.count) {
        return 1;
    }
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
    return self.paymentModel.thirdCacheArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        FZScreenPickerCell *screenCell = [tableView dequeueReusableCellWithIdentifier:@"FZScreenPickerCell"];
        [screenCell updatePickerWithItems:@[@"个人",@"公司"]
                            selectedIndex:[[self.paymentModel.thirdCacheArray objectAtIndex:indexPath.section] intValue]];
        screenCell.cacheArray = self.paymentModel.thirdCacheArray;
        cell = screenCell;
    }
    else if (indexPath.section == 6) {
        self.boundCell = [tableView dequeueReusableCellWithIdentifier:@"FZboundTableViewCell"];
        [self.boundCell.serviceButton addTarget:self action:@selector(treatyButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        self.boundCell.titleLabel.text = @"";
        self.boundCell.bankcardLabel.text = @"我已接受";
        [self.boundCell.serviceButton setTitle:@"《用户服务协议》" forState:UIControlStateNormal];
        cell = self.boundCell;
    }
    else {
        FZTextFieldCell *textFieldCell = [tableView dequeueReusableCellWithIdentifier:@"FZTextFieldCell"];
        textFieldCell.cacheArray = self.paymentModel.thirdCacheArray;
        textFieldCell.delegate = self;
        textFieldCell.textField.placeholder =
        [self.paymentModel sectionContentsOfController:self section:indexPath.section];
        textFieldCell.textField.text = [self.paymentModel.thirdCacheArray objectAtIndex:indexPath.section];
        [textFieldCell hideSideLabel];
        if (indexPath.section == 3) {
            textFieldCell.textField.delegate = self;
        }
        for (UIView *subview in textFieldCell.contentView.subviews) {
            if ([subview isKindOfClass:[UIButton class]]) {
                [subview removeFromSuperview];
                break;
            }
        }
        if (indexPath.section != 2 &&
            indexPath.section != 5) {
            textFieldCell.textField.keyboardType = UIKeyboardTypeDefault;
        }
        else {
            textFieldCell.textField.keyboardType = UIKeyboardTypeNumberPad;
        }
    
        if (indexPath.section == 5) {
            textFieldCell.delegate = self;
            UIButton * button=[UIButton buttonWithFrame:CGRectMake(SCREEN_WIDTH - 70, 7, 30, 30) bgImage:[UIImage imageNamed:@"dianhuabo"]];
            [button addTarget:self action:@selector(gotoChooseContact) forControlEvents:UIControlEventTouchUpInside];
            [textFieldCell.contentView addSubview:button];
        }
        
        cell = textFieldCell;
    }
    
    cell.tag = indexPath.section;
    return cell;
}


#pragma mark - Response events -

- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonClicked
{
    FZPayPeopleViewController *peopleViewController = [[FZPayPeopleViewController alloc] init];
    peopleViewController.paymentModel = self.paymentModel;
    [self.navigationController pushViewController:peopleViewController animated:YES];
}

// 如果有必填项没有填入数据，那么回滚到相应位置
- (BOOL)checkImportantCell
{
    for (int i = 0; i < self.paymentModel.thirdCacheArray.count; i++) {
        if ([self.paymentModel.thirdCacheArray[i] length] == 0) {
            [JDStatusBarNotification showWithStatus:@"信息输入不完整" dismissAfter:2 styleName:JDStatusBarStyleError];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
            return NO;
        }
    }
    
    if ([self.paymentModel.thirdCacheArray[2] length] < 16) {
        [JDStatusBarNotification showWithStatus:@"请输入正确的银行卡号" dismissAfter:2 styleName:JDStatusBarStyleError];
        return NO;
    }
    
    NSString *phone = self.paymentModel.thirdCacheArray[5];
    phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if (![JCheckPhoneNumber isMobileNumber:phone]) {
        phone = @"";
        [JDStatusBarNotification showWithStatus:@"手机号码格式错误" dismissAfter:2 styleName:JDStatusBarStyleError];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:5] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        return NO;
    }
    if (!self.boundCell.choosebtn.selected) {
        [JDStatusBarNotification showWithStatus:@"请接受用户服务协议" dismissAfter:2 styleName:JDStatusBarStyleError];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:5] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        return NO;
    }
    
    return YES;
}

- (void)gotoChooseContact
{
    THContactPickerViewController * contactPicker=[[THContactPickerViewController alloc] init];
    contactPicker.textFieldCell = (FZTextFieldCell *)[self.tableView cellForRowAtIndexPath:
                                                      [NSIndexPath indexPathForRow:0 inSection:5]];
    UINavigationController * navController=[[UINavigationController alloc] initWithRootViewController:contactPicker];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)treatyButtonClicked
{
    FZServiceViewController *serviceViewController = [[FZServiceViewController alloc] init];
    [self.navigationController pushViewController:serviceViewController animated:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.pickerView show];
    
    //房子选择开户地后，在选择银行时，视图之间的相互覆盖
    FZTextFieldCell *cell = (FZTextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4]];
    [cell.textField resignFirstResponder];
    cell = (FZTextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    [cell.textField resignFirstResponder];
    
    return NO;
}

- (void)textFieldCell:(FZTextFieldCell *)cell didEndEditing:(NSString *)text
{
    if (cell.tag == 2) {
        [self.paymentModel.thirdCacheArray replaceObjectAtIndex:2 withObject:text];
    }
}

#pragma mark - 选择银行 -

- (void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didChangeRow:(NSInteger)row inComponent:(NSInteger)component
{
}

- (void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectTitles:(NSArray *)titles
{
    FZTextFieldCell *cell = (FZTextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    cell.textField.text = [titles lastObject];
    [self.paymentModel.thirdCacheArray replaceObjectAtIndex:cell.tag withObject:titles.lastObject];
}

- (void)gotoNextStep
{
    if ([self checkImportantCell] == NO) {
        return;
    }
    
    FZPaymentForthViewController *forthViewController = [[FZPaymentForthViewController alloc] init];
    forthViewController.paymentModel = self.paymentModel;
    [self.navigationController pushViewController:forthViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
