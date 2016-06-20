//
//  FZRGenerateOrderViewController.h
//  SelfBusiness
//
//  Created by --Chao-- on 14-6-12.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZRootTableViewController.h"
#import "FZContractModel.h"

#import "PartnerConfig.h"
#import "DataSigner.h"
#import "DataVerifier.h"
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>

//订单支付视图控制器
@interface FZRGenerateOrderViewController : FZRootTableViewController
<UIAlertViewDelegate>

@property (nonatomic, retain) FZContractModel *contractModel;

@end
