//
//  FZHouseDetailViewController.h
//  Fangzhur
//
//  Created by --超-- on 14/11/21.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZRootTableViewController.h"
#import "FZHouseDetailModel.h"
#import "FZHouseDetailHeader.h"

@interface FZHouseDetailViewController : FZRootTableViewController

// Tag / Screen / Search / Verify
@property (nonatomic, copy) NSString *houselistType;
@property (nonatomic, copy) NSString *houseType;
@property (nonatomic, strong) FZHouseDetailModel *detailModel;
@property (nonatomic, strong) NSString *imageURLs;

@property (nonatomic, strong) FZHouseDetailHeader *headerView;
@property (nonatomic, strong) UIButton *seeHouseButton;

- (void)popViewController;

@end
