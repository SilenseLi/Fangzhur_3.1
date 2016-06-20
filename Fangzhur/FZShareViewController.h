//
//  FZFriendsViewController.h
//  AgentAPP
//
//  Created by L Suk on 14-4-29.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZScrolledNavigationBarController.h"
#import <ShareSDK/ShareSDK.h>
#import <AGCommon/CMImageHeaderTableView.h>
#import "FZAppDelegate.h"

@class FZAppDelegate;

@interface FZShareViewController : FZScrolledNavigationBarController
<UIScrollViewDelegate>
{
    FZAppDelegate *_appDelegate;
}

@end
