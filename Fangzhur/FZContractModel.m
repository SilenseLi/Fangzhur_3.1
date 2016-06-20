//
//  FZContractModel.m
//  Fangzhur
//
//  Created by --超-- on 14/12/15.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZContractModel.h"
#import "DataBaseManager.h"

@interface FZContractModel ()

@property (nonatomic, strong) NSDictionary *dataDict;

@end

@implementation FZContractModel

- (instancetype)initWithHouseNumber:(NSString *)houseNumber
{
    self = [super init];
    
    if (self) {
        self.dataDict = [ZCReadFileMethods dataFromPlist:@"ContractListData" ofType:Dictionary];
        self.sectionTitles = [self.dataDict objectForKey:@"SectionTitle"];
        self.houseNumber = houseNumber;
        self.count = self.sectionTitles.count;
        self.cacheArray = [[NSMutableArray alloc] initWithObjects:
                           houseNumber, @"选择", @"0", @"", @"0", @"0", @"0", @"0", nil];
        self.paramDict = [[NSMutableDictionary alloc] init];
        self.orderModel = [[FZROrderReleasedInfoModel alloc] init];
        _regionDict = [[NSDictionary alloc] initWithDictionary:[[DataBaseManager shareManager] cityRegion]];
    }
    
    return self;
}

- (void)loadRequestParameters
{
    [self.paramDict setObject:[self.cacheArray objectAtIndex:3] forKey:@"cjjg"];
    [self.paramDict setObject:[self idWithSectionName:@"服务类型" selectedIndex:[[self.cacheArray objectAtIndex:4] intValue]] forKey:@"service_type"];
    [self.paramDict setObject:[self idWithSectionName:@"付款方式" selectedIndex:[[self.cacheArray objectAtIndex:5] intValue]] forKey:@"method_payment"];
    [self.paramDict setObject:FZUserInfoWithKey(Key_UserName) forKey:@"username"];
    [self.paramDict setObject:FZUserInfoWithKey(Key_MemberID) forKey:@"member_id"];
    [self.paramDict setObject:FZUserInfoWithKey(Key_LoginToken) forKey:@"token"];
    
    // 房码 2不使用，1使用
    if ([[self.cacheArray objectAtIndex:7] intValue] == 0) {
        [self.paramDict setObject:@"2" forKey:@"use_fangbi"];
        [self.paramDict setObject:@"0" forKey:@"fangbi"];
    }
    else {
        [self.paramDict setObject:@"1" forKey:@"use_fangbi"];
        if ([FZUserInfoWithKey(Key_UserTickets) intValue] >= 200) {
            [self.paramDict setObject:@"200" forKey:@"fangbi"];
        }
        else {
            [self.paramDict setObject:FZUserInfoWithKey(Key_UserTickets) forKey:@"fangbi"];
        }
    }
    
    if ([[self.cacheArray objectAtIndex:0] length] == 0) {
        [self.paramDict setObject:[self.regionDict objectForKey:[self.regionArray objectAtIndex:[[self.cacheArray objectAtIndex:2] intValue]]] forKey:@"cityarea_id"];
    }
}

////订单ID
//@property (nonatomic, copy) NSString *jiaoyi_id;
////服务类型
//@property (nonatomic, copy) NSString *service_type;
////服务价格
//@property (nonatomic, copy) NSString *service_price;
////所在城区
//@property (nonatomic, copy) NSString *cityarea_name;
////所在小区
//@property (nonatomic, copy) NSString *qu_name;
////成交价格
//@property (nonatomic, copy) NSString *cjjg;
////需要支付的金额
//@property (nonatomic, copy) NSString *needmoney;
- (void)generateOrderInfo
{
    self.orderModel.service_type = [self idWithSectionName:@"服务类型" selectedIndex:[[self.cacheArray objectAtIndex:4] intValue]];
    
    if ([self.orderModel.service_type isEqualToString:@"1"]) {
        self.orderModel.service_price = @"600";
    }
    else if ([self.orderModel.service_type isEqualToString:@"2"]) {
        self.orderModel.service_price = @"5000";
    }
    else if ([self.orderModel.service_type isEqualToString:@"6"]) {
        self.orderModel.service_price = @"5000";
    }
    else if ([self.orderModel.service_type isEqualToString:@"7"]) {
        self.orderModel.service_price = @"8000";
    }
    
    self.orderModel.cityarea_name = [self.regionArray objectAtIndex:[[self.cacheArray objectAtIndex:2] intValue]];
    self.orderModel.qu_name = [self.cacheArray objectAtIndex:1];
    self.orderModel.cjjg = [self.cacheArray objectAtIndex:3];
}

- (NSString *)idWithSectionName:(NSString *)sectionName selectedIndex:(NSInteger)index
{
    return [[[[self.dataDict objectForKey:@"SectionItem"]
            objectForKey:sectionName]
            objectForKey:@"ItemID"]
            objectAtIndex:index];
}

- (void)resetCacheArray
{
    [self.cacheArray setArray:@[@"", @"选择", @"0", @"", @"0", @"0", @"0", @"0"]];
}

- (NSArray *)contentsOfSection:(NSString *)sectionTitle
{
    if ([sectionTitle isEqualToString:@"服务类型"] ||
        [sectionTitle isEqualToString:@"付款方式"] ||
        [sectionTitle isEqualToString:@"现金账户余额"] ||
        [sectionTitle isEqualToString:@"房码余额"]) {
        return [[[self.dataDict objectForKey:@"SectionItem"]
                 objectForKey:sectionTitle]
                objectForKey:@"ItemName"];
    }
    else if ([sectionTitle isEqualToString:@"城区"]) {
        NSMutableArray *resultArray = [NSMutableArray array];
        [resultArray addObjectsFromArray:[FZUserInfoWithKey(key_CityRegion) allKeys]];
        
        return resultArray;
    }
    else {
        return nil;
    }
}

- (NSString *)cacheOfSection:(NSInteger)section
{
    return [self.cacheArray objectAtIndex:section];
}

- (NSArray *)regionArray
{
    if (!_regionArray) {
        _regionArray = [NSMutableArray arrayWithArray:[[DataBaseManager shareManager] cityRegion].allKeys];
    }
    
    return _regionArray;
}

@end
