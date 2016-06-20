//
//  AccelerometerManager.h
//  Fangzhur
//
//  Created by --超-- on 14/12/2.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccelerometerManager : NSObject

+ (void)startAccelerometerWithHandler:(void (^)(BOOL couldTakePhoto))handler;
+ (void)stopAccelerometer;

@end
