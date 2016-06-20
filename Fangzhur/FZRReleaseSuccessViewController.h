//
//  FZRReleaseSuccessViewController.h
//  SelfBusiness
//
//  Created by --Chao-- on 14-6-11.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZScrolledNavigationBarController.h"
#import "FZRReleaseSuccessView.h"
#import "FZPersonalCenterViewController.h"

@interface FZRReleaseSuccessViewController : FZScrolledNavigationBarController
<FZRReleaseSuccessViewDelegate>

//订单编号
@property (nonatomic, copy) NSString *orderId;

@end
