//
//  FZScreenModel.h
//  Fangzhur
//
//  Created by --超-- on 14/11/10.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FZScreenModel : NSObject

/** 筛选类别 */
@property (nonatomic, strong) NSString *screenType;
@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, assign) NSInteger count;
/** 缓存筛选的数据 */
@property (nonatomic, strong) NSMutableArray *cacheArray;
//城区数组
@property (nonatomic, strong) NSArray *regionArray;
/** 选中的城区 */
@property (nonatomic, copy) NSString *selectedRegion;
@property (nonatomic, copy) NSString *selectedSubregion;

- (instancetype)initWithScreenType:(NSString *)screenType;

/** 获取对应section下的所有内容 */
- (NSArray *)contentsOfSection:(NSString *)sectionTitle;
/** 获取对应的section下的缓存数据 */
- (NSString *)cacheOfSection:(NSInteger)section;
/** 获取对应城区的商圈 */
- (NSArray *)subregionsOfRegion:(NSString *)regionName;


@end
