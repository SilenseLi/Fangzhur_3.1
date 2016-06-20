//
//  FZAppDelegate.m
//  Fangzhur
//
//  Created by --超-- on 14/10/22.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZAppDelegate.h"
#import "UncaughtExceptionHandler.h"
#import "FZSlideMenuViewController.h"
#import "FZHomeViewController.h"
#import "FZNavigationController.h"
#import "PartnerConfig.h"
#import <AlipaySDK/AlipaySDK.h>
#import "IQKeyboardManager.h"

@implementation FZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    dispatch_queue_t isolationQueue = dispatch_queue_create("AppDelegate.isolation", DISPATCH_QUEUE_CONCURRENT);
    dispatch_barrier_async(isolationQueue, ^{
        [self defaultConfig];
        [self configureShareSDK];
        [self previousLoading];
        [self startMapManager];
    });
    
    FZHomeViewController *homeViewController = [[FZHomeViewController alloc] init];
    FZSlideMenuViewController *leftMenuController = [[FZSlideMenuViewController alloc] init];
    FZNavigationController *navController = [[FZNavigationController alloc] initWithRootViewController:homeViewController];
    [navController setNavigationBarWithImage:[UIImage imageNamed:@"daohang_bg"]];
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:navController
                                                                    leftMenuViewController:leftMenuController
                                                                   rightMenuViewController:nil];
    sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Stars"];
    sideMenuViewController.contentViewShadowColor = RGBColor(150, 50, 90);
    sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    sideMenuViewController.contentViewShadowOpacity = 0.4;
    sideMenuViewController.contentViewShadowRadius = 7;
    sideMenuViewController.contentViewScaleValue = 1;
    sideMenuViewController.contentViewInPortraitOffsetCenterX = 70;
    sideMenuViewController.contentViewShadowEnabled = YES;
    
    self.window.rootViewController = sideMenuViewController;
    self.window.backgroundColor = kSideMenuBackgroundColor;
    
    [self addSplashAnimation];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if (![FZUserInfoWithKey(Key_BindingTag) isEqualToString:@"Unbind"]) {
        [[FZRequestManager manager] getUserInfoComplete:NULL];
    }
    
    if (self.isMakeOwnerPhone) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidBecomeActive" object:nil];
        });
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService]
         processOrderWithPaymentResult:url
         standbyCallback:^(NSDictionary *resultDic) {
             NSLog(@"result = %@", resultDic);
             
             NSInteger statusCode = [[resultDic objectForKey:@"resultStatus"] integerValue];
             switch (statusCode) {
                 case 9000: {
                     [JDStatusBarNotification showWithStatus:@"订单支付成功"];
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"TradeFinished" object:nil];
                 }
                     break;
                 case 6001: {
                     [JDStatusBarNotification showWithStatus:@"用户中途取消操作"];
                 }
                     break;
                 case 6002: {
                     [JDStatusBarNotification showWithStatus:@"网络连接错误"];
                 }
                     break;
                 case 4000: {
                     [JDStatusBarNotification showWithStatus:@"订单支付失败"];
                 }
                     break;
                     
                 default:
                     break;
             }
         }];
        [JDStatusBarNotification dismissAfter:2];
    }
    
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

#pragma mark - custom method -

- (void)addSplashAnimation
{
    UIImageView *splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    splashView.contentMode = UIViewContentModeScaleToFill;
    splashView.image = [UIImage imageNamed:@"Start"];
    RESideMenu *sideMenu = (RESideMenu *)self.window.rootViewController;
    [sideMenu.contentViewController.view addSubview:splashView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2.0f];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.window cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationWillStartSelector:@selector(startupAnimationBegin)];
    [UIView setAnimationDidStopSelector:@selector(startupAnimationEnd)];
    splashView.alpha = 0.0;
    splashView.frame = CGRectMake(-300, -400, SCREEN_WIDTH + 600, SCREEN_HEIGHT + 800);
    [UIView commitAnimations];
}

- (void)startupAnimationBegin
{

}

- (void)startupAnimationEnd
{
    [self checkVersion];
}

- (void)defaultConfig
{
    self.isMakeOwnerPhone = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:Key_LoginToken]) {
        FZUserInfoReset;
    }
    
    if (!FZUserInfoWithKey(Key_LocationPush)) {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:Key_LocationPush];
    }
    //设置默认城市站点
    if (!FZUserInfoWithKey(Key_CityName)) {
        [[NSUserDefaults standardUserDefaults] setValue:@"http://bj.fangzhur.com" forKey:Key_CityURL];
        [[NSUserDefaults standardUserDefaults] setValue:@(1) forKey:Key_CityID];
        [[NSUserDefaults standardUserDefaults] setValue:@"北京市" forKey:Key_CityName];
    }
    
    [IQKeyboardManager sharedManager].shouldShowTextFieldPlaceholder = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)previousLoading
{
    [[FZRequestManager manager] getRegionInfo];
    [[FZRequestManager manager] getSubwayInfo];
    [[FZRequestManager manager] getAllTags];
    [[FZRequestManager manager] requestBankListHandler:NULL];
}

#pragma mark - check version -

- (void)checkVersion
{
    [[FZRequestManager manager] checkVersionHandler:^(NSString *versionString) {
        if (!versionString) {
            return ;
        }
        
        if (![versionString isEqualToString:kAppCurrentVersion]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"最新版本（%@）已上线，\n请您下载更新!", versionString] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"现在更新", nil];
            alert.delegate = self;
            [alert show];
        }
    }];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppDownload]];
    }
}

#pragma mark - Share SDK -

- (void)configureShareSDK
{
    _interfaceOrientationMask = SSInterfaceOrientationMaskAll;
    [ShareSDK registerApp:ShareSDK_AppKey];
    
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSinaWeiboWithAppKey:@"3917969196"
                               appSecret:@"80104fc409f81a5faed5081eee169a70"
                             redirectUri:@"http://fangzhur.com"];
    
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
    [ShareSDK connectWeChatWithAppId:@"wxda020ce6f1eba281"
                           appSecret:@"a4c08a12f197a62bc91cdec7ae660c80"
                           wechatCls:[WXApi class]];
    
    //QQ
    [ShareSDK connectQQWithQZoneAppKey:@"1101978027"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    //短信
    [ShareSDK connectSMS];
}

- (void)userInfoUpdateHandler:(NSNotification *)notif
{
    NSMutableArray *authList = [NSMutableArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()]];
    if (authList == nil)
    {
        authList = [NSMutableArray array];
    }
    
    NSString *platName = nil;
    NSInteger plat = [[[notif userInfo] objectForKey:SSK_PLAT] integerValue];
    switch (plat)
    {
        case ShareTypeSinaWeibo:
            platName = NSLocalizedString(@"TEXT_SINA_WEIBO", @"新浪微博");
            break;
        case ShareType163Weibo:
            platName = NSLocalizedString(@"TEXT_NETEASE_WEIBO", @"网易微博");
            break;
        case ShareTypeDouBan:
            platName = NSLocalizedString(@"TEXT_DOUBAN", @"豆瓣");
            break;
        case ShareTypeFacebook:
            platName = @"Facebook";
            break;
        case ShareTypeKaixin:
            platName = NSLocalizedString(@"TEXT_KAIXIN", @"开心网");
            break;
        case ShareTypeQQSpace:
            platName = NSLocalizedString(@"TEXT_QZONE", @"QQ空间");
            break;
        case ShareTypeRenren:
            platName = NSLocalizedString(@"TEXT_RENREN", @"人人网");
            break;
        case ShareTypeSohuWeibo:
            platName = NSLocalizedString(@"TEXT_SOHO_WEIBO", @"搜狐微博");
            break;
        case ShareTypeTencentWeibo:
            platName = NSLocalizedString(@"TEXT_TENCENT_WEIBO", @"腾讯微博");
            break;
        case ShareTypeTwitter:
            platName = @"Twitter";
            break;
        case ShareTypeInstapaper:
            platName = @"Instapaper";
            break;
        case ShareTypeYouDaoNote:
            platName = NSLocalizedString(@"TEXT_YOUDAO_NOTE", @"有道云笔记");
            break;
        case ShareTypeGooglePlus:
            platName = @"Google+";
            break;
        case ShareTypeLinkedIn:
            platName = @"LinkedIn";
            break;
        default:
            platName = NSLocalizedString(@"TEXT_UNKNOWN", @"未知");
    }
    
    id<ISSPlatformUser> userInfo = [[notif userInfo] objectForKey:SSK_USER_INFO];
    BOOL hasExists = NO;
    for (int i = 0; i < [authList count]; i++)
    {
        NSMutableDictionary *item = [authList objectAtIndex:i];
        ShareType type = (ShareType)[[item objectForKey:@"type"] integerValue];
        if (type == plat)
        {
            [item setObject:[userInfo nickname] forKey:@"username"];
            hasExists = YES;
            break;
        }
    }
    
    if (!hasExists)
    {
        NSDictionary *newItem = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 platName,
                                 @"title",
                                 [NSNumber numberWithInteger:plat],
                                 @"type",
                                 [userInfo nickname],
                                 @"username",
                                 nil];
        [authList addObject:newItem];
    }
    
    [authList writeToFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()] atomically:YES];
}

#pragma mark - 百度地图 -

- (void)startMapManager
{
    self.mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [self.mapManager start:kBMAppKey generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        [JDStatusBarNotification showWithStatus:@"网络不给力!" dismissAfter:2 styleName:JDStatusBarStyleError];
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

@end
