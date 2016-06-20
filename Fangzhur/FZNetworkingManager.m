//
//  FZNetworkingManager.m
//  Fangzhur
//
//  Created by --超-- on 14/11/3.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZNetworkingManager.h"
#import <AFNetworking.h>
#import <JDStatusBarNotification.h>

@implementation FZNetworkingManager

+ (void)showNetworkingUnreachableStatus
{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            [JDStatusBarNotification showWithStatus:@"您还没有连接网络" dismissAfter:2 styleName:JDStatusBarStyleError];
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

@end
