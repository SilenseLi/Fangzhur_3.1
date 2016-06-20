//
//  FZContractModel.h
//  Fangzhur
//
//  Created by --超-- on 14/12/15.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZROrderReleasedInfoModel.h"

@interface FZContractModel : NSObject

/** 房源编号 */
@property (nonatomic, strong) NSString *houseNumber;
@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, assign) NSInteger count;
/** 缓存筛选的数据 */
@property (nonatomic, strong) NSMutableArray *cacheArray;
//用于请求的参数字典
@property (nonatomic, strong) NSMutableDictionary *paramDict;
//城区数组
@property (nonatomic, strong) NSArray *regionArray;
@property (nonatomic, readonly, strong) NSDictionary *regionDict;
/** 选中的城区 */
@property (nonatomic, copy) NSString *selectedRegion;
//发布后的订单数据
@property (nonatomic, strong) FZROrderReleasedInfoModel *orderModel;

- (instancetype)initWithHouseNumber:(NSString *)houseNumber;

/** 获取对应section下的所有内容 */
- (NSArray *)contentsOfSection:(NSString *)sectionTitle;
/** 获取对应的section下的缓存数据 */
- (NSString *)cacheOfSection:(NSInteger)section;
/** 生成订单请求参数 */
- (void)loadRequestParameters;
/** 生成订单信息，用于线上交易同步显示 */
- (void)generateOrderInfo;

- (void)resetCacheArray;

@end
