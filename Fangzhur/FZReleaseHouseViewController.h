//
//  FZReleaseHouseViewController.h
//  Fangzhur
//
//  Created by --超-- on 14/11/30.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZReleaseHouseRootViewController.h"
#import "FZReleaseHouseModel.h"

@interface FZReleaseHouseViewController : FZReleaseHouseRootViewController

@property (nonatomic, strong) NSMutableDictionary *paramDict;
@property (nonatomic, strong) FZReleaseHouseModel *releaseModel;

- (instancetype)initWithReleaseType:(NSString *)releaseType houseType:(NSString *)houseType;

@end
