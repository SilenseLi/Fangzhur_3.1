//
//  FZScreenViewController.m
//  Fangzhur
//
//  Created by --超-- on 14/11/8.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZScreenViewController.h"
#import "UIButton+ZCCustomButtons.h"
#import "FZScreenTitleLabel.h"
#import "FZScreenPickerCell.h"
#import "FZScreenRangeSliderCell.h"
#import "FZScreenDateCell.h"
#import "FZScreenModel.h"
#import "THDatePickerViewController.h"
#import "FZHouseListViewController.h"

@interface FZScreenViewController () <THDatePickerDelegate>

@property (nonatomic, strong) THDatePickerViewController *datePicker;
@property (nonatomic, retain) NSDate *currentDate;
@property (nonatomic, retain) NSDateFormatter *formatter;
@property (nonatomic, strong) FZScreenModel *screenModel;

- (void)configureUI;
- (void)addDatePicker;

@end

@implementation FZScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.screenModel = [[FZScreenModel alloc] initWithScreenType:self.screenType];
    self.currentDate = [NSDate date];
    self.formatter = [[NSDateFormatter alloc] init];
    [self.formatter setDateFormat:@"yyyy'-'MM'-'dd"];
    
    if (!FZUserInfoWithKey(key_CityRegion)) {
        [[FZRequestManager manager] getRegionInfo];
    }
    if (!FZUserInfoWithKey(Key_Subway)) {
        [[FZRequestManager manager] getSubwayInfo];
    }
    
    [self configureUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    FZNavigationController *navController = (FZNavigationController *)self.navigationController;
    [navController addTitle:@"筛选"];
    [self addButtonWithImageName:@"fanhui" target:self action:@selector(dismissScreenView:) position:POSLeft];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configureUI
{
    UIButton *screenButton = kBottomButtonWithName(@"筛选");
    [screenButton addTarget:self action:@selector(returnHouseList) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:screenButton];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[FZScreenPickerCell class] forCellReuseIdentifier:@"FZScreenPickerCell"];
    [self.tableView registerClass:[FZScreenPickerCell class] forCellReuseIdentifier:@"FZRegionPickerCell"];
    [self.tableView registerClass:[FZScreenDateCell class] forCellReuseIdentifier:@"FZScreenDateCell"];
    [self.tableView registerClass:[FZScreenRangeSliderCell class] forCellReuseIdentifier:@"FZScreenRangeSliderCell"];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 11) {
        return 150;
    }
    else {
        return 80;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

//TODO:添加section title
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FZScreenTitleLabel *titleLabel = [[FZScreenTitleLabel alloc] init];
    titleLabel.font = [UIFont fontWithName:kFontName size:17];
    titleLabel.text = [self.screenModel.sectionTitles objectAtIndex:section];
    
    return titleLabel;
}

#pragma mark - Table view data source -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.screenModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSString *sectionTitle = [self.screenModel.sectionTitles objectAtIndex:indexPath.section];
    
    if ([sectionTitle hasPrefix:@"价格"] || [sectionTitle hasPrefix:@"面积"]) {
        NSArray *tempArray = [self.screenModel contentsOfSection:
                              [self.screenModel.sectionTitles objectAtIndex:indexPath.section]];
        FZScreenRangeSliderCell *rangeCell = [tableView dequeueReusableCellWithIdentifier:@"FZScreenRangeSliderCell"];
        rangeCell.tag = indexPath.section;

        [rangeCell setCacheArray:self.screenModel.cacheArray];
        [rangeCell addRangeSliderWithMinimumValue:[tempArray.firstObject doubleValue]
                                     maximumValue:[[tempArray objectAtIndex:1] doubleValue]
                                      stepValue:[tempArray.lastObject doubleValue]];
        
        if ([sectionTitle hasPrefix:@"面积"]) {
            [rangeCell hideTheRightSlider];
        }
        
        cell = rangeCell;
    }
    else if ([sectionTitle hasSuffix:@"时间"]) {
        FZScreenDateCell *dateCell = [tableView dequeueReusableCellWithIdentifier:@"FZScreenDateCell"];
        dateCell.tag = indexPath.section;
        
        dateCell.cellDate = [self.screenModel.cacheArray objectAtIndex:indexPath.section];
        [dateCell.dateButton addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventTouchUpInside];
        
        cell = dateCell;
    }
    else {
        FZScreenPickerCell *pickerCell = nil;
        if ([sectionTitle isEqualToString:@"城区"] ||
            [sectionTitle isEqualToString:@"商圈"] ||
            [sectionTitle isEqualToString:@"地铁"]) {
            pickerCell = [tableView dequeueReusableCellWithIdentifier:@"FZRegionPickerCell"];
        }
        else {
            pickerCell = [tableView dequeueReusableCellWithIdentifier:@"FZScreenPickerCell"];
        }
        
        pickerCell.tag = indexPath.section;
        [pickerCell setCacheArray:self.screenModel.cacheArray];
        if (indexPath.section >= 0 || indexPath.section <= 2) {
            [pickerCell addTarget:self action:@selector(pickerValueChanged:)];
        }
        
        NSArray *items = [self.screenModel contentsOfSection:[self.screenModel.sectionTitles objectAtIndex:indexPath.section]];
        NSInteger selectedIndex = [[self.screenModel.cacheArray objectAtIndex:indexPath.section] intValue];
        [pickerCell updatePickerWithItems:items selectedIndex:selectedIndex];
        
        cell = pickerCell;
    }
    
    return cell;
}

#pragma mark - Date picker delegate -

- (void)datePickerDonePressed:(THDatePickerViewController *)datePicker
{
    self.currentDate = datePicker.date;
    [self.screenModel.cacheArray replaceObjectAtIndex:11 withObject:[self.formatter stringFromDate:self.currentDate]];
    [self.tableView reloadData];
    
    [self dismissSemiModalView];
}

- (void)datePickerCancelPressed:(THDatePickerViewController *)datePicker
{
    [self dismissSemiModalView];
}

- (void)datePicker:(THDatePickerViewController *)datePicker selectedDate:(NSDate *)selectedDate
{
    NSLog(@"Date selected: %@",[self.formatter stringFromDate:selectedDate]);
}


#pragma mark - 响应事件 -

- (void)changeDate:(UIButton *)sender
{
    [self presentSemiViewController:self.datePicker withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                 @(NO), KNSemiModalOptionKeys.pushParentBack,
                                                                 @(0.15f), KNSemiModalOptionKeys.animationDuration,
                                                                 @(0.3f), KNSemiModalOptionKeys.shadowOpacity, nil]];
}

- (void)pickerValueChanged:(FZScreenPickerCell *)sender
{
    //防止滚轮滑动时，滑动tableview造成的越界
    if (sender.pickerView.selectedItem >= sender.items.count) {
        return;
    }
    
    //如果上次的选中和该次选中相同，不进行视图刷新
    self.screenModel.selectedRegion = [sender.items objectAtIndex:sender.pickerView.selectedItem];
    if ([[self.screenModel.cacheArray objectAtIndex:sender.tag] intValue] == sender.pickerView.selectedItem) {
        return;
    }
    
    if (sender.tag == 0) {
        //切换城区，商圈、地铁归位
        [self.screenModel.cacheArray replaceObjectAtIndex:1 withObject:@"0"];
        [self.screenModel.cacheArray replaceObjectAtIndex:2 withObject:@"0"];
        
        FZScreenPickerCell *cell = (FZScreenPickerCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        NSArray *items = [self.screenModel contentsOfSection:[self.screenModel.sectionTitles objectAtIndex:cell.tag]];
        [cell updatePickerWithItems:items selectedIndex:0];
        
        cell = (FZScreenPickerCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
        items = [self.screenModel contentsOfSection:[self.screenModel.sectionTitles objectAtIndex:cell.tag]];
        [cell updatePickerWithItems:items selectedIndex:0];
        
    }
    else if (sender.tag == 1) {
        //切换商圈，地铁归位
        [self.screenModel.cacheArray replaceObjectAtIndex:2 withObject:@"0"];
        
        FZScreenPickerCell *cell = (FZScreenPickerCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
        NSArray *items = [self.screenModel contentsOfSection:[self.screenModel.sectionTitles objectAtIndex:cell.tag]];
        [cell updatePickerWithItems:items selectedIndex:0];
    }
    else if (sender.tag == 2) {
        //切换地铁，城区，商圈归位
        [self.screenModel.cacheArray replaceObjectAtIndex:0 withObject:@"0"];
        [self.screenModel.cacheArray replaceObjectAtIndex:1 withObject:@"0"];
        
        FZScreenPickerCell *cell = (FZScreenPickerCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        NSArray *items = [self.screenModel contentsOfSection:[self.screenModel.sectionTitles objectAtIndex:cell.tag]];
        [cell updatePickerWithItems:items selectedIndex:0];
        
        cell = (FZScreenPickerCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        items = [self.screenModel contentsOfSection:[self.screenModel.sectionTitles objectAtIndex:cell.tag]];
        [cell updatePickerWithItems:items selectedIndex:0];
    }
}

- (void)dismissScreenView:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)returnHouseList
{
    FZHouseListViewController *houseListViewController = (FZHouseListViewController *)self.bindsController;
    houseListViewController.houseType = self.screenType;
    [self.screenModel.cacheArray addObject:@"Screen"];
    houseListViewController.requestArray = self.screenModel.cacheArray;
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [houseListViewController.tableView headerBeginRefreshing];
    }];
}

@end
