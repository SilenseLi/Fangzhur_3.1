//
//  FZSubmitHouseViewController.h
//  Fangzhur
//
//  Created by --超-- on 14/12/3.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZReleaseHouseRootViewController.h"
#import "FZReleaseHouseModel.h"

@interface FZSubmitHouseViewController : FZReleaseHouseRootViewController

@property (nonatomic, strong) NSMutableDictionary *paramDict;
@property (nonatomic, strong) FZReleaseHouseModel *releaseModel;

@end
