//
//  FZHouseListModel.m
//  Fangzhur
//
//  Created by --超-- on 14/11/16.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZHouseListModel.h"

@implementation FZHouseListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{}

- (void)setHouse_price:(NSString *)house_price
{
    CGFloat housePrice = house_price.doubleValue;
    
    if (housePrice == 0) {
        _house_price = @"面议";
        return;
    }
    
    if ([_houseType isEqualToString:@"Rent"] || [_houseType isEqualToString:@"1"] || [_houseType isEqualToString:@"出租"]) {
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

- (void)setUpdated:(NSString *)updated
{
    dateExchange(updated.integerValue, updated);
    _updated = updated;
}

- (void)setHouse_fitment:(NSString *)house_fitment
{
    if (house_fitment.integerValue == 1) {
        _house_fitment = @"毛坯";
    }
    else if (house_fitment.integerValue == 2) {
        _house_fitment = @"简装";
    }
    else if (house_fitment.integerValue == 3) {
        _house_fitment = @"精装";
    }
    else {
        _house_fitment = @" ";
    }
}

- (NSString *)house_totalarea
{
    if (!_house_totalarea) {
        return @"未知";
    }
    else {
        return _house_totalarea;
    }
}

- (NSString *)houseInfo
{
    if ([_houseType isEqualToString:@"Rent"] || [_houseType isEqualToString:@"1"] || [_houseType isEqualToString:@"出租"])
    {
        return [[NSString stringWithFormat:@"%@%@   %@室%@厅   %@",
                 self.cityarea2_name,
                 self.borough_name,
                 self.house_room,
                 self.house_hall,
                 self.house_fitment] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    }
    else {
        return [[NSString stringWithFormat:@"%@%@   %@平米   %@",
                 self.cityarea2_name,
                 self.borough_name,
                 self.house_totalarea,
                 self.house_fitment] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    }
}

@end
