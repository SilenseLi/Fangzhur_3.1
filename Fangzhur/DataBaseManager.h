//
//  DataBaseManager.h
//  FMDB_Demo
//
//  Created by Junk_cheung on 14-3-25.
//  Copyright (c) 2014年 Junk_cheung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

//数据库管理中心
@interface DataBaseManager : NSObject

+ (DataBaseManager *)shareManager;

/**
 * @brief 创建数据库表
 * @param tableName 表名称
 * @param columns 字段格式为 字段名称 参数 参数...
 */
- (BOOL)createTable:(NSString *)tableName withColumns:(NSString *)columns;

//=========增==========

/** 
 * @brief 添加城区数据
 * @param dict (id, lat, lng, name)
 * @param tag 1区域 2商圈
 */
- (BOOL)addRegionWithDictionary:(NSDictionary *)dict regionTag:(NSNumber *)tag;

/** 
 * @brief 添加用户, 字典的key必须可表对应的字段名称相同
 * @prarm dict (UID text primary key, Token text, NickName text, Gender text, HeadImageURL text, OpenID text)
 */
- (BOOL)addUserWithDictionary:(NSDictionary *)dict;

/**
 * @brief 添加搜索的历史记录
 */
- (BOOL)addHistoriesFromArray:(NSArray *)historyArray;

//增加新关注
- (BOOL)addAttentionWithHouseID:(NSString *)houseID houseType:(NSString *)houseType userName:(NSString *)userName;

//=========删==========

/** 删除指定UID的第三方用户 */
- (BOOL)deleteUserWithUID:(NSString *)UID;

/** 清空搜索历史记录 */
- (BOOL)deleteAllHistory;

//取消关注
- (BOOL)cancelAttentionWithHouseID:(NSString *)houseID houseType:(NSString *)houseType userName:(NSString *)userName;
- (BOOL)cancelAllAttentionsOfUser:(NSString *)userName;

//=========改==========

/** 
 @brief 修改指定UID的用户
 @param updateDict (UID text primary key, Token text, NickName text, Gender text, HeadImageURL text, OpenID text)*/
- (BOOL)updateUserWithUID:(NSString *)UID updateDict:(NSDictionary *)updateDict;

//=========查==========

/** 查询指定UID的账号信息 */
- (BOOL)existsUserWithUID:(NSString *)UID;
/** 查询是否存在城区信息 */
- (BOOL)existsCityInfoOfCityID:(NSNumber *)cityID;

/** 查询最新的 number 条搜索历史 */
- (NSArray *)historiesLatest:(NSInteger)number;

/** 
 * @brief 查询所在城市的城区
 * @return (name, id) */
- (NSDictionary *)cityRegion;
/** 
 * @brief 查询所在城区的商圈
 * @return (name, id) */
- (NSDictionary *)subregionsFromRegion:(NSString *)regionName;

//查看是否已关注
- (BOOL)isAttentionWithHouseID:(NSString *)houseID houseType:(NSString *)houseType userName:(NSString *)userName;
- (NSArray *)attentionsOfUser:(NSString *)userName houseType:(NSString *)houseType;


//- (NSDictionary *)userInfoWithUID:(NSString *)UID;
//
////增加新的房主电话
//- (BOOL)addTelephone:(NSString *)tel name:(NSString *)name houseID:(NSUInteger)houseID;
////查询房主电话
//- (NSString *)getTelephoneWithHouseID:(NSUInteger)houseID;
////删除用户本地存储信息
//- (void)deleteUser:(NSString *)userName;

@end
