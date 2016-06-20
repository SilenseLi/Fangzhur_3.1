//
//  FZPaymentFirstViewController.h
//  Fangzhur
//
//  Created by --超-- on 15/1/10.
//  Copyright (c) 2015年 Zc. All rights reserved.
//

#import "FZRootTableViewController.h"
#import "FZPaymentModel.h"

@interface FZPaymentFirstViewController : FZRootTableViewController

@property (nonatomic, copy) NSString *houseNumber;
@property (nonatomic, copy) NSString *orderID; // 用于再次支付
@property (nonatomic, strong) FZPaymentModel *paymentModel;

- (void)loadHouseDataWithHouseNumber:(NSString *)houseNumber;

@end
