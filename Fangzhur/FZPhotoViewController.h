//
//  FZPhotoViewController.h
//  Fangzhur
//
//  Created by --超-- on 14/12/2.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZScrolledNavigationBarController.h"
#import "FZReleaseHouseModel.h"

@interface FZPhotoViewController : FZScrolledNavigationBarController

@property (nonatomic, strong) NSMutableDictionary *paramDict;
@property (nonatomic, strong) FZReleaseHouseModel *releaseModel;

@end
