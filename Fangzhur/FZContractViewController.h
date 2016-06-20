//
//  FZContractViewController.h
//  Fangzhur
//
//  Created by --超-- on 14/12/14.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZRootTableViewController.h"
#import "FZContractModel.h"

@interface FZContractViewController : FZRootTableViewController

@property (nonatomic, copy) NSString *houseNumber;
@property (nonatomic, copy) NSString *houseType;
@property (nonatomic, readonly, strong) FZContractModel *contractModel;

@end
