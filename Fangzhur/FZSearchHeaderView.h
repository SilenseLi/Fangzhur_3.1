//
//  FZSearchHeaderView.h
//  Fangzhur
//
//  Created by --超-- on 14/11/7.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import <CoreLocation/CoreLocation.h>

@protocol FZSearchHeaderViewDelegate;

@interface FZSearchHeaderView : UIView
<CLLocationManagerDelegate, BMKGeoCodeSearchDelegate>

@property (nonatomic, weak) id<FZSearchHeaderViewDelegate> delegate;
@property (nonatomic, strong) UIButton *locateButton;

@end

@protocol FZSearchHeaderViewDelegate <NSObject>

- (void)searchHeaderView:(FZSearchHeaderView *)headerView completedLocation:(CLLocationCoordinate2D)coordinate;
- (void)changeCityButtonClicked;

@end
