//
//  FZMobileLoginViewController.h
//  Fangzhur
//
//  Created by --超-- on 14/11/3.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZMobileLoginView.h"

@interface FZMobileLoginViewController : UIViewController
<FZMobileLoginViewDelegate>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) FZMobileLoginView *mobileLoginView;

@end
