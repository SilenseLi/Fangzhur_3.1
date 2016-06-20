//
//  FZDateMethods.m
//  Fangzhur
//
//  Created by --超-- on 15/1/27.
//  Copyright (c) 2015年 Zc. All rights reserved.
//

#import "FZDateMethods.h"

@implementation FZDateMethods

+ (NSDate *)dateFrom:(NSDate *)fromDate afterMonthNumber:(NSInteger)monthNumber
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:monthNumber];
    [adcomps setDay:0];
    
    return [calendar dateByAddingComponents:adcomps toDate:fromDate options:0];
}

@end
