//
//  FZHouseMapView.h
//  Fangzhur
//
//  Created by --超-- on 14/11/24.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface FZHouseMapView : UIView
<BMKMapViewDelegate, BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, readonly) NSString *address;
@property (nonatomic, copy) void (^reverseEgocodeBlock)(NSString *location);

- (void)startReverseGeocodeWithLatitude:(NSString *)latitude longitude:(NSString *)longitude;

/** Renew map view center */
- (void)resetMapView;

@end
