//
//  FZScreenModel.m
//  Fangzhur
//
//  Created by --超-- on 14/11/10.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZScreenModel.h"
#import "DataBaseManager.h"

@interface FZScreenModel ()

@property (nonatomic, strong) NSDictionary *dataDict;

@end

@implementation FZScreenModel

- (instancetype)initWithScreenType:(NSString *)screenType
{
    self = [super init];
    
    if (self) {
        if ([screenType isEqualToString:@"出租"]) {
            screenType = @"1";
        }
        else if ([screenType isEqualToString:@"出售"]) {
            screenType = @"2";
        }
        
        self.dataDict = [ZCReadFileMethods dataFromPlist:@"ScreenListData" ofType:Dictionary];
        self.screenType = screenType;
        self.count = self.sectionTitles.count;
        if ([screenType integerValue] == 1) {
            self.cacheArray = [[NSMutableArray alloc] initWithObjects:
                               @"0", @"0", @"0", @"0", @"0", @"0,500", @"0,10000", @"0", @"0", @"0", @"0", @"随时", nil];
        }
        else {
            self.cacheArray = [[NSMutableArray alloc] initWithObjects:
                               @"0", @"0", @"0", @"0", @"0", @"0,500", @"0,10000000", @"0", @"0", @"0", @"0", @"随时", nil];
        }

    }
    
    return self;
}

- (void)setScreenType:(NSString *)screenType
{
    if ([screenType isEqualToString:@"出租"]) {
        screenType = @"1";
    }
    else if ([screenType isEqualToString:@"出售"]) {
        screenType = @"2";
    }
    
    _screenType = screenType;
    self.sectionTitles = [[self.dataDict objectForKey:screenType] objectForKey:@"SectionTitle"];
}


- (NSArray *)contentsOfSection:(NSString *)sectionTitle
{
    if ([sectionTitle hasPrefix:@"价格"] || [sectionTitle hasPrefix:@"面积"]) {
        return [[[[self.dataDict objectForKey:self.screenType]
                  objectForKey:@"SectionItem"]
                 objectForKey:sectionTitle]
                componentsSeparatedByString:@","];
    }
    else if ([sectionTitle isEqualToString:@"城区"]) {
        NSMutableArray *resultArray = [NSMutableArray array];
        [resultArray addObject:@"不限"];
        [resultArray addObjectsFromArray:[FZUserInfoWithKey(key_CityRegion) allKeys]];
        
        return resultArray;
    }
    else if ([sectionTitle isEqualToString:@"商圈"]) {
        NSMutableArray *resultArray = [NSMutableArray array];
        [resultArray addObject:@"不限"];
        [resultArray addObjectsFromArray:[FZUserInfoWithKey(key_CityRegion) objectForKey:self.selectedRegion]];
        
        return resultArray;
    }
    else if ([sectionTitle isEqualToString:@"地铁"]) {
        NSMutableArray *resultArrray = [NSMutableArray array];
        [resultArrray addObject:@"不限"];
        for (NSDictionary *lineDict in FZUserInfoWithKey(Key_Subway)) {
            [resultArrray addObject:[lineDict objectForKey:@"line_name"]];
        }
         
        return resultArrray;
    }
    
    return [[[[self.dataDict objectForKey:self.screenType]
              objectForKey:@"SectionItem"]
             objectForKey:sectionTitle]
            objectForKey:@"ItemName"];
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

- (NSArray *)subregionsOfRegion:(NSString *)regionName
{
    return [[DataBaseManager shareManager] subregionsFromRegion:regionName].allKeys;
}

@end
