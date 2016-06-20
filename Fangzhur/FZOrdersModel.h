//
//  FZOrdersModel.h
//  Fangzhur
//
//  Created by --Chao-- on 14-7-4.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import <Foundation/Foundation.h>

//我的订单数据模型
@interface FZOrdersModel : NSObject

//订单ID
@property (nonatomic, copy) NSString *orderID;
//订单编号
@property (nonatomic, copy) NSString *jiaoy_no;
//城区ID
@property (nonatomic, copy) NSString *cityarea_id;
//城区名称
@property (nonatomic, copy) NSString *quyu;
//小区ID
@property (nonatomic, copy) NSString *qu_id;
//小区名称
@property (nonatomic, copy) NSString *qu_name;
//支付方式
@property (nonatomic, copy) NSString *method_payment;
//使用房码金额
@property (nonatomic, copy) NSString *fangbi;
//使用现金金额
@property (nonatomic, copy) NSString *use_xianjin;
//成交价格
@property (nonatomic, copy) NSString *cjjg;
//房源ID
@property (nonatomic, copy) NSString *house_id;
//房源类型
@property (nonatomic, copy) NSString *house_type;
//自助交易发布者ID
@property (nonatomic, copy) NSString *member_id;
//服务顾问姓名
@property (nonatomic, copy) NSString *adviser_realname;
//服务顾问电话
@property (nonatomic, copy) NSString *adviser_phone;
//订单类型
@property (nonatomic, copy) NSString *service_type;
//订单价格
@property (nonatomic, copy) NSString *service_price;
//订单服务状态
@property (nonatomic, copy) NSString *order_state;
//订单状态
@property (nonatomic, copy) NSString *service_state;
//下单时间
@property (nonatomic, copy) NSString *service_time;
//完成时间
@property (nonatomic, copy) NSString *finish_time;
//举报订单标记
@property (nonatomic, copy) NSString *informFlag;
//顾问数组
@property (nonatomic, retain) NSArray *rob_list;

@end
