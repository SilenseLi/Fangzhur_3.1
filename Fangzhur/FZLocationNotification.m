//
//  FZLocationNotification.m
//  Fangzhur
//
//  Created by --超-- on 15/1/21.
//  Copyright (c) 2015年 Zc. All rights reserved.
//

#import "FZLocationNotification.h"

@implementation FZLocationNotification

+ (UILocalNotification *)openLocationPush
{
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    UILocalNotification *notification = notifications.lastObject;
    if (!notification) {
        notification = [[UILocalNotification alloc] init];
        
        CGFloat timeInterval = [[NSDate date] timeIntervalSince1970];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy'-'MM'-'dd HH:mm:ss"];
        NSString *currentDateString = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
        NSArray *timeArray = [[currentDateString componentsSeparatedByString:@" "].lastObject componentsSeparatedByString:@":"];
        CGFloat addedInteval = (24 * 60 * 60) - ([timeArray[0] integerValue] * 60 * 60 + [timeArray[1] integerValue] * 60 + [timeArray[2] integerValue]) + (17 * 60 * 60 + 30 * 60);
        
        NSDate *pushDate = [NSDate dateWithTimeInterval:timeInterval + addedInteval sinceDate:[NSDate date]];
        //设置 推送时间
        notification.fireDate = pushDate;
        //设置 时区
        notification.timeZone = [NSTimeZone defaultTimeZone];
        //设置 重复间隔
        notification.repeatInterval = kCFCalendarUnitDay;

        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.alertBody = @"小主儿！好房子已经为您订制完成，快到“私人定制”里查看吧！";
        //设置 icon 上 红色数字
        notification.applicationIconBadgeNumber = 0;
        //取消 推送 用的 字典  便于识别
        NSDictionary *inforDic = [NSDictionary dictionaryWithObject:@"私人定制" forKey:@"LocationPush"];
        notification.userInfo = inforDic;
        //添加推送到 Application
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    
    return notification;
}

+ (void)closeLocationPush
{
    NSArray *array = [[UIApplication sharedApplication] scheduledLocalNotifications];

    for (UILocalNotification *notification in array) {
        if ([[notification.userInfo objectForKey:@"LocationPush"] isEqualToString:@"私人定制"]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}

@end
