//
//  AccelerometerManager.m
//  Fangzhur
//
//  Created by --超-- on 14/12/2.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "AccelerometerManager.h"
#import <CoreMotion/CoreMotion.h>

@interface AccelerometerManager ()

@property CMMotionManager *motionManager;

@end

@implementation AccelerometerManager

static AccelerometerManager *manager = nil;

+ (void)startAccelerometerWithHandler:(void (^)(BOOL))handler
{
    if (!manager) {
        manager = [[AccelerometerManager alloc] init];
        manager.motionManager = [[CMMotionManager alloc] init];
        manager.motionManager.accelerometerUpdateInterval = 0.1;
    }
    
    if (manager.motionManager.accelerometerAvailable) {
        [manager.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            double angle = atan(accelerometerData.acceleration.y / accelerometerData.acceleration.x);
            if (angle <= 10 && angle >= -10) {
                handler(YES);
            }
            else {
                handler(NO);
            }
        }];
    }
    else {
        NSLog(@"加速器不可用!");
    }
}

+ (void)stopAccelerometer
{
    [manager.motionManager stopAccelerometerUpdates];
    manager = nil;
}

@end
