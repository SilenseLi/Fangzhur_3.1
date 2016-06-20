//
//  UtilsMacro.h
//  AgentAPP
//
//  Created by Junk_cheung on 14-4-27.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//
//  设定

#import "UIButton+ZCCustomButtons.h"

#pragma mark - 设定颜色 -

#define RGBColor(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBAColor(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

//===========通用===========

//底部button
#define kBottomButtonWithName(name)\
[UIButton buttonWithFrame:CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49) title:name fontSize:20 bgImageName:@"dibutiao_bg"]

#define kFooterButtonWithName(name)\
[UIButton buttonWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49) title:name fontSize:20 bgImageName:@"dibutiao_bg"]

//创建Picker view
#define PickerViewOfTextField(picker, field, number, left, right)\
ZCPickerView *picker = [[ZCPickerView alloc] initWithField:field numberOfComponents:number leftArray:left rightDict:right];\
picker.frame = CGRectMake(0, 0, SCREEN_WIDTH, 216);\
field.inputView = picker;

#pragma mark - 获取信息 -

#define SCREEN_WIDTH     ([UIScreen mainScreen].bounds.size.width)   //屏幕窗口的宽
#define SCREEN_HEIGHT    ([UIScreen mainScreen].bounds.size.height)  //屏幕窗口的高
#define LowerThan_IOS7   ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
#define IOS7_Later       ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define CURRENT_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]

//调用电话接口
#define makeAPhoneCall(phoneNumber) \
    UIWebView *callWebview = [[UIWebView alloc] init];\
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phoneNumber]];\
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];\
    [[UIApplication sharedApplication].windows.lastObject addSubview:callWebview]

//时间戳转换
#define dateExchange(interval, dateString)\
{\
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];\
    [formatter setDateFormat:@"yyyy'-'MM'-'dd"];\
    dateString = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:interval]];\
}

//如果没有使用手机号登录，使其跳转到登录界面
#define JumpToLoginIfNeeded \
if (!FZUserInfoWithKey(Key_LoginToken) || [FZUserInfoWithKey(Key_BindingTag) isEqualToString:@"Unbind"]) {\
FZMobileLoginViewController *mobileLoginViewController = [[FZMobileLoginViewController alloc] init];\
mobileLoginViewController.title = @"手机登录";\
[self presentViewController:mobileLoginViewController animated:YES completion:^{\
[JDStatusBarNotification showWithStatus:@"使用手机号码登陆，才能进入哦!" dismissAfter:2.5 styleName:JDStatusBarStyleError];\
}];\
return;\
}

////////////////////////////////////////////////////////////////////




//网络请求接口拼接

//182.18.24.108
//#define URLStringByAppending(aString) \
//[@"http://www.newfzios.com" stringByAppendingString:aString]
#define URLStringByAppending(aString) \
[[[NSUserDefaults standardUserDefaults] valueForKey:@"CityURL"] stringByAppendingString:aString]
//#define URLStringByAppending(aString) \
//[@"http://172.18.1.200" stringByAppendingString:aString]
//#define URLStringByAppending(aString) \
[@"http://www.fangzhur.com" stringByAppendingString:aString]

//图片地址拼接
#define ImageURL(aString)\
aString ? [@"http://www.fangzhur.com/upfile/" stringByAppendingString:aString] : @""

#define UpdateCityURL(URLString) [[NSUserDefaults standardUserDefaults] setValue:URLString forKey:@"CityURL"]

//网络错误提示
#define FZNetworkingError(tagString)\
NSLog(@"%@\n %@", tagString, operation.responseString)
//[JDStatusBarNotification showWithStatus:@"网络不给力!" dismissAfter:2 styleName:JDStatusBarStyleError];


//===============用户相关===============

#define FZUserInfoWithKey(key)\
[[NSUserDefaults standardUserDefaults] objectForKey:key]

#define FZUserInfoReset \
[[NSUserDefaults standardUserDefaults] setObject:kDefaultUserName forKey:Key_UserName];\
[[NSUserDefaults standardUserDefaults] removeObjectForKey:Key_LoginToken];\
[[NSUserDefaults standardUserDefaults] removeObjectForKey:Key_MemberID];\
[[NSUserDefaults standardUserDefaults] removeObjectForKey:Key_HeadImage];\
[[NSUserDefaults standardUserDefaults] removeObjectForKey:Key_Gender];\
[[NSUserDefaults standardUserDefaults] removeObjectForKey:Key_NewMessage];\
[[NSUserDefaults standardUserDefaults] removeObjectForKey:Key_RoleType];\
[[NSUserDefaults standardUserDefaults] removeObjectForKey:Key_Tag];\
[[NSUserDefaults standardUserDefaults] removeObjectForKey:Key_BindingTag];\
[[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:Key_UserCash];\
[[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:Key_UserCredits];\
[[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:Key_UserTickets]


//=================文件操作================

//获取沙盒路径下指定的文件路径
#define filePathInDocuments(aString) [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", [aString MD5Hash]]




//================用于生成订单进行网络请求===================

//订单数据字典
#define TradeSaveDict [NSDictionary dictionaryWithObjectsAndKeys:\
    _orderModel.borough_name,                                         @"borough_name",\
    _orderModel.borough_id,                                           @"borough_id",\
    _orderModel.service_type_id,                                      @"service_type",\
    _orderModel.cjjg,                                                 @"cjjg",\
    _orderModel.use_fangbi,                                           @"use_fangbi",\
    _orderModel.fangbi,                                               @"fangbi",\
    _orderModel.method_payment,                                       @"method_payment",\
    _orderModel.house_id,                                             @"house_id",\
    _orderModel.cityarea_id,                                          @"cityarea_id",\
    [[NSUserDefaults standardUserDefaults] objectForKey:@"Token"],    @"token",\
    [[NSUserDefaults standardUserDefaults] objectForKey:@"MemberID"], @"member_id",\
    [[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"], @"username", nil]\

#define ___RefreshOrderModel___\
    _orderModel.quyu            = _infoCell.areaField.text;\
    _orderModel.cityarea_id     = [self getAreaId];\
    _orderModel.borough_name    = _infoCell.communityField.text;\
    _orderModel.borough_id      = _orderModel.borough_id;\
    _orderModel.house_id        = [self getHouseId];\
    _orderModel.cjjg            = _infoCell.priceField.text;\
    _orderModel.use_fangbi      = [self isUseVouchers];\
    _orderModel.fangbi          = [self getVouchers];\
    _orderModel.cash            = [[NSUserDefaults standardUserDefaults] objectForKey:@"Recharge"];\
    _orderModel.method_payment  = [self getPaymentMethod];\
    _orderModel.service_type_id = [self getServiceType];\
    _orderModel.service_price   = [_infoCell.serviceTypeField.text substringWithRange:NSMakeRange(startRange.location,endRange.location - startRange.location)];\
    _orderModel.service_type    = [_infoCell.serviceTypeField.text substringWithRange:NSMakeRange(0, startRange.location)];



