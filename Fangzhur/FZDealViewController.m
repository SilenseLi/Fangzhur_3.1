//
//  FZDealViewController.m
//  Fangzhur
//
//  Created by --超-- on 14-7-24.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZDealViewController.h"
#import "UITextField+ZCCustomField.h"
#import "UIButton+ZCCustomButtons.h"
#import "THDatePickerViewController.h"

@interface FZDealViewController () <THDatePickerDelegate>
{
    UITextField *_priceField;
    UITextField *_dateField;
    UIButton    *_submitButton;
    FZHTTPRequest *_request;
}

@property (nonatomic, strong) THDatePickerViewController *datePicker;
@property (nonatomic, strong) NSDateFormatter *formatter;

- (void)UIConfig;
- (void)submitDealInfo;

@end

@implementation FZDealViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self UIConfig];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController performSelector:@selector(addTitle:) withObject:@"成交信息"];
    [self addButtonWithImageName:@"fanhui" target:self action:@selector(popViewController) position:POSLeft];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)UIConfig
{
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 64, SCREEN_WIDTH - 40, 60)];
    tipLabel.text = @"请您正确填写成交信息，这样可以给予用户更精准的房屋估价，您的所有信息将被严格的保护。";
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.numberOfLines   = 0;
    [self.view addSubview:tipLabel];
    
    NSString *placeholder = nil;
    if ([_houseType isEqualToString:@"2"]) {
        placeholder = @"成交价格 (万元)";
    }
    else {
        placeholder = @"成交价格 (元/月)";
    }
    _priceField = [UITextField textFieldWithFrame:CGRectMake(20, 124, SCREEN_WIDTH - 40, 44)
                                      placeholder:placeholder superView:self.view];
    _priceField.keyboardType = UIKeyboardTypeNumberPad;
    _dateField  = [UITextField textFieldWithFrame:CGRectMake(20, 179, SCREEN_WIDTH - 40, 44)
                                      placeholder:@"成交时间" superView:self.view];
    _dateField.delegate = self;
    
    _submitButton = [UIButton buttonWithFrame:CGRectMake(20, 233, SCREEN_WIDTH - 40, 40) title:@"提交" fontSize:17 bgImageName:@"dibutiao_bg"];
    [_submitButton addTarget:self action:@selector(submitDealInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitButton];
    
    [self addDatePicker];
}

- (void)addDatePicker
{
    self.formatter = [[NSDateFormatter alloc] init];
    [self.formatter setDateFormat:@"yyyy'-'MM'-'dd"];
    
    self.datePicker = [THDatePickerViewController datePicker];
    self.datePicker.date = [NSDate date];
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

#pragma mark - Date picker delegate -

- (void)datePickerDonePressed:(THDatePickerViewController *)datePicker
{
    _dateField.text = [self.formatter stringFromDate:datePicker.date];
    
    [self dismissSemiModalView];
}

- (void)datePickerCancelPressed:(THDatePickerViewController *)datePicker
{
    [self dismissSemiModalView];
}

#pragma mark - text field delegate -

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _dateField) {
        [self presentSemiViewController:self.datePicker withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     @(NO), KNSemiModalOptionKeys.pushParentBack,
                                                                     @(0.15f), KNSemiModalOptionKeys.animationDuration,
                                                                     @(0.3f), KNSemiModalOptionKeys.shadowOpacity, nil]];
        [_priceField resignFirstResponder];
        return NO;
    }
    else {
        return YES;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_priceField resignFirstResponder];
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)submitDealInfo
{
    [_priceField resignFirstResponder];
    
    if (_priceField.text.length == 0 ||
        _dateField.text.length == 0) {
        [JDStatusBarNotification showWithStatus:@"您填写的信息不完整!" dismissAfter:2 styleName:JDStatusBarStyleError];
        return;
    }
    
    if ([_houseType isEqualToString:@"1"]) {
        _request = [[FZHTTPRequest alloc] initWithURLString:URLStringByAppending(kRentManagement) cacheInterval:0];
    }
    else {
        _request = [[FZHTTPRequest alloc] initWithURLString:URLStringByAppending(kSaleManagement) cacheInterval:0];
    }
    
    [_request addTarget:self action:@selector(requestFinished:)];
    [_request startPostWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
                                       @"savebargain", @"action",
                                       _houseID, @"house_id",
                                       _priceField.text, @"bargain_price",
                                       _dateField.text, @"bargain_time",
                                       FZUserInfoWithKey(Key_LoginToken), @"token",
                                       FZUserInfoWithKey(Key_UserName), @"username",
                                       FZUserInfoWithKey(Key_MemberID), @"member_id", nil]];
}

- (void)requestFinished:(FZHTTPRequest *)request
{
    if (request.downloadedData) {
        id resultData = [NSJSONSerialization JSONObjectWithData:request.downloadedData options:NSJSONReadingMutableContainers error:nil];
        if ([resultData isKindOfClass:[NSDictionary class]]) {
            NSDictionary *resultDict = (NSDictionary *)resultData;
            if ([[resultDict objectForKey:@"fanhui"] intValue] == 1) {
                [self.navigationController popViewControllerAnimated:YES];
                [JDStatusBarNotification showWithStatus:@"提交成功!" dismissAfter:2];
            }
            else {
                [JDStatusBarNotification showWithStatus:@"信息提交失败，请稍后重试!" dismissAfter:2 styleName:JDStatusBarStyleError];
            }
        }
        else {
            NSLog(@"%@", [[NSString alloc] initWithData:request.downloadedData encoding:NSUTF8StringEncoding]);
        }
    }
}


@end
