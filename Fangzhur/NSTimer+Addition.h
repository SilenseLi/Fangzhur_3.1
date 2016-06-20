//
//  NSTimer+Addition.h
//  Fangzhur
//
//  Created by --超-- on 14/11/2.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Addition)

- (void)pauseTimer;
- (void)resumeTimer;
- (void)resumeTimerAfterInterval:(NSTimeInterval)interval;

@end
