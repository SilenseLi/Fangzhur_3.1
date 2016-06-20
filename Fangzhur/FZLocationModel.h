//
//  FZLocationModel.h
//  Fangzhur
//
//  Created by --超-- on 14/11/7.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface FZLocationModel : UIView
<CLLocationManagerDelegate>

@property (nonatomic, assign) CLLocationCoordinate2D currentCoordinate;
/** 用于存放要排序的坐标点 */
@property (nonatomic, readonly) NSMutableArray *coordinateArray;

+ (FZLocationModel *)model;

/** 获取用户当前位置 */
- (void)getCurrentLocation:(void (^)(BOOL success, CLLocation *currentLocation))completedBlock;
/** 对坐标点进行由近到远排序 */
- (NSArray *)coordinates:(NSArray *)coordinates SortedByCurrentLocation:(CLLocation *)currentLocation;

@end
