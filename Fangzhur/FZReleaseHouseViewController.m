//
//  FZReleaseHouseViewController.m
//  Fangzhur
//
//  Created by --超-- on 14/11/30.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZReleaseHouseViewController.h"
#import "THDatePickerViewController.h"
#import "CommunityNameViewController.h"
#import "FZPhotoViewController.h"

#import "FZScreenTitleLabel.h"
#import "FZLabelCell.h"
#import "FZTextFieldCell.h"
#import "FZTextViewCell.h"
#import "FZCounterCell.h"
#import "FZScreenDateCell.h"
#import "FZScreenPickerCell.h"
#import "FZEquipmentsSelector.h"

@interface FZReleaseHouseViewController () <THDatePickerDelegate, ChooseCommunityDelegate>

@property (nonatomic, strong) THDatePickerViewController *datePicker;
@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) FZNavigationController *communityController;
@property (nonatomic, strong) FZEquipmentsSelector *equipmentSelector;

- (void)configureUI;
- (BOOL)checkImportantCell;

@end

@implementation FZReleaseHouseViewController

- (instancetype)initWithReleaseType:(NSString *)releaseType houseType:(NSString *)houseType
{
    self = [super init];
    
    if (self) {
        self.paramDict = [[NSMutableDictionary alloc] init];
        self.releaseModel = [[FZReleaseHouseModel alloc] initWithReleaseType:releaseType houseType:houseType];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentDate = [NSDate date];
    self.formatter = [[NSDateFormatter alloc] init];
    [self.formatter setDateFormat:@"yyyy'-'MM'-'dd"];
    
    [self configureUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureUI
{
    [self addTipLabelWithHeight:200 tipString:@"房屋信息越完善看到的人会越多呦!"];
    
    UIButton *footerButton = kFooterButtonWithName(@"下一步");
    [footerButton addTarget:self action:@selector(gotoNextStep) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = footerButton;
    self.tableView.showsVerticalScrollIndicator = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FZCounterCell" bundle:nil] forCellReuseIdentifier:@"FZCounterCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FZLabelCell" bundle:nil] forCellReuseIdentifier:@"FZLabelCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FZTextViewCell" bundle:nil] forCellReuseIdentifier:@"FZTextViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FZTextFieldCell" bundle:nil] forCellReuseIdentifier:@"FZTextFieldCell"];
    [self.tableView registerClass:[FZScreenPickerCell class] forCellReuseIdentifier:@"FZScreenPickerCell"];
    [self.tableView registerClass:[FZScreenDateCell class] forCellReuseIdentifier:@"FZScreenDateCell"];
    
    [self addDatePicker];
    
    self.equipmentSelector = [[FZEquipmentsSelector alloc] init];
    self.equipmentSelector.dataArray = [self.releaseModel contentsOfSectionTitle:@"配套设施"];
    self.equipmentSelector.cacheArray = self.releaseModel.cacheArray;
    
    //选择配套设施结束后，把请求参数传入参数字典
    __weak typeof(self) weakSelf = self;
    [self.equipmentSelector setFinishedBlock:^(NSString *equipments) {
        [weakSelf.tableView reloadData];
        [weakSelf.paramDict setObject:equipments forKey:@"house_support"];
    }];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        CommunityNameViewController *communityController = [[CommunityNameViewController alloc] init];
        communityController.nameDelegate = self;
        FZNavigationController *navController = [[FZNavigationController alloc] initWithRootViewController:communityController];
        [self presentViewController:navController animated:YES completion:nil];
    }
    else if (indexPath.section == tableView.numberOfSections - 2) {
        self.equipmentSelector.tag = indexPath.section;
        [self.equipmentSelector show];
    }
    else if (indexPath.section == 2) {
        [self changeDate];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == tableView.numberOfSections - 1) {
        return 130;
    }
    else {
        return 70;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

//TODO:添加section title
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FZScreenTitleLabel *titleLabel = [[FZScreenTitleLabel alloc] init];
    titleLabel.text = [self.releaseModel.sectionTitles objectAtIndex:section];
    
    return titleLabel;
}

#pragma mark - Table view data source -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.releaseModel.sectionTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sectionNumber = tableView.numberOfSections;
    UITableViewCell *cell = nil;
    NSString *sectionTitle = [self.releaseModel.sectionTitles objectAtIndex:indexPath.section];
    
    if ((indexPath.section >= 0 && indexPath.section <= 2) ||
        (indexPath.section == sectionNumber - 2)) {
        
        FZLabelCell *labelCell = [tableView dequeueReusableCellWithIdentifier:@"FZLabelCell"];
        labelCell.tag = indexPath.section;
        labelCell.titleLabel.text = [self.releaseModel.cacheArray objectAtIndex:indexPath.section];
        
        cell = labelCell;
    }
    else if (indexPath.section == 3) {
        
        FZTextFieldCell *textFieldCell = [tableView dequeueReusableCellWithIdentifier:@"FZTextFieldCell"];
        textFieldCell.tag = indexPath.section;
        textFieldCell.cacheArray = self.releaseModel.cacheArray;
        
        cell = textFieldCell;
    }
    else if (indexPath.section >= 4 && indexPath.section <= 11) {
        
        FZCounterCell *counterCell = [tableView dequeueReusableCellWithIdentifier:@"FZCounterCell"];
        counterCell.tag = indexPath.section;
        counterCell.cacheArray = self.releaseModel.cacheArray;
        [counterCell updateCell];
        counterCell.displayLabel.text = [self.releaseModel.cacheArray objectAtIndex:indexPath.section];
        
        cell = counterCell;
    }
    else if (indexPath.section == sectionNumber - 1) {
        
        FZTextViewCell *textViewCell = [tableView dequeueReusableCellWithIdentifier:@"FZTextViewCell"];
        textViewCell.tag = indexPath.section;
        textViewCell.cacheArray = self.releaseModel.cacheArray;
        
        cell = textViewCell;
    }
    else if ([sectionTitle hasSuffix:@"时间"]) {
        FZScreenDateCell *dateCell = [tableView dequeueReusableCellWithIdentifier:@"FZScreenDateCell"];
        dateCell.tag = indexPath.section;
        
        dateCell.cellDate = [self.releaseModel.cacheArray objectAtIndex:indexPath.section];
        [dateCell.dateButton addTarget:self action:@selector(changeDate) forControlEvents:UIControlEventTouchUpInside];
        
        cell = dateCell;
    }
    else {
        FZScreenPickerCell *pickerCell = [tableView dequeueReusableCellWithIdentifier:@"FZScreenPickerCell"];
        pickerCell.tag = indexPath.section;
        pickerCell.cacheArray = self.releaseModel.cacheArray;
        
        NSArray *items = [self.releaseModel contentsOfSectionTitle:[self.releaseModel.sectionTitles objectAtIndex:indexPath.section]];
        NSInteger selectedIndex = [[self.releaseModel.cacheArray objectAtIndex:indexPath.section] intValue];
        [pickerCell updatePickerWithItems:items selectedIndex:selectedIndex];
        
        cell = pickerCell;
    }
    
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    return cell;
}

#pragma mark - Date picker delegate -

- (void)datePickerDonePressed:(THDatePickerViewController *)datePicker
{
    self.currentDate = datePicker.date;
    [self.releaseModel.cacheArray replaceObjectAtIndex:2 withObject:[self.formatter stringFromDate:self.currentDate]];
    [self.tableView reloadData];
    
    [self dismissSemiModalView];
}

- (void)datePickerCancelPressed:(THDatePickerViewController *)datePicker
{
    [self dismissSemiModalView];
}

#pragma mark - Community search delegate -

- (void)selectCommunityName:(NSString *)name communityID:(NSString *)communityID address:(NSString *)address
{
    [self.paramDict setObject:communityID forKey:@"borough_id"];
    [self.paramDict setObject:name forKey:@"borough_name"];
    [self.releaseModel.cacheArray replaceObjectAtIndex:0 withObject:name];
    [self.releaseModel.cacheArray replaceObjectAtIndex:1 withObject:address];
    
    [self.tableView reloadData];
}

#pragma mark - Response event -

- (void)changeDate
{
    [self presentSemiViewController:self.datePicker withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                 @(NO), KNSemiModalOptionKeys.pushParentBack,
                                                                 @(0.15f), KNSemiModalOptionKeys.animationDuration,
                                                                 @(0.3f), KNSemiModalOptionKeys.shadowOpacity, nil]];
    
    
    FZTextFieldCell *cell = (FZTextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    [cell.textField resignFirstResponder];
}

- (void)gotoNextStep
{
    NSInteger sectionNumber = self.tableView.numberOfSections;
    
    if ([self checkImportantCell] == NO) {
        return;
    }
    
    if (![[self.releaseModel.cacheArray objectAtIndex:2] isEqualToString:@"现在"]) {
        [self.paramDict setObject:[self.releaseModel.cacheArray objectAtIndex:2] forKey:@"canlive"];
    }
    else {
        NSDate *todayDate = [NSDate date];
        NSString *dateString = nil;
        dateExchange(todayDate.timeIntervalSince1970, dateString);
        [self.paramDict setObject:dateString forKey:@"canlive"];
    }
    [self.paramDict setObject:[self.releaseModel.cacheArray objectAtIndex:3] forKey:@"house_totalarea"];
    [self.paramDict setObject:[self.releaseModel.cacheArray objectAtIndex:4] forKey:@"house_room"];
    [self.paramDict setObject:[self.releaseModel.cacheArray objectAtIndex:5] forKey:@"house_hall"];
    [self.paramDict setObject:[self.releaseModel.cacheArray objectAtIndex:6] forKey:@"house_toilet"];
    [self.paramDict setObject:[self.releaseModel.cacheArray objectAtIndex:7] forKey:@"house_floor"];
    [self.paramDict setObject:[self.releaseModel.cacheArray objectAtIndex:8] forKey:@"house_topfloor"];
    [self.paramDict setObject:[self.releaseModel.cacheArray objectAtIndex:9] forKey:@"house_building"];
    [self.paramDict setObject:[self.releaseModel.cacheArray objectAtIndex:10] forKey:@"house_unit"];
    [self.paramDict setObject:[self.releaseModel.cacheArray objectAtIndex:11] forKey:@"house_shi"];
    
    NSMutableString *tempString = [NSMutableString string];
    for (int i = 12; i < sectionNumber - 4; i++) {
        NSString *resultString = [self.releaseModel.cacheArray objectAtIndex:i];
        if (resultString.intValue != 0) {
            [tempString appendFormat:@"%@,", [self.releaseModel featureIDInSection:i]];
        }
    }
    if (tempString.length != 0) {
        [self.paramDict setObject:[tempString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]] forKey:@"house_feature"];
    }

    [self.paramDict setObject:[self.releaseModel.cacheArray objectAtIndex:sectionNumber - 4] forKey:@"house_toward"];
    [self.paramDict setObject:[self.releaseModel.cacheArray objectAtIndex:sectionNumber - 3] forKey:@"house_fitment"];
    [self.paramDict setObject:[self.releaseModel.cacheArray objectAtIndex:sectionNumber - 2] forKey:@"house_desc"];
    
    FZPhotoViewController *photoViewController = [[FZPhotoViewController alloc] init];
    photoViewController.releaseModel = self.releaseModel;
    photoViewController.paramDict = self.paramDict;
    [self.navigationController pushViewController:photoViewController animated:YES];
    
    NSLog(@"发布%@", self.paramDict);
}

// 如果有必填项没有填入数据，那么回滚到相应位置
- (BOOL)checkImportantCell
{
    if ([[self.releaseModel.cacheArray objectAtIndex:0] isEqualToString:@"选择"]) {
        [JDStatusBarNotification showWithStatus:@"小区信息不完整" dismissAfter:2 styleName:JDStatusBarStyleError];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        return NO;
    }
    if ([[self.releaseModel.cacheArray objectAtIndex:3] isEqualToString:@"0"] ||
        [[self.releaseModel.cacheArray objectAtIndex:3] length] == 0) {
        [JDStatusBarNotification showWithStatus:@"房屋面积没有填入" dismissAfter:2 styleName:JDStatusBarStyleError];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        return NO;
    }
    
    return YES;
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
