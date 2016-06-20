//
//  FZNetworkingManager.h
//  Fangzhur
//
//  Created by --超-- on 14/11/3.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FZNetworkingManager : NSObject

/** 没有网络连接时 在状态栏给出相应提示*/
+ (void)showNetworkingUnreachableStatus;

@end
