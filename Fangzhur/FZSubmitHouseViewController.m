//
//  FZSubmitHouseViewController.m
//  Fangzhur
//
//  Created by --超-- on 14/12/3.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZSubmitHouseViewController.h"
#import "FangZhurXieYiViewController.h"
#import "FZTextFieldCell.h"
#import "FZLabelCell.h"
#import "JCheckPhoneNumber.h"
#import "FZScreenTitleLabel.h"
#import "ZCPickerView.h"
#import "FZSubmitHouseFooter.h"
#import "SGActionView.h"
#import "FZVerifyHouseViewController.h"

//错误提示
#define ShowError(errorString)\
[JDStatusBarNotification showWithStatus:errorString dismissAfter:2 styleName:JDStatusBarStyleError]

//回滚 table view
#define ScrollTableViewToSection(section)\
[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES]

@interface FZSubmitHouseViewController ()

@property (nonatomic, strong) FZSubmitHouseFooter *footer;
@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, strong) NSMutableArray *cacheArray;
@property (nonatomic, strong) NSDictionary *paymentTypes;
@property (nonatomic, strong) UIButton *bottomButton;


- (void)configureUI;

@end

@implementation FZSubmitHouseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.releaseModel.releaseType.intValue == 1) {
        self.paymentTypes = @{@"1" : @"押一付一", @"3" : @"押一付二", @"5" : @"押一付三", @"9" : @"押一付六", @"10" : @"年付", @"2" : @"押二付一", @"4" : @"押二付二", @"6" : @"押二付三", @"11" : @"面议"};
        self.sectionTitles = @[@"房主姓名（必填）", @"房主电话（必填）", @"心仪的价格", @"付款方式"];
        self.cacheArray = [[NSMutableArray alloc] initWithObjects:@"", FZUserInfoWithKey(Key_UserName), @"" , @"", nil];
    }
    else {
        self.sectionTitles = @[@"房主姓名（必填）", @"房主电话（必填）", @"心仪的价格"];
        self.cacheArray = [[NSMutableArray alloc] initWithObjects:@"", FZUserInfoWithKey(Key_UserName), @"", nil];
    }
    
    [self configureUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureUI
{
    self.title = @"提交";
//    [self addTipLabelWithString:@"已经到发布的最后一步\n了，别人马上就可以看到\n您的房子了!"];
    
    self.footer = [[[NSBundle mainBundle] loadNibNamed:@"FZSubmitHouseFooter" owner:self options:nil] lastObject];
    [self.footer.checkButton addTarget:self action:@selector(checkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.footer.xieyiButton addTarget:self action:@selector(xieyiButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = self.footer;
    
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableView registerNib:[UINib nibWithNibName:@"FZTextFieldCell" bundle:nil] forCellReuseIdentifier:@"FZTextFieldCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FZLabelCell" bundle:nil] forCellReuseIdentifier:@"FZLabelCell"];
    
    self.bottomButton = kBottomButtonWithName(@"提  交");
    [self.bottomButton setTitle:@"提交中..." forState:UIControlStateDisabled];
    [self.bottomButton addTarget:self action:@selector(submitHouse) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bottomButton];
}

#pragma mark - Table view delegate -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sectionTitles objectAtIndex:indexPath.section] isEqualToString:@"付款方式"]) {
        [SGActionView showSheetWithTitle:@"付款方式"
                              itemTitles:self.paymentTypes.allValues
                           itemSubTitles:nil
                           selectedIndex:-1
                          selectedHandle:^(NSInteger index) {
                              [self.cacheArray replaceObjectAtIndex:3 withObject:[self.paymentTypes.allKeys objectAtIndex:index]];
                              [self.tableView reloadData];
                          }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FZScreenTitleLabel *titleLabel = [[FZScreenTitleLabel alloc] init];
    titleLabel.font = [UIFont fontWithName:kFontName size:17];
    titleLabel.text = [self.sectionTitles objectAtIndex:section];
    
    return titleLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

#pragma mark - Table view data source -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FZTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FZTextFieldCell"];
    cell.tag = indexPath.section;
    cell.cacheArray = self.cacheArray;
    cell.textField.text = [self.cacheArray objectAtIndex:indexPath.section];
    cell.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [cell hideSideLabel];
    
    switch (indexPath.section) {
        case 0: {
            cell.textField.placeholder = @"可提高房屋真实性";
            cell.textField.keyboardType = UIKeyboardTypeDefault;
            cell.textField.inputView = nil;
            
            return cell;
        }
            break;
        case 1: {
            cell.textField.placeholder = @"请输入11位手机号";
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;
        case 2: {
            if (self.releaseModel.releaseType.intValue == 1) {
                cell.rightLabel.text = @"元/月";
            }
            else {
                cell.rightLabel.text = @"万元";
            }
            
            cell.textField.placeholder = @"";
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            [cell showSideLabel];
        }
            break;
        case 3: {
            FZLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FZLabelCell"];
            cell.titleLabel.text = [self.paymentTypes objectForKey:[self.cacheArray objectAtIndex:indexPath.section]];
            
            return cell;
        }
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - Response events -

- (void)checkButtonClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

- (void)xieyiButtonClicked
{
    FangZhurXieYiViewController *xieyiViewController = [[FangZhurXieYiViewController alloc] init];
    FZNavigationController *navController = [[FZNavigationController alloc] initWithRootViewController:xieyiViewController];
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)submitHouse
{
    NSString *ownerName = [self.cacheArray objectAtIndex:0];
    NSString *ownerPhone = [self.cacheArray objectAtIndex:1];
    
    if (ownerName.length == 0) {
        ShowError(@"请填写您的真实姓名");
        ScrollTableViewToSection(0);
        return;
    }
    
    if ([JCheckPhoneNumber isMobileNumber:ownerPhone]) {
        //房东号不可以是顾问
        if ([ownerPhone isEqualToString:FZUserInfoWithKey(Key_UserName)] &&
            [FZUserInfoWithKey(Key_RoleType) intValue] == 4) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"您填写的手机号以被标记为交易顾问!\n请重新填写，或者联系我们\n4000-981-985"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确认"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    else {
        ShowError(@"请填写正确的手机号");
        ScrollTableViewToSection(1);
        return;
    }
    
    //不遵守协议不可以发布房源
    if (self.footer.checkButton.selected == NO) {
        ShowError(@"发布房源必须遵守《房主儿网用户协议》");
        return;
    }
    
    ////////////////////////////////////////////////////
                        ////////////////////////////////////////////////////
    
    [self.bottomButton setEnabled:NO];
    
    [self.paramDict setObject:ownerName forKey:@"owner_name"];
    [self.paramDict setObject:ownerPhone forKey:@"owner_phone"];
    
    if ([[self.cacheArray objectAtIndex:0] length] == 0) {
        //默认不填写价格为面议
        [self.paramDict setObject:@"0" forKey:@"house_price"];
    }
    else {
        [self.paramDict setObject:[self.cacheArray objectAtIndex:2] forKey:@"house_price"];
    }
    
    if (self.releaseModel.releaseType.intValue == 1) {
        [self.paramDict setObject:[self.cacheArray objectAtIndex:3] forKey:@"house_deposit"];
    }
    [self.paramDict setObject:self.releaseModel.houseType forKey:@"house_type"];

    NSLog(@"Parameters:\n%@", self.paramDict);
    [[FZRequestManager manager] releaseHouseWithType:self.releaseModel.releaseType requestParameters:self.paramDict complete:^(NSString *houseID) {
        [self.bottomButton setEnabled:YES];
        
        if (houseID) {
            FZVerifyHouseViewController *verifyHouseViewController = [[FZVerifyHouseViewController alloc] init];
            verifyHouseViewController.houselistType = @"Verify";
            verifyHouseViewController.imageURLs = [self.paramDict objectForKey:@"house_picture_url"];
            verifyHouseViewController.detailModel.houseType = self.releaseModel.releaseType;
            verifyHouseViewController.houseType = self.releaseModel.releaseType;
            verifyHouseViewController.detailModel.houseID = houseID;
            FZNavigationController *navController = [[FZNavigationController alloc] initWithRootViewController:verifyHouseViewController];
            [self presentViewController:navController animated:YES completion:nil];
        }
        else {
            ShowError(@"发布房源失败，请稍后重试!");
        }
    }];
}

@end
