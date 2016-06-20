//
//  FZAppDelegate.h
//  Fangzhur
//
//  Created by --超-- on 14/10/22.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RESideMenu.h>
#import "BMapKit.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "AGViewDelegate.h"

@class AGViewDelegate;

@interface FZAppDelegate : UIResponder
<UIApplicationDelegate, BMKGeneralDelegate, WXApiDelegate, UIAlertViewDelegate>
{
    enum WXScene _scene;
    AGViewDelegate *_viewDelegate;
    SSInterfaceOrientationMask _interfaceOrientationMask;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) BMKMapManager *mapManager;
@property (nonatomic, readonly) AGViewDelegate *viewDelegate;
@property (nonatomic) SSInterfaceOrientationMask interfaceOrientationMask;

// 防止在给房东打电话的时候，点击取消也弹出评价框
@property (nonatomic, assign) BOOL isMakeOwnerPhone;

@end
