//
//  FZFriendsViewController.m
//  AgentAPP
//
//  Created by L Suk on 14-4-29.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZShareViewController.h"
#import "FZFriendsCenterView.h"

extern BOOL isTipOpen;

@interface FZShareViewController ()

- (void)UIConfig;
- (void)shares:(FZFriendsCenterView *)centerView withSelectedItem:(UIButton *)selectedButton;

@end

@implementation FZShareViewController

- (id)init
{
    self = [super init];
    if (self) {

       _appDelegate = (FZAppDelegate *)[UIApplication sharedApplication].delegate;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self UIConfig];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController performSelector:@selector(addTitle:) withObject:@"邀请好友"];
    [self addButtonWithImageName:@"fanhui" target:self action:@selector(dismissViewController) position:POSLeft];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 界面布局 -

- (void)UIConfig
{
    FZFriendsCenterView *centerView = [[FZFriendsCenterView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    centerView.delegate = self;
    [centerView addTarget:self action:@selector(shares:withSelectedItem:)];
    [self.view addSubview:centerView];
}

- (void)dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Shares -

- (void)shares:(FZFriendsCenterView *)centerView withSelectedItem:(UIButton *)selectedButton
{
    NSString *content = kFangzhurAboutTipString;
    
    if (selectedButton.tag == 0) {
        [self sendWeixinContent:content to:@"好友"];
    }
    if (selectedButton.tag == 1) {
        [self sendWeixinContent:content to:@"朋友圈"];
    }
    if (selectedButton.tag == 2) {
        [self sendTextMessage:content];
    }
    if (selectedButton.tag == 3) {
        [self shareToSinaWeiboClickHandler:selectedButton content:content];
    }
    if (selectedButton.tag == 4) {
        [self shareBySMSClickHandler:selectedButton content:content];
    }
}

- (void)shareToSinaWeiboClickHandler:(UIButton *)sender content:(NSString *)content
{
    //创建分享内容
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@""
                                                image:nil
                                                title:nil
                                                  url:nil
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeText];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:_appDelegate.viewDelegate];
    
    //显示分享菜单
    [ShareSDK showShareViewWithType:ShareTypeSinaWeibo
                          container:nil
                            content:publishContent
                      statusBarTips:YES
                        authOptions:authOptions
                       shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                           oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                            qqButtonHidden:NO
                                                     wxSessionButtonHidden:NO
                                                    wxTimelineButtonHidden:NO
                                                      showKeyboardOnAppear:NO
                                                         shareViewDelegate:_appDelegate.viewDelegate
                                                       friendsViewDelegate:_appDelegate.viewDelegate
                                                     picViewerViewDelegate:nil]
                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 
                                 if (state == SSPublishContentStateSuccess)
                                 {
                                     NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                 }
                                 else if (state == SSPublishContentStateFail)
                                 {
                                     NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                 }
                             }];
}

- (void)sendWeixinContent:(NSString *)contentString to:(NSString *)somewhere
{
    // 发送内容给微信
    id<ISSContent> content = [ShareSDK content:contentString
                                defaultContent:nil
                                         image:nil
                                         title:@"微信"
                                           url:@"http://www.fangzhur.com"
                                   description:nil
                                     mediaType:SSPublishContentMediaTypeText];
    [content addWeixinSessionUnitWithType:INHERIT_VALUE
                                  content:INHERIT_VALUE
                                    title:INHERIT_VALUE
                                      url:INHERIT_VALUE
                                    image:INHERIT_VALUE
                             musicFileUrl:nil
                                  extInfo:@"<xml>test</xml>"
                                 fileData:nil
                             emoticonData:nil];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:_appDelegate.viewDelegate];
    
    if ([somewhere isEqualToString:@"好友"]) {
        [ShareSDK shareContent:content
                          type:ShareTypeWeixiSession
                   authOptions:authOptions
                 statusBarTips:YES
                        result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                            
                            if (state == SSPublishContentStateSuccess)
                            {
                                [JDStatusBarNotification showWithStatus:@"分享成功" dismissAfter:2 styleName:JDStatusBarStyleDark];
                            }
                            else if (state == SSPublishContentStateFail)
                            {
                                if ([error errorCode] == -22003)
                                {
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TEXT_TIPS", @"提示")
                                                                                        message:[error errorDescription]
                                                                                       delegate:nil
                                                                              cancelButtonTitle:NSLocalizedString(@"TEXT_KNOW", @"知道了")
                                                                              otherButtonTitles:nil];
                                    [alertView show];
                                }
                            }
                        }];
    }
    else {
        [ShareSDK shareContent:content
                          type:ShareTypeWeixiTimeline
                   authOptions:authOptions
                 statusBarTips:YES
                        result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                            
                            if (state == SSPublishContentStateSuccess)
                            {
                                [JDStatusBarNotification showWithStatus:@"分享成功" dismissAfter:2 styleName:JDStatusBarStyleDark];
                            }
                            else if (state == SSPublishContentStateFail)
                            {
                                if ([error errorCode] == -22003)
                                {
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TEXT_TIPS", @"提示")
                                                                                        message:[error errorDescription]
                                                                                       delegate:nil
                                                                              cancelButtonTitle:NSLocalizedString(@"TEXT_KNOW", @"知道了")
                                                                              otherButtonTitles:nil];
                                    [alertView show];
                                }
                            }
                        }];
    }
}

- (void)sendTextMessage:(NSString *)message
{
    id<ISSContent> content = [ShareSDK content:message
                                defaultContent:nil
                                         image:nil
                                         title:nil
                                           url:nil
                                   description:nil
                                     mediaType:SSPublishContentMediaTypeText];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:_appDelegate.viewDelegate];
    
    
    [ShareSDK shareContent:content
                      type:ShareTypeQQ
               authOptions:authOptions
             statusBarTips:YES
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        
                        if (state == SSPublishContentStateSuccess)
                        {
                            [JDStatusBarNotification showWithStatus:@"分享成功" dismissAfter:2 styleName:JDStatusBarStyleDark];
                        }
                        else if (state == SSPublishContentStateFail)
                        {
                        }
                    }];
}

- (void)shareBySMSClickHandler:(UIButton *)sender content:(NSString *)content
{
    //创建分享内容
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@""
                                                image:nil
                                                title:nil
                                                  url:nil
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeText];
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:_appDelegate.viewDelegate];
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];
    
    //显示分享菜单
    [ShareSDK showShareViewWithType:ShareTypeSMS
                          container:container
                            content:publishContent
                      statusBarTips:YES
                        authOptions:authOptions
                       shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                           oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                            qqButtonHidden:NO
                                                     wxSessionButtonHidden:NO
                                                    wxTimelineButtonHidden:NO
                                                      showKeyboardOnAppear:NO
                                                         shareViewDelegate:_appDelegate.viewDelegate
                                                       friendsViewDelegate:_appDelegate.viewDelegate
                                                     picViewerViewDelegate:nil]
                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 
                                 if (state == SSPublishContentStateSuccess)
                                 {
                                     NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                 }
                                 else if (state == SSPublishContentStateFail)
                                 {
                                     NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                 }
                             }];
}

@end
