//
//  FZPayBoltingModel.h
//  Fangzhur
//
//  Created by fq on 14/12/26.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <Foundation/Foundation.h>

//获取新建订单数据
@interface FZPayBoltingModel : NSObject
//用户id
@property (nonatomic,copy)NSString * member_id;
//关联的房源id (选填)
@property (nonatomic,copy)NSString * house_id;
//小区名称
@property (nonatomic,copy)NSString * borough_name;
//小区地址
@property (nonatomic,copy)NSString * borough_address;
//总面积
@property (nonatomic,copy)NSString * total_area;
//楼号 (选填)
@property (nonatomic,copy)NSString * building_no;
//单元 (选填)
@property (nonatomic,copy)NSString * house_unit;
//门牌号 (选填)
@property (nonatomic,copy)NSString * room_no;
//租金,以 "分" 为单位 一元钱=100分
@property (nonatomic,copy)NSString * rent_fee;
//押金
@property (nonatomic,copy)NSString * foregift;
//水电煤气费 以分为单位
@property (nonatomic,copy)NSString * other_fee;
//支付几个月
@property (nonatomic,copy)NSString * pay_month_num;
//入住时间
@property (nonatomic,copy)NSString * rent_starttime;
//房东类型 1.个人 2.公司
@property (nonatomic,copy)NSString * owner_type;
//银行开户行户主姓名
@property (nonatomic,copy)NSString * bank_membername;
//银行卡号
@property (nonatomic,copy)NSString * bank_card_no;
//银行名称
@property (nonatomic,copy)NSString * bank_id;
//银行名称
@property (nonatomic,copy)NSString * bank_name;
//开户银行地址
@property (nonatomic,copy)NSString * bank_address;
//房东电话 (必须为数字)
@property (nonatomic,copy)NSString * owner_phone;
//租房者身份证号码 (必须为数字)
@property (nonatomic,copy)NSString * guest_idcard;
//租房者姓名
@property (nonatomic,copy)NSString * guest_name;
//租房者电话
@property (nonatomic,copy)NSString * guest_phone;
//总支付金额
@property (nonatomic,copy)NSString * total_amount;
//订单id
@property (nonatomic,copy) NSString * order_id;
//订单生成时间
@property (nonatomic,copy)NSString * created_on;
@end
