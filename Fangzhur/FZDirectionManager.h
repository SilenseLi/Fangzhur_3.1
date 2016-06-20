//
//  FZDirectionManager.h
//  Fangzhur
//
//  Created by --超-- on 14/11/17.
//  Copyright (c) 2014年 Zc. All rights reserved.
//
// 该类用于确定两个经纬度之间的距离和方位

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface FZDirectionManager : NSObject

+ (NSString *)bearingToLocationFromCoordinate:(CLLocation*)beginLocation toCoordinate:(CLLocation*)endLocation;

@end
