//
//  NSTimer+Addition.m
//  Fangzhur
//
//  Created by --超-- on 14/11/2.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "NSTimer+Addition.h"

@implementation NSTimer (Addition)

- (void)pauseTimer
{
    if ([self isValid]) {
        [self setFireDate:[NSDate distantFuture]];
    }
}

- (void)resumeTimer
{
    if ([self isValid]) {
        [self setFireDate:[NSDate date]];
    }
}

- (void)resumeTimerAfterInterval:(NSTimeInterval)interval
{
    if ([self isValid]) {
        [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
    }
}

@end
