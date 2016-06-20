//
//  FZReleaseHouseModel.h
//  Fangzhur
//
//  Created by --超-- on 14/11/30.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FZReleaseHouseModel : NSObject

@property (nonatomic, strong) NSArray *sectionTitles;
// 为了记录发布房源时选择或输入的数据
@property (nonatomic, strong) NSMutableArray *cacheArray;
// 1 出租 2 出售
@property (nonatomic, strong) NSString *releaseType;
// 住宅 公寓 写字楼
@property (nonatomic, strong) NSString *houseType;
@property (nonatomic, assign) NSInteger count;

- (instancetype)initWithReleaseType:(NSString *)releaseType houseType:(NSString *)houseType;

/** 获取对应section title 下的所有内容 */
- (id)contentsOfSectionTitle:(NSString *)sectionTitle;
/** 获取对应的房源特色id */
- (NSString *)featureIDInSection:(NSInteger)section;
/** 获取对应的section下的缓存数据 */
- (NSString *)cacheOfSection:(NSInteger)section;

@end
