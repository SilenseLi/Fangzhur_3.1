//
//  FZChangeCityViewController.h
//  Fangzhur
//
//  Created by --Chao-- on 14-6-23.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZRootTableViewController.h"
#import "BMapKit.h"
#import <CoreLocation/CoreLocation.h>

//切换城市
@interface FZChangeCityViewController : FZRootTableViewController
<CLLocationManagerDelegate, BMKGeoCodeSearchDelegate>

@end
