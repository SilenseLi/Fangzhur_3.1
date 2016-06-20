//
//  FZMessageViewController.h
//  Fangzhur
//
//  Created by --超-- on 14/12/11.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "SOMessagingViewController.h"
#import "FZHouseDetailModel.h"

@interface FZMessageViewController : SOMessagingViewController
<UIAlertViewDelegate>

@property (nonatomic, strong) FZHouseDetailModel *detailModel;

@end
