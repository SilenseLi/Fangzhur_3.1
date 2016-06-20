//
//  FZUpdateInfoViewController.m
//  Fangzhur
//
//  Created by --Chao-- on 14-7-3.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZUpdateInfoViewController.h"
#import "FZUpdateInfoCell.h"
#import "IQActionSheetPickerView.h"

@interface FZUpdateInfoViewController () <IQActionSheetPickerViewDelegate>
{
    FZUpdateInfoCell *_updateInfoCell;
    FZHTTPRequest *_request;
}

@property (nonatomic, strong) IQActionSheetPickerView *datePicker;

- (void)UIConfig;
- (void)updateUserInfo;
- (void)chooseSexAndBirthday:(UIButton *)sender;
- (void)pickSex:(UISegmentedControl *)segControl;

@end

@implementation FZUpdateInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self UIConfig];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController performSelector:@selector(addTitle:) withObject:@"修改资料"];
    [self addButtonWithImageName:@"fanhui" target:self action:@selector(backToUserCenter) position:POSLeft];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)UIConfig
{
    self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"FZUpdateInfoCell" bundle:nil] forCellReuseIdentifier:@"FZUpdateInfoCell"];
    
    [self addDatePicker];
}

- (void)backToUserCenter
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 个人信息修改 -

- (void)chooseSexAndBirthday:(UIButton *)sender
{
    if (sender.tag == 1) {//性别
        [_updateInfoCell showSexControl];
    }
    else {//出生日期
        [self.datePicker show];
    }
}

- (void)pickSex:(UISegmentedControl *)segControl
{
    if (segControl.selectedSegmentIndex == 0) {//male
        _updateInfoCell.sexLabel.text = @"男";
    }
    else {//female
        _updateInfoCell.sexLabel.text = @"女";
    }
    [_updateInfoCell hideSexControl];
}

- (void)addDatePicker
{
    self.datePicker = [[IQActionSheetPickerView alloc] initWithTitle:nil delegate:self];
    [self.datePicker setActionSheetPickerStyle:IQActionSheetPickerStyleDatePicker];
}

#pragma mark - Date picker delegate -

-(void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectTitles:(NSArray *)titles
{
    NSDate *date = [titles firstObject];
    NSString *dateString = [[date.description componentsSeparatedByString:@" "] firstObject];
    _updateInfoCell.birthdayLabel.text = dateString;
}

#pragma mark - 确认提交 -

- (void)updateUserInfo
{
    if (_updateInfoCell.realNameField.text.length == 0
        || _updateInfoCell.nickField.text.length == 0
        || _updateInfoCell.sexLabel.text.length == 0
        || _updateInfoCell.birthdayLabel.text.length == 0) {
        [JDStatusBarNotification showWithStatus:@"信息输入不完整!" dismissAfter:2 styleName:JDStatusBarStyleError];
        return;
    }
    
    //===========================
    
    _request = [[FZHTTPRequest alloc] initWithURLString:URLStringByAppending(kUpdateInfo) cacheInterval:0];
    [_request addTarget:self action:@selector(requestFinished:)];
    [_request startPostWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
                                       FZUserInfoWithKey(Key_UserName), @"username",
                                       FZUserInfoWithKey(Key_MemberID), @"member_id",
                                       FZUserInfoWithKey(Key_LoginToken), @"token",
                                      _updateInfoCell.realNameField.text, @"realname",
                                      _updateInfoCell.nickField.text,     @"nickname",
                                      [self sexTag],                      @"gender",
                                       _updateInfoCell.birthdayLabel.text, @"birthday", nil]];
}

- (void)requestFinished:(FZHTTPRequest *)request
{
    if (request.error) {
        [JDStatusBarNotification showWithStatus:@"提交失败, 请检查网络!" dismissAfter:2 styleName:JDStatusBarStyleError];
        return;
    }
    
    //=================================
    
    if (request.downloadedData) {
        id resultData = [NSJSONSerialization JSONObjectWithData:request.downloadedData
                                                        options:NSJSONReadingMutableContainers error:nil];
        if ([resultData isKindOfClass:[NSDictionary class]]) {
            NSDictionary *resultDict = (NSDictionary *)resultData;
            if ([[resultDict objectForKey:@"fanhui"] isEqualToString:@"修改成功"]) {
                [JDStatusBarNotification showWithStatus:@"资料修改成功" dismissAfter:2];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
                [JDStatusBarNotification showWithStatus:[resultDict objectForKey:@"fanhui"] dismissAfter:2 styleName:JDStatusBarStyleError];
            }
        }
        else {
            NSLog(@"\n资料ResponseData\n%@", [[NSString alloc] initWithData:request.downloadedData encoding:NSUTF8StringEncoding]);
        }
    }
    else {
        [JDStatusBarNotification showWithStatus:@"服务器繁忙, 请稍后重试!" dismissAfter:2 styleName:JDStatusBarStyleError];
    }
}

- (NSString *)sexTag
{
    if ([_updateInfoCell.sexLabel.text hasSuffix:@"男"]) {
        return @"0";
    }
    else {
        return @"1";
    }
}

#pragma mark - Table view delegate -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 450;
}

#pragma mark - Table view data source -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _updateInfoCell = [tableView dequeueReusableCellWithIdentifier:@"FZUpdateInfoCell"];
    [_updateInfoCell addTarget:self action:@selector(chooseSexAndBirthday:)];
    [_updateInfoCell.sexPickerControl addTarget:self action:@selector(pickSex:) forControlEvents:UIControlEventValueChanged];
    [_updateInfoCell.completeButton addTarget:self action:@selector(updateUserInfo) forControlEvents:UIControlEventTouchUpInside];
    
    return _updateInfoCell;
}

@end
