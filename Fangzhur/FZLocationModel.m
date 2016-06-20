//
//  FZLocationModel.m
//  Fangzhur
//
//  Created by --超-- on 14/11/7.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZLocationModel.h"
#import "FZHouseListModel.h"
#import "FZDirectionManager.h"

@interface FZLocationModel ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, copy) void (^locationBlock)(BOOL success, CLLocation *currentLocation);

@end

@implementation FZLocationModel

+ (FZLocationModel *)model
{
    FZLocationModel *model = [[self alloc] init];
    if (model) {
        model.locationManager = [[CLLocationManager alloc] init];
        model.locationManager.delegate = model;
        model.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        model.locationManager.distanceFilter = 100;
        if ([model.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [model.locationManager requestAlwaysAuthorization];
        }
    }
    
    return model;
}

- (void)getCurrentLocation:(void (^)(BOOL, CLLocation *))completedBlock
{
    self.locationBlock = completedBlock;
    
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager startUpdatingLocation];
    }
    else {
        if (self.locationBlock) {
            self.locationBlock(NO, nil);
        }
    }
}

- (NSArray *)coordinates:(NSArray *)coordinates SortedByCurrentLocation:(CLLocation *)currentLocation
{
    _coordinateArray = [[NSMutableArray alloc] initWithArray:coordinates];
    NSComparator comparator = ^(id obj1, id obj2) {
        FZHouseListModel *model1 = obj1;
        FZHouseListModel *model2 = obj2;
        CLLocation *location1 = [[CLLocation alloc] initWithLatitude:model1.lng.doubleValue
                                                           longitude:model1.lat.doubleValue];
        CLLocation *location2 = [[CLLocation alloc] initWithLatitude:model2.lng.doubleValue
                                                           longitude:model2.lat.doubleValue];
        if ([location1 distanceFromLocation:currentLocation] > [location2 distanceFromLocation:currentLocation]) {
            return NSOrderedDescending;
        }
        else if ([location1 distanceFromLocation:currentLocation] < [location2 distanceFromLocation:currentLocation]) {
            return NSOrderedAscending;
        }
        else {
            return NSOrderedSame;
        }
    };
    
    [_coordinateArray sortUsingComparator:comparator];
    return [_coordinateArray copy];
}

#pragma mark - Location manager delegate -

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    self.currentCoordinate = currentLocation.coordinate;
    [self.locationManager stopUpdatingLocation];
    
    if (self.locationBlock) {
        self.locationBlock(YES, currentLocation);
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (self.locationBlock) {
        self.locationBlock(NO, nil);
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [self.locationManager requestWhenInUseAuthorization];
            }
            break;
        default:
            break;  
            
    }
}

@end
