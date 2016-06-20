//
//  FZHouseDetailModel.h
//  Fangzhur
//
//  Created by --Chao-- on 14-7-7.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import <Foundation/Foundation.h>

//房源详情数据模型
@interface FZHouseDetailModel : NSObject

//房源ID
@property (nonatomic, copy) NSString *houseID;
//房源类型 1Rent 2Sell
@property (nonatomic, copy) NSString *houseType;
//房源基本信息 商圈+小区+厅室+装修
@property (nonatomic, copy) NSString *houseInfo;
@property (nonatomic, copy) NSString *houseTitle;
//房源图片
@property (nonatomic, copy) NSString *house_thumb;
@property (nonatomic, copy) NSString *pic_thumb;
//房源价格
@property (nonatomic, copy) NSString *house_price;
//价格偏差(大于等于0 价格颜色为红色 小于0 价格颜色为绿色 ）
@property (nonatomic, copy) NSString *piancha;
//房源标签
@property (nonatomic, copy) NSString *house_tag;
//房源发布时间
@property (nonatomic, copy) NSString *releaseDate;
@property (nonatomic, copy) NSString *updated;
//房源可租时间
@property (nonatomic, copy) NSString *canlive;
//房主member_id
@property (nonatomic, copy) NSString *broker_id;
//房主爱称
@property (nonatomic, copy) NSString *owner_name;
//房主电话
@property (nonatomic, copy) NSString *owner_phone;
//房源图片数组
@property (nonatomic, strong) NSArray *tupian;

//房源描述
@property (nonatomic, copy) NSString *house_desc;
//总楼层
@property (nonatomic, copy) NSString *house_topfloor;
//所在楼层
@property (nonatomic, copy) NSString *house_floor;
//房源平米
@property (nonatomic, copy) NSString *house_totalarea;
//朝向
@property (nonatomic, copy) NSString *house_toward;
//房源坐标
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;

//感兴趣的房源
@property (nonatomic, strong) NSArray *tongjiage;
@property (nonatomic, strong) NSArray *tongxiaoqu;
//房源标签
@property (nonatomic, strong) NSArray *tag_id;
//感兴趣的标签
@property (nonatomic, strong) NSArray *tags_id;

//小区资料
@property (nonatomic, copy) NSString *borough_name;//小区名称
@property (nonatomic, copy) NSString *borough_address;//小区地址
@property (nonatomic, copy) NSString *borough_developer;//开发商
@property (nonatomic, copy) NSString *cityarea2_name;//区域
@property (nonatomic, copy) NSString *borough_bus;//公交交通
@property (nonatomic, copy) NSString *borough_hospital;//医院
@property (nonatomic, copy) NSString *borough_dining;//餐厅
@property (nonatomic, copy) NSString *borough_shop;//超市
@property (nonatomic, copy) NSString *borough_costs;//物业费
@property (nonatomic, copy) NSString *borough_company;//物业公司
@property (nonatomic, copy) NSString *borough_bank;//银行
@property (nonatomic, copy) NSString *borough_content;//小区描述
@property (nonatomic, copy) NSString *borough_parking;//停车位
@property (nonatomic, copy) NSString *borough_support;//周边
@property (nonatomic, copy) NSString *baseInfo;

//房源出租支付方式
//@"押一付一",@"1",@"押一付二",@"3",@"押一付三",@"5",@"押一付六",@"9",
//@"年付",@"10",@"押二付一",@"2",@"押二付二",@"4",@"押二付三",@"6",@"面议",@"11"
@property (nonatomic, copy) NSString *zujin_type;
//房源规模
@property (nonatomic, copy) NSString *house_room;//室
@property (nonatomic, copy) NSString *house_hall;//厅

//装修程度
//@"毛坯",@"1",@"简装修",@"2",@"精装修",@"3",@"豪华装修",@"4",@"中装修",@"5"
@property (nonatomic, copy) NSString *house_fitment;
//性别要求
@property (nonatomic, copy) NSString *gender_ask;
//住宅类型
//@"普通住宅",@"1",@"别墅",@"2",@"写字楼",@"5",@"商铺",@"7",
//@"公寓",@"10",@"平方四合院",@"11",@"商住",@"13", @"其他",@"12"
@property (nonatomic, copy) NSString *house_type;

//房源编号
@property (nonatomic, copy) NSString *house_no;
//卧室类型
@property (nonatomic, copy) NSString *bedroom_type;

//==================================================
//房源配置（用","分割）
//整租普通住宅-1 >>>>>>>>>>>>>>>>>>>>>>>>>>>
//@"空调",@"1",@"热水器",@"2",@"电视机",@"3",@"冰箱",@"10",@"洗衣机",@"16",@"床铺",@"8",@"沙发",@"9", @"衣柜",@"15",@"整体厨房",@"18",@"管道煤气",@"4",@"有线电视",@"13",@"电话",@"19",@"宽带",@"12",@"电梯",@"6",@"防盗网",@"17",@"车库",@"7"
//整租写字楼-5 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//@"宽带",@"1",@"车库",@"2"
//整租商铺-7 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//@"客梯",@"1",@"货梯",@"2",@"扶梯",@"3",@"暖气",@"4",@"空调",@"5",@"停车位",@"6",@"水",@"7",@"燃气",@"8",@"网络",@"9"

//合租 0 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//@"床铺",@"1",@"衣柜",@"2",@"沙发",@"3",@"电视机",@"4",@"冰箱",@"5",@"洗衣机",@"6",@"空调",@"7",@"热水器",@"8",@"宽带",@"9",@"有线电视",@"10",@"管道煤气",@"11",@"整体厨房",@"12"

//出售写字楼-5 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//@"宽带",@"1",@"车库",@"2"
//出售商铺-7 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//@"客梯",@"1",@"货梯",@"2",@"扶梯",@"3",@"暖气",@"4",@"空调",@"5",@"停车位",@"6",@"水",@"7",@"燃气",@"8",@"网络",@"9"
@property (nonatomic, copy) NSString *house_support;
//房屋特点
//整租普通住宅-1 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//@"随时看房",@"1",@"精装齐全",@"2",@"主卧带独卫",@"3",@"可注册办公",@"4",@"交通便利",@"5",@"地铁房",@"6",@"繁华商圈",@"7",@"拎包入住",@"8",@"可供短租",@"9",@"温泉水",@"10",@"首次出租",@"11",@"不可养宠物",@"12", @"价格可议",@"13", @"需要长租",@"14"
//整租写字楼-5  整租商铺-7 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//@"免中介费",@"1",@"可注册",@"2",@"赠免租期",@"3",@"交通便利",@"4",@"名企入驻",@"5",@"中心商务区",@"6", @"地标建筑",@"7",@"知名物业",@"8",@"繁华商圈",@"9",@"创业首选",@"10"
//合租 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//@"和业主签订合同",@"1",@"独立卫生间",@"2",@"独立阳台",@"3",@"公共客厅",@"4",@"厨房可做饭",@"5", @"拎包入住",@"7", @"气氛融洽", @"8",@"定期保洁",@"9", @"不可养宠物",@"10", @"价格可议",@"11"
//出售 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//@"学区房",@"1",@"地铁房",@"6",@"满五年",@"8",@"唯一房",@"14",@"免税房",@"15",@"房东急售",@"12",@"不限购",@"16", @"随时看房",@"13",@"附送家具",@"11",@"黄金商圈",@"3",@"复式LOFT",@"17"
@property (nonatomic, copy) NSString *house_feature;


@end
