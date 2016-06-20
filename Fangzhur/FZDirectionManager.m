//
//  FZDirectionManager.m
//  Fangzhur
//
//  Created by --超-- on 14/11/17.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZDirectionManager.h"

@implementation FZDirectionManager

double DegreesToRadians(double degrees) {return degrees * M_PI / 180;};
double RadiansToDegrees(double radians) {return radians * 180 / M_PI;};

+ (NSString *)bearingToLocationFromCoordinate:(CLLocation *)beginLocation toCoordinate:(CLLocation *)endLocation
{
    double lat1 = DegreesToRadians(beginLocation.coordinate.latitude);
    double lon1 = DegreesToRadians(beginLocation.coordinate.longitude);
    
    double lat2 = DegreesToRadians(endLocation.coordinate.latitude);
    double lon2 = DegreesToRadians(endLocation.coordinate.longitude);
    
    double dLon = lon2 - lon1;
    
    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    double radiansBearing = atan2(y, x);
    
    NSString *str = nil;
    double aDeg = RadiansToDegrees(radiansBearing);
    
    if (aDeg >= 75 && aDeg <= 105)
    {
        str = @"正东";
    }
    if (aDeg > 15 && aDeg < 75)
    {
        str = @"东北";
    }
    if (aDeg >= -15 && aDeg <= 15)
    {
        str = @"正北";
    }
    if (aDeg > -75 && aDeg < -15)
    {
        str = @"西北";
    }
    if (aDeg >= -105 && aDeg <= -75)
    {
        str = @"正西";
    }
    if (aDeg > -165 && aDeg < -105)
    {
        str = @"西南";
    }
    if ((aDeg >= 165 && aDeg <= 180) || (aDeg >= -180 && aDeg <= -165))
    {
        str = @"正南";
    }
    if (aDeg > 105 && aDeg < 165)
    {
        str = @"东南";
    }
    
    CLLocationDistance meters = [beginLocation distanceFromLocation:endLocation];
    if (meters >= 1000) {
        return [NSString stringWithFormat:@"%@约%ld公里", str, (long)meters / 1000];
    }
    else {
        return [NSString stringWithFormat:@"%@约%ld米", str, (long)meters];
    }
}

@end
