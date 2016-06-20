//
//  FZPayMentHouseModel.h
//  Fangzhur
//
//  Created by fq on 14/12/23.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FZPaymentModel : NSObject <NSCoding>

/** 房源编号 */
@property (nonatomic, copy) NSString *houseNumber;

//银行信息
@property (nonatomic, strong) NSMutableArray *bankNameArray;
@property (nonatomic, strong) NSMutableArray *bankIDArray;

/** 缓存筛选的数据 */
@property (nonatomic, strong) NSMutableArray *firstCacheArray;
@property (nonatomic, strong) NSMutableArray *secondCacheArray;
@property (nonatomic, strong) NSMutableArray *thirdCacheArray;
@property (nonatomic, strong) NSMutableArray *forthCacheArray;
//总费用
@property (nonatomic, assign, readonly) NSInteger totalPrice;
//手续费
@property (nonatomic, assign, readonly) NSInteger commission;

/** 用于进行网络请求的参数 */
@property (nonatomic, strong) NSMutableDictionary *parameters;


- (instancetype)initWithHouseNumber:(NSString *)houseNumber;
/** 获取 Section titles */
- (NSArray *)sectionTitlesOfController:(UIViewController *)controller;
/** Get section content */
- (id)sectionContentsOfController:(UIViewController *)controller section:(NSInteger)section;
/** 生成订单请求参数 */
- (NSDictionary *)requestParameters;
/** 获取缓存订单数据 key: orderID */
- (void)getAndStoreCacheDataWithOrderID:(NSString *)orderID;

@end
