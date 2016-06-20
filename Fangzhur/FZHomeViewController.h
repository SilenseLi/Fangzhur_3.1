//
//  FZHomeViewController.h
//  Fangzhur
//
//  Created by --超-- on 14/10/22.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZRootTableViewController.h"
#import "FZHomeTopScrollView.h"
#import "BMapKit.h"
#import <CoreLocation/CoreLocation.h>

@interface FZHomeViewController : FZRootTableViewController
<CLLocationManagerDelegate, BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) FZHomeTopScrollView *topScrollView;
@property (nonatomic, strong) NSMutableArray *imageURLArray;
@property (nonatomic, strong) NSMutableArray *linksArray;
@property (nonatomic, strong) NSMutableArray *adViewsArray;

@end
