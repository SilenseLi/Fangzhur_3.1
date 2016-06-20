//
//  FZLocationNotification.h
//  Fangzhur
//
//  Created by --超-- on 15/1/21.
//  Copyright (c) 2015年 Zc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FZLocationNotification : NSObject

+ (UILocalNotification *)openLocationPush;
+ (void)closeLocationPush;

@end
