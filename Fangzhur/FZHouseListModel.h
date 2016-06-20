//
//  FZHouseListModel.h
//  Fangzhur
//
//  Created by --超-- on 14/11/16.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FZHouseListModel : NSObject

//房源ID
@property (nonatomic, copy) NSString *houseID;
//房源编号
@property (nonatomic, copy) NSString *house_no;
//房源类型
@property (nonatomic, copy) NSString *houseType;
//房屋价格
@property (nonatomic, copy) NSString *house_price;
//价格偏差 (大于等于0 价格颜色为红色 小于0 价格颜色为绿色 ）
@property (nonatomic, copy) NSString *piancha;
//房源发布时间
@property (nonatomic, copy) NSString *updated;
//点击次数
@property (nonatomic, copy) NSString *click_num;
//小区ID
@property (nonatomic, copy) NSString *borough_id;
//小区名
@property (nonatomic, copy) NSString *borough_name;
//小区longitude
@property (nonatomic, copy) NSString *lat;
//小区latitude
@property (nonatomic, copy) NSString *lng;
//商圈
@property (nonatomic, copy) NSString *cityarea2_name;
//室
@property (nonatomic, copy) NSString *house_room;
//厅
@property (nonatomic, copy) NSString *house_hall;
//总楼层
@property (nonatomic, copy) NSString *house_topfloor;
//房屋面积
@property (nonatomic, copy) NSString *house_totalarea;
//装修程度 @"毛坯",@"1",@"简装修",@"2",@"精装修",@"3"
@property (nonatomic, copy) NSString *house_fitment;
//房源图片地址
@property (nonatomic, copy) NSString *house_thumb;
//房源标签
@property (nonatomic, strong) NSArray *tag_id;
//Rent: 房屋信息 商圈 小区名 厅室 装修
//Sell: 房屋信息 商圈 小区名 面积 装修
@property (nonatomic, readonly) NSString *houseInfo;

@end
