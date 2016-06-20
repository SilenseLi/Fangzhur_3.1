//
//  JCheckPhoneNumber.h
//  AgentAPP
//
//  Created by --超-- on 14-5-16.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCheckPhoneNumber : NSObject

//手机号码格式验证
+ (BOOL)isMobileNumber:(NSString *)aString;

@end
