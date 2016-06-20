//
//  FZROrderInfoModel.h
//  SelfBusiness
//
//  Created by --Chao-- on 14-6-12.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import <Foundation/Foundation.h>

//获取发布订单的数据
@interface FZROrderReleasedInfoModel : NSObject

//订单编号
@property (nonatomic, copy) NSString *jiaoy_no;
//订单ID
@property (nonatomic, copy) NSString *jiaoyi_id;
//服务类型
@property (nonatomic, copy) NSString *service_type;
//服务价格
@property (nonatomic, copy) NSString *service_price;
//所在城区
@property (nonatomic, copy) NSString *cityarea_name;
//所在小区
@property (nonatomic, copy) NSString *qu_name;
//成交价格
@property (nonatomic, copy) NSString *cjjg;
//需要支付的金额
@property (nonatomic, copy) NSString *needmoney;
//ip地址，定位订单
@property (nonatomic, copy) NSString *ip;


@end
