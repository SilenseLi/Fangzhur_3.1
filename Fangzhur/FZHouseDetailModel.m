//
//  FZHouseDetailModel.m
//  Fangzhur
//
//  Created by --Chao-- on 14-7-7.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZHouseDetailModel.h"


@implementation FZHouseDetailModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{}

#pragma mark - Setter -

- (void)setHouse_price:(NSString *)house_price
{
    CGFloat housePrice = house_price.doubleValue;

    if (housePrice == 0) {
        _house_price = @"面议";
        return;
    }
    
    if ([_houseType isEqualToString:@"Rent"] ||
        [_houseType isEqualToString:@"1"]) {
        if (housePrice >= 10000) {
            _house_price = [NSString stringWithFormat:@"%.1lf 万元/月", housePrice / 10000.0f];
        }
        else {
            _house_price = [NSString stringWithFormat:@"%@ 元/月", house_price];
        }
    }
    else {
        _house_price = [NSString stringWithFormat:@"%@ 万元", house_price];
    }
}

- (void)setCanlive:(NSString *)canlive
{
    NSMutableString *tempString = nil;
    
    if ([_houseType isEqualToString:@"1"]) {
        tempString = [[NSMutableString alloc] initWithString:@"可租时间："];
    }
    else {
        tempString = [[NSMutableString alloc] initWithString:@"可售时间："];
    }
    if ([canlive isEqualToString:@"0"]) {
        [tempString appendString:@"现在"];
    }
    else {
        dateExchange(canlive.integerValue, canlive);
        [tempString appendString:canlive];
    }
    
    _canlive = tempString;
}

- (void)setHouse_toward:(NSString *)house_toward
{
    NSDictionary *towardsDict = [[ZCReadFileMethods dataFromPlist:@"HouseDetailDataList" ofType:Dictionary] objectForKey:@"house_toward"];
    _house_toward = [towardsDict objectForKey:house_toward];
}

- (void)setHouse_type:(NSString *)house_type
{
    NSDictionary *towardsDict = [[ZCReadFileMethods dataFromPlist:@"HouseDetailDataList" ofType:Dictionary] objectForKey:@"house_type"];
    _house_type = [towardsDict objectForKey:house_type];
}

#pragma mark - Getter -

- (NSArray *)tupian
{
    NSMutableArray *urlArray = [[NSMutableArray alloc] init];
    for (NSDictionary *pictureDict in _tupian) {
        [urlArray addObject:[pictureDict objectForKey:@"pic_url"]];
    }
    
    return [urlArray copy];
}

- (NSString *)house_fitment
{
    if (_house_fitment.integerValue == 1) {
        return @"毛坯";
    }
    else if (_house_fitment.integerValue == 2) {
        return @"简装";
    }
    else if (_house_fitment.integerValue == 3) {
        return @"精装";
    }
    else {
        return @"";
    }
}

- (NSString *)houseInfo
{
    return [[NSString stringWithFormat:@"%@%@   %@室%@厅   %@",
             self.cityarea2_name,
             self.borough_name,
             self.house_room,
             self.house_hall,
             self.house_fitment] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
}

//- (NSString *)houseType
//{
//    if ([_houseType isEqualToString:@"1"]) {
//        return @"出租";
//    }
//    else {
//        return @"出售";
//    }
//}

- (NSString *)baseInfo
{
    return [NSString stringWithFormat:
            @"小区名称：%@\n小区地址：%@\n区域：%@\n开发商：%@\n物业公司：%@\n物业费：%@\n停车位：%@\n交通：%@\n周边：%@",
            self.borough_name, self.borough_address, self.cityarea2_name, self.borough_developer, self.borough_company, self.borough_costs, self.borough_bus, self.borough_parking, self.borough_support];
}

- (NSString *)borough_address
{
    if (!_borough_address) {
        return @"";
    }
    else {
        return _borough_address;
    }
}

- (NSString *)cityarea2_name
{
    if (!_cityarea2_name) {
        return @"";
    }
    else {
        return _cityarea2_name;
    }
}

- (NSString *)borough_developer
{
    if (!_borough_developer) {
        return @"";
    }
    else {
        return _borough_developer;
    }
}

- (NSString *)borough_company
{
    if (!_borough_company) {
        return @"";
    }
    else {
        return _borough_company;
    }
}

- (NSString *)borough_costs
{
    if (!_borough_costs) {
        return @"";
    }
    else {
        return [NSString stringWithFormat:@"%@元", _borough_costs];
    }
}

- (NSString *)borough_bus
{
    if (!_borough_bus) {
        return @"";
    }
    else {
        return _borough_bus;
    }
}

- (NSString *)borough_parking
{
    if (!_borough_parking) {
        return @"";
    }
    else {
        return _borough_parking;
    }
}

- (NSString *)borough_support
{
    if (!_borough_support) {
        return @"";
    }
    else {
        return _borough_support;
    }
}

- (NSString *)owner_name
{
    if (!_owner_name || _owner_name.length == 0) {
        return @"房主爱称：保密";
    }
    else {
        return [NSString stringWithFormat:@"房主爱称：%@", _owner_name];
    }
}

@end
