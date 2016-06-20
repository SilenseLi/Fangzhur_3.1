//
//  FZPayMentHouseModel.m
//  Fangzhur
//
//  Created by fq on 14/12/23.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZPaymentModel.h"
#import "DataBaseManager.h"
#import "FZDateMethods.h"

#define RealPriceFrom(cacheArray, section)\
[NSString stringWithFormat:@"%ld", [[cacheArray objectAtIndex:section] integerValue] * 100]

#define displayedPriceOfKey(key)\
[NSString stringWithFormat:@"%ld", [[orderInfoDict objectForKey:key] integerValue] / 100]

@interface FZPaymentModel ()

@property (nonatomic,strong)NSDictionary * dataDict;

@end

@implementation FZPaymentModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.houseNumber forKey:@"HouseNumber"];
    [aCoder encodeObject:self.firstCacheArray forKey:@"FirstCacheArray"];
    [aCoder encodeObject:self.secondCacheArray forKey:@"SecondCacheArray"];
    [aCoder encodeObject:self.thirdCacheArray forKey:@"ThirdCacheArray"];
    [aCoder encodeObject:self.bankNameArray forKey:@"BankNameArray"];
    [aCoder encodeObject:self.bankIDArray forKey:@"BankIDArray"];
    [aCoder encodeObject:self.parameters forKey:@"Parameters"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [aDecoder decodeObjectForKey:@"HouseNumber"];
        [aDecoder decodeObjectForKey:@"FirstCacheArray"];
        [aDecoder decodeObjectForKey:@"SecondCacheArray"];
        [aDecoder decodeObjectForKey:@"ThirdCacheArray"];
        [aDecoder decodeObjectForKey:@"BankNameArray"];
        [aDecoder decodeObjectForKey:@"BankIDArray"];
        [aDecoder decodeObjectForKey:@"Parameters"];
    }
    
    return self;
}

- (instancetype)initWithHouseNumber:(NSString *)houseNumber
{
    self = [super init];
    if (self) {
        self.dataDict = [ZCReadFileMethods dataFromPlist:@"PaymentDataList" ofType:Dictionary];
        self.houseNumber = houseNumber;
        self.bankIDArray = [[NSMutableArray alloc] init];
        self.bankNameArray = [[NSMutableArray alloc] init];
        self.parameters = [[NSMutableDictionary alloc] init];
    }
    
    return self;
    
}

- (NSArray *)sectionTitlesOfController:(UIViewController *)controller
{
    return [[self.dataDict objectForKey:NSStringFromClass([controller class])] objectForKey:@"SectionTitles"];
}

- (id)sectionContentsOfController:(UIViewController *)controller section:(NSInteger)section
{
    return [[[self.dataDict objectForKey:NSStringFromClass([controller class])] objectForKey:@"SectionItems"]
            objectForKey:[[self sectionTitlesOfController:controller] objectAtIndex:section]];
}

- (NSDictionary *)requestParameters
{
    [self.parameters setObject:[self.firstCacheArray objectAtIndex:1] forKey:@"borough_name"];
    [self.parameters setObject:[self.firstCacheArray objectAtIndex:2] forKey:@"borough_address"];
    [self.parameters setObject:[self.firstCacheArray objectAtIndex:3] forKey:@"total_area"];
    [self.parameters setObject:[self.firstCacheArray objectAtIndex:4] forKey:@"building_no"];
    [self.parameters setObject:[self.firstCacheArray objectAtIndex:5] forKey:@"house_unit"];
    [self.parameters setObject:[self.firstCacheArray objectAtIndex:6] forKey:@"room_no"];
    
    [self.parameters setObject:RealPriceFrom(self.secondCacheArray, 0) forKey:@"rent_fee"];
    [self.parameters setObject:RealPriceFrom(self.secondCacheArray, 1) forKey:@"foregift"];
    [self.parameters setObject:[NSString stringWithFormat:@"%d", ([self.secondCacheArray[2] intValue] + 1)] forKey:@"pay_month_num"];
    [self.parameters setObject:RealPriceFrom(self.secondCacheArray, 3) forKey:@"other_fee"];
    NSString *dateString = [self.secondCacheArray objectAtIndex:4];
    dateString = [dateString substringWithRange:NSMakeRange(0, 10)];
    [self.parameters setObject:dateString forKey:@"rent_starttime"];
    [self.parameters setObject:[NSString stringWithFormat:@"%d", ([self.thirdCacheArray[0] intValue] + 1)] forKey:@"owner_type"];
    [self.parameters setObject:[self.thirdCacheArray objectAtIndex:1] forKey:@"bank_membername"];
    [self.parameters setObject:[self.thirdCacheArray objectAtIndex:2] forKey:@"bank_card_no"];
    [self.parameters setObject:self.bankIDArray[[self.thirdCacheArray[3] intValue]] forKey:@"bank_id"];
    [self.parameters setObject:[self.thirdCacheArray objectAtIndex:4] forKey:@"bank_address"];
    [self.parameters setObject:[self.thirdCacheArray objectAtIndex:5] forKey:@"owner_phone"];
    
    [self.parameters setObject:RealPriceFrom(self.forthCacheArray, 0) forKey:@"total_amount"];
    [self.parameters setObject:[self.forthCacheArray objectAtIndex:1] forKey:@"guest_name"];
    [self.parameters setObject:[self.forthCacheArray objectAtIndex:2] forKey:@"guest_idcard"];
    [self.parameters setObject:[self.forthCacheArray objectAtIndex:3] forKey:@"guest_phone"];
    
    [self.parameters setObject:FZUserInfoWithKey(Key_MemberID) forKey:@"member_id"];
    [self.parameters setObject:FZUserInfoWithKey(Key_LoginToken) forKey:@"token"];
    
    return self.parameters.copy;
}

#pragma mark - Getter -

- (NSMutableArray *)firstCacheArray
{
    if (!_firstCacheArray) {
        _firstCacheArray = [[NSMutableArray alloc] initWithObjects:@"", @"选择", @"-", @"", @"", @"", @"", nil];
    }
    
    return _firstCacheArray;
}

- (NSMutableArray *)secondCacheArray
{
    if (!_secondCacheArray) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy'-'MM'-'dd"];
        NSString *currentDateString = [formatter stringFromDate:[NSDate date]];
        currentDateString = [NSString stringWithFormat:@"%@ 至 %@",
                             currentDateString,
                             [formatter stringFromDate:[FZDateMethods dateFrom:[NSDate date] afterMonthNumber:1]]];
        _secondCacheArray = [[NSMutableArray alloc] initWithObjects:@"", @"", @"0", @"", currentDateString, nil];
    }

    return _secondCacheArray;
}

- (NSMutableArray *)thirdCacheArray
{
    if (!_thirdCacheArray) {
        _thirdCacheArray = [[NSMutableArray alloc] initWithObjects:@"0", @"", @"", @"", @"", @"", nil];
    }
    
    return _thirdCacheArray;
}

- (NSMutableArray *)forthCacheArray
{
    if (!_forthCacheArray) {
        if (FZUserInfoWithKey(Key_LoginToken)) {
            _forthCacheArray = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"%ld", self.totalPrice], @"", @"",FZUserInfoWithKey(Key_UserName), nil];
        }
        else {
            _forthCacheArray = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"%ld", self.totalPrice], @"", @"", @"", @"", nil];
        }
    }
    
    [_forthCacheArray replaceObjectAtIndex:0 withObject:
     [NSString stringWithFormat:@"%ld", self.totalPrice + self.commission]];
    
    return _forthCacheArray;
}

- (NSInteger)commission
{
    NSInteger price = self.totalPrice;
    NSInteger commission = 30;
    //手续费计算规则：低于3000，收取30；大于等于3000，收取本次费用的1%，向上取整
    if (price >= 3000) {
        CGFloat temp = price % 10;
        commission = (int)(price * 0.01f);
        if (temp != 0) {
            commission += 1;
        }
    }
    
    return commission;
}

- (NSInteger)totalPrice
{
    return
    [self.secondCacheArray[0] integerValue] +
    [self.secondCacheArray[3] integerValue] +
    [self.secondCacheArray[1] integerValue];
}

- (void)getAndStoreCacheDataWithOrderID:(NSString *)orderID
{
    for (NSDictionary *bankInfoDict in [[EGOCache globalCache] plistForKey:@"Banklist"]) {
        [self.bankIDArray addObject:[bankInfoDict objectForKey:@"id"]];
        [self.bankNameArray addObject:[bankInfoDict objectForKey:@"name"]];
    }
    
    NSDictionary *orderInfoDict = [[[EGOCache globalCache] plistForKey:orderID] objectForKey:@"data"];
    if ([[orderInfoDict objectForKey:@"house_id"] intValue] != 0) {
        [self.firstCacheArray replaceObjectAtIndex:0 withObject:[orderInfoDict objectForKey:@"house_id"]];
    }
    [self.firstCacheArray replaceObjectAtIndex:1 withObject:[orderInfoDict objectForKey:@"borough_name"]];
    [self.firstCacheArray replaceObjectAtIndex:2 withObject:[orderInfoDict objectForKey:@"borough_address"]];
    [self.firstCacheArray replaceObjectAtIndex:3 withObject:[orderInfoDict objectForKey:@"total_area"]];
    [self.firstCacheArray replaceObjectAtIndex:4 withObject:[orderInfoDict objectForKey:@"building_no"]];
    [self.firstCacheArray replaceObjectAtIndex:5 withObject:[orderInfoDict objectForKey:@"house_unit"]];
    [self.firstCacheArray replaceObjectAtIndex:6 withObject:[orderInfoDict objectForKey:@"room_no"]];
    
    [self.secondCacheArray replaceObjectAtIndex:0 withObject:displayedPriceOfKey(@"rent_fee")];
    [self.secondCacheArray replaceObjectAtIndex:1 withObject:displayedPriceOfKey(@"foregift")];
    [self.secondCacheArray replaceObjectAtIndex:2 withObject:
     [NSString stringWithFormat:@"%d", [[orderInfoDict objectForKey:@"pay_month_num"] intValue] - 1]];
    [self.secondCacheArray replaceObjectAtIndex:3 withObject:displayedPriceOfKey(@"other_fee")];
    NSString *dateString = nil;
    dateExchange([[orderInfoDict objectForKey:@"rent_starttime"] doubleValue], dateString);
    [self.secondCacheArray replaceObjectAtIndex:4 withObject:dateString];
    
    [self.thirdCacheArray replaceObjectAtIndex:0 withObject:
     [NSString stringWithFormat:@"%d", [[orderInfoDict objectForKey:@"owner_type"] intValue] - 1]];
    [self.thirdCacheArray replaceObjectAtIndex:1 withObject:[orderInfoDict objectForKey:@"bank_membername"]];
    [self.thirdCacheArray replaceObjectAtIndex:2 withObject:[orderInfoDict objectForKey:@"bank_card_no"]];
    [self.thirdCacheArray replaceObjectAtIndex:3 withObject:
     self.bankNameArray[[self.bankIDArray indexOfObject:[orderInfoDict objectForKey:@"bank_id"]]]];
    [self.thirdCacheArray replaceObjectAtIndex:4 withObject:[orderInfoDict objectForKey:@"bank_address"]];
    [self.thirdCacheArray replaceObjectAtIndex:5 withObject:[orderInfoDict objectForKey:@"owner_phone"]];
    
    [self.forthCacheArray replaceObjectAtIndex:1 withObject:[orderInfoDict objectForKey:@"guest_name"]];
    [self.forthCacheArray replaceObjectAtIndex:2 withObject:[orderInfoDict objectForKey:@"guest_idcard"]];
    [self.forthCacheArray replaceObjectAtIndex:3 withObject:[orderInfoDict objectForKey:@"guest_phone"]];
}

@end
