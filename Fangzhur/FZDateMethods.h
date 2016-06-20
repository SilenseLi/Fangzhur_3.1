//
//  FZDateMethods.h
//  Fangzhur
//
//  Created by --超-- on 15/1/27.
//  Copyright (c) 2015年 Zc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FZDateMethods : NSObject

/** 获取从fromDate开始， monthNumber月后的日期 */
+ (NSDate *)dateFrom:(NSDate *)fromDate afterMonthNumber:(NSInteger)monthNumber;

@end
