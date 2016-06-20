//
//  JCheckPhoneNumber.m
//  AgentAPP
//
//  Created by --超-- on 14-5-16.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "JCheckPhoneNumber.h"

@implementation JCheckPhoneNumber

//手机号码格式验证
+ (BOOL)isMobileNumber:(NSString *)aString
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString *MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0235-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     */
    NSString *CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,152,155,156,185,186
     */
    NSString *CU = @"^1(3[0-2]|5[256]|8[56]|7[6])\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,1349,153,180,189
     */
    NSString *CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:aString] == YES)
        || ([regextestcm evaluateWithObject:aString] == YES)
        || ([regextestct evaluateWithObject:aString] == YES)
        || ([regextestcu evaluateWithObject:aString] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
