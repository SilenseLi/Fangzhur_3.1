//
//  FZScreenViewController.h
//  Fangzhur
//
//  Created by --超-- on 14/11/8.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZRootTableViewController.h"

@interface FZScreenViewController : FZRootTableViewController

@property (nonatomic, weak) UIViewController* bindsController;
@property (nonatomic, copy) NSString *screenType;

@end
