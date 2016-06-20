//
//  FZPaymentSecondViewController.m
//  Fangzhur
//
//  Created by --超-- on 15/1/12.
//  Copyright (c) 2015年 Zc. All rights reserved.
//

#import "FZPaymentSecondViewController.h"
#import "THDatePickerViewController.h"
#import "FZTextFieldCell.h"
#import "FZLabelCell.h"
#import "FZScreenPickerCell.h"
#import "FZPaymentThirdViewController.h"
#import "FZScreenTitleLabel.h"
#import "FZDateMethods.h"
@interface FZPaymentSecondViewController ()
<THDatePickerDelegate>

@property (nonatomic, strong) THDatePickerViewController *datePicker;
@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, strong) NSDateFormatter *formatter;

- (void)prepareData;
- (void)configureNavigationBar;
- (void)configureTableView;

@end

@implementation FZPaymentSecondViewController

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareData
{
    self.currentDate = [NSDate date];
    self.formatter = [[NSDateFormatter alloc] init];
    [self.formatter setDateFormat:@"yyyy'-'MM'-'dd"];
}

- (void)configureNavigationBar
{
    [self.navigationController performSelector:@selector(addTitle:) withObject:@"支付"];
    [self addButtonWithImageName:@"fanhui" target:self action:@selector(backButtonClicked) position:POSLeft];
}

- (void)configureTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"FZTextFieldCell" bundle:nil] forCellReuseIdentifier:@"FZTextFieldCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FZLabelCell" bundle:nil]
         forCellReuseIdentifier:@"FZLabelCell"];
    [self.tableView registerClass:[FZScreenPickerCell class] forCellReuseIdentifier:@"FZScreenPickerCell"];
    UIButton *footerButton = kFooterButtonWithName(@"下一步");
    [footerButton addTarget:self action:@selector(gotoNextStep) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = footerButton;
    
    [self addDatePicker];
}

- (void)addDatePicker
{
    self.datePicker = [THDatePickerViewController datePicker];
    self.datePicker.date = self.currentDate;
    self.datePicker.delegate = self;
    [self.datePicker setAllowClearDate:NO];
    [self.datePicker setClearAsToday:YES];
    [self.datePicker setAutoCloseOnSelectDate:NO];
    [self.datePicker setDisableHistorySelection:YES];
    [self.datePicker setDisableFutureSelection:NO];
    
    [self.datePicker setSelectedBackgroundColor:RGBColor(125, 208, 0)];
    [self.datePicker setCurrentDateColor:RGBColor(242, 121, 53)];
    [self.datePicker setCurrentDateColorSelected:[UIColor yellowColor]];
}

#pragma mark - Table view delegate -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 4) {
        [self changeDate];
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
    return self.paymentModel.secondCacheArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 3) {
        FZTextFieldCell *textFieldCell = [tableView dequeueReusableCellWithIdentifier:@"FZTextFieldCell"];
        textFieldCell.cacheArray = self.paymentModel.secondCacheArray;
        textFieldCell.textField.placeholder =
        [self.paymentModel sectionContentsOfController:self section:indexPath.section];
        textFieldCell.textField.text = [self.paymentModel.secondCacheArray objectAtIndex:indexPath.section];
        textFieldCell.rightLabel.text = @"元";
        textFieldCell.leftLabel.hidden = YES;
        cell = textFieldCell;
    }
    else if (indexPath.section == 2) {
        FZScreenPickerCell *pickerCell = [tableView dequeueReusableCellWithIdentifier:@"FZScreenPickerCell"];
        [pickerCell updatePickerWithItems:[self.paymentModel sectionContentsOfController:self section:indexPath.section]
                            selectedIndex:[[self.paymentModel.secondCacheArray objectAtIndex:indexPath.section] intValue]];
        [pickerCell addTarget:self action:@selector(rentMonthNumberChanged)];
        cell = pickerCell;
    }
    else {
        FZLabelCell *labelCell = [tableView dequeueReusableCellWithIdentifier:@"FZLabelCell"];
        labelCell.titleLabel.text = [self.paymentModel.secondCacheArray objectAtIndex:indexPath.section];
        cell = labelCell;
    }

    if ([cell respondsToSelector:@selector(setCacheArray:)]) {
        [cell performSelector:@selector(setCacheArray:) withObject:self.paymentModel.secondCacheArray];
    }
    
    cell.tag = indexPath.section;
    return cell;
}

#pragma mark - Date picker delegate -

- (void)datePickerDonePressed:(THDatePickerViewController *)datePicker
{
    self.currentDate = datePicker.date;
    NSInteger monthNumber = [self.paymentModel.secondCacheArray[2] integerValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd"];
    NSString *currentDateString = [formatter stringFromDate:self.currentDate];
    currentDateString = [NSString stringWithFormat:@"%@ 至 %@",
                         currentDateString,
                        [formatter stringFromDate:[FZDateMethods dateFrom:self.currentDate afterMonthNumber:monthNumber]]];
    [self.paymentModel.secondCacheArray replaceObjectAtIndex:4 withObject:currentDateString];
    [self.tableView reloadData];
    
    [self dismissSemiModalView];
}

- (void)datePickerCancelPressed:(THDatePickerViewController *)datePicker
{
    [self dismissSemiModalView];
}

#pragma mark - Response events -

- (void)changeDate
{
    [self presentSemiViewController:self.datePicker withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                 @(NO), KNSemiModalOptionKeys.pushParentBack,
                                                                 @(0.15f), KNSemiModalOptionKeys.animationDuration,
                                                                 @(0.3f), KNSemiModalOptionKeys.shadowOpacity, nil]];
    
    FZTextFieldCell *cell = (FZTextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    [cell.textField resignFirstResponder];
    
}

- (void)rentMonthNumberChanged
{
    NSInteger monthNumber = [self.paymentModel.secondCacheArray[2] integerValue] + 1;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd"];
    NSString *currentDateString = [formatter stringFromDate:self.currentDate];
    currentDateString = [NSString stringWithFormat:@"%@ 至 %@",
                         currentDateString,
                         [formatter stringFromDate:[FZDateMethods dateFrom:self.currentDate afterMonthNumber:monthNumber]]];
    [self.paymentModel.secondCacheArray replaceObjectAtIndex:4 withObject:currentDateString];
    
    FZLabelCell *dateCell =
    (FZLabelCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4]];
    dateCell.titleLabel.text = currentDateString;
}

// 如果有必填项没有填入数据，那么回滚到相应位置
- (BOOL)checkImportantCell
{
    if ([self.paymentModel.secondCacheArray[0] length] == 0 ||
        [self.paymentModel.secondCacheArray[0] intValue] == 0) {
        [JDStatusBarNotification showWithStatus:@"请填写租金" dismissAfter:2 styleName:JDStatusBarStyleError];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        return NO;
    }
    if ([self.paymentModel.secondCacheArray[4] length] == 0) {
        [JDStatusBarNotification showWithStatus:@"请选择日期" dismissAfter:2 styleName:JDStatusBarStyleError];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        return NO;
    }
    
    return YES;
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
    
    FZPaymentThirdViewController *thirdViewController = [[FZPaymentThirdViewController alloc] init];
    thirdViewController.paymentModel = self.paymentModel;
    [self.navigationController pushViewController:thirdViewController animated:YES];
}

@end
