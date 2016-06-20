//
//  FZSignHouseViewController.m
//  Fangzhur
//
//  Created by --超-- on 14/12/18.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZSignHouseViewController.h"
#import "UIButton+ZCCustomButtons.h"
#import "FZAppDelegate.h"
#import "FZContractViewController.h"

@interface FZSignHouseViewController () <UIActionSheetDelegate>

@property (nonatomic, weak) FZAppDelegate *appDelegate;

@end

@implementation FZSignHouseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate = (FZAppDelegate *)[UIApplication sharedApplication].delegate;
    self.appDelegate.isMakeOwnerPhone = YES;
    
    UIButton *phoneButton = [UIButton buttonWithFrame:CGRectMake(100, 390, (SCREEN_WIDTH - 200), 35) title:@"给房主打电话" imageName:nil bgImageName:nil];
    [phoneButton setTitleColor:kDefaultColor forState:UIControlStateNormal];
    phoneButton.layer.borderColor = kDefaultColor.CGColor;
    phoneButton.layer.borderWidth = 0.7f;
    phoneButton.layer.cornerRadius = 5;
    [phoneButton addTarget:self action:@selector(makeAPhoneCall) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:phoneButton];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.appDelegate.isMakeOwnerPhone = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Response events -

- (void)makeAPhoneCall
{
    makeAPhoneCall(self.detailModel.owner_phone);

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoAppraise) name:@"applicationDidBecomeActive" object:nil];
}

//打完电话后对此次会话进行评价
- (void)gotoAppraise
{
    UIActionSheet *appraiseSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"是房主", @"未接通", @"已成交", @"错误房源", @"中介冒充房东", nil];
    appraiseSheet.tintColor = kDefaultColor;
    [appraiseSheet showInView:self.view];
    
    //一定要在评价窗口弹出后，取消观察者，防止其他通知，激活观察者执行错误的方法
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 5) {
        return;
    }
    
    [[FZRequestManager manager] appraiseHouseWithHouseID:self.detailModel.houseID houseType:self.detailModel.houseType appraiseType:[NSString stringWithFormat:@"%d", (buttonIndex + 1)] complete:^(BOOL success, id responseObject) {
        if (success) {
            [JDStatusBarNotification showWithStatus:@"已提交" dismissAfter:2];
        }
    }];
}

@end
