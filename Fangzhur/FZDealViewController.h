//
//  FZDealViewController.h
//  Fangzhur
//
//  Created by --超-- on 14-7-24.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZScrolledNavigationBarController.h"
#import "FZHTTPRequest.h"

@interface FZDealViewController : FZScrolledNavigationBarController
<UITextFieldDelegate>

@property (nonatomic, copy) NSString *houseType;
@property (nonatomic, copy) NSString *houseID;

@end
