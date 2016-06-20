//
//  FZMessageModel.h
//  Fangzhur
//
//  Created by --超-- on 14/12/19.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <Foundation/Foundation.h>

//avatar = "";
//"checkin_time" = 0;
//cnt = 0;
//content = "\U4e0d\U662f";
//"created_on" = 1418942028;
//"house_id" = 903458;
//"house_type" = 1;
//id = 113;
//"payment_method" = 0;
//"person_num" = 0;
//"receive_time" = 1418955458;
//"receiver_id" = 1243366;
//"sender_id" = 738964;
//username = 15340146420;
@interface FZMessageModel : NSObject

@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *cnt;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *created_on;
@property (nonatomic, copy) NSString *house_id;
@property (nonatomic, copy) NSString *house_type;
@property (nonatomic, copy) NSString *receiver_id;
@property (nonatomic, copy) NSString *sender_id;
@property (nonatomic, copy) NSString *username;

- (NSString *)stringByHidePhoneTail;

@end
