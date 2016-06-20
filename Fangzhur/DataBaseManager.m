//
//  DataBaseManager.m
//  FMDB_Demo
//
//  Created by Junk_cheung on 14-3-25.
//  Copyright (c) 2014年 Junk_cheung. All rights reserved.
//

#import "DataBaseManager.h"

@interface DataBaseManager ()

@property (nonatomic, strong) FMDatabase *database;

@end

@implementation DataBaseManager

static DataBaseManager *manager = nil;

//==========以下操作是为了保证该类作为单例存在==========

//不知情的情况下，使用alloc创建对象
+ (id)allocWithZone:(struct _NSZone *)zone
{
    if (manager == nil) {
        manager = [super allocWithZone:zone];
        return manager;
    }
    
    return nil;
}

+ (id)alloc
{
    if (manager == nil) {
        manager = [super alloc];
        return manager;
    }
    
    return nil;
}


//=============================================

static dispatch_once_t predicate;
+ (DataBaseManager *)shareManager
{
    @synchronized (self) {
        dispatch_once(&predicate, ^{
            manager = [[self alloc] init];
        });
    
        return manager;
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/UserData.db"];
        self.database = [[FMDatabase alloc] initWithPath:path];
        
        //添加数据表
        [self.database open];
        
        //用户表
        //gender  0 男  1  女 -未知  |||||||    open_id 1.微博   2.微信  3网站
        if ([self.database executeUpdate:
             @"create table if not exists ThirdUserTable (UID text primary key, Token text, NickName text, Gender text, HeadImageURL text, OpenID text)"]) {
            NSLog(@"ThirdUserTable 创建成功!");
        }
        
        //搜索记录表
        if ([self.database executeUpdate:
             @"create table if not exists SearchHistoryTable (HistoryID integer primary key autoincrement, History text not null)"]) {
            NSLog(@"SearchHistoryTable 创建成功!");
        }
        
        if ([self.database executeUpdate:
            @"create table if not exists RegionTable (RegionID integer primary key, Name text not null, Latitude text, Longitude text, RegionTag integer, CityID integer)"]) {
            NSLog(@"RegionTable 创建成功");
        }
        
        if ([self.database executeUpdate:@"create table if not exists AttentionTable(houseID text not null, houseType text, userName text)"]) {
            NSLog(@"AttentionTable 创建成功");
        }
#if 0
        if ([self.database executeUpdate:@"create table if not exists UserTable (UserName text primary key, Token text, HeadImageURL text)"]) {
            NSLog(@"UserTable 创建成功!");
        }
#endif
        [self.database close];
    }

    
    return self;
}

- (BOOL)createTable:(NSString *)tableName withColumns:(NSString *)columns
{
    [self.database open];
    BOOL ret = [self.database executeUpdateWithFormat:@"create table if not exists '%@' ('%@')", tableName, columns];
    [self.database close];
    
    return ret;
}

#pragma mark - Add -

- (BOOL)addRegionWithDictionary:(NSDictionary *)dict regionTag:(NSNumber *)tag
{
    if ([self.database open] == NO) {
        NSLog(@"数据库打开失败!");
        return NO;
    }
    
    BOOL result = [self.database executeUpdate:
                   @"insert into RegionTable (RegionID, Name, Latitude, Longitude, RegionTag, CityID) values(?, ?, ?, ?, ?, ?)",
                   [dict objectForKey:@"id"],
                   [dict objectForKey:@"name"],
                   [dict objectForKey:@"lat"],
                   [dict objectForKey:@"lng"],
                   tag, FZUserInfoWithKey(Key_CityID)];
    [self.database close];
    
    if (!result) {
        NSLog(@"Error: failed to insert into: ThirdUserTable");
        return NO;
    }
    return YES;
}

- (BOOL)addUserWithDictionary:(NSDictionary *)dict
{
    if ([self.database open] == NO) {
        NSLog(@"数据库打开失败!");
        return NO;
    }

    BOOL result = [self.database executeUpdate:
                   @"insert into ThirdUserTable (UID, Token, NickName, Gender, HeadImageURL, OpenID) values(?, ?, ?, ?, ?, ?)",
                   [dict objectForKey:@"UID"],
                   [dict objectForKey:@"Token"],
                   [dict objectForKey:@"NickName"],
                   [dict objectForKey:@"Gender"],
                   [dict objectForKey:@"HeadImageURL"],
                   [dict objectForKey:@"OpenID"]];
    [self.database close];
    
    if (!result) {
        NSLog(@"Error: failed to insert into: ThirdUserTable");
        return NO;
    }
    return YES;
}

- (BOOL)addHistoriesFromArray:(NSArray *)historyArray
{
    if ([self.database open] == NO) {
        NSLog(@"数据库打开失败!");
        return NO;
    }
    
    for (NSString *history in historyArray) {
        BOOL result = [self.database executeUpdate:
                       @"insert into SearchHistoryTable (History) values(?)", history];
        if (!result) {
            NSLog(@"Error:%@ failed to insert into: SearchHistoryTable", history);
        }
    }
    
    [self.database close];
    return YES;
}

- (BOOL)addAttentionWithHouseID:(NSString *)houseID houseType:(NSString *)houseType userName:(NSString *)userName
{
    if ([self.database open] == NO) {
        NSLog(@"数据库打开失败!");
        return NO;
    }
    
    BOOL result = [self.database executeUpdate:@"insert into AttentionTable(houseID, houseType, userName) values(?, ?, ?)",
                   houseID, houseType, userName];
    if (!result) {
        NSLog(@"Error: failed to insert: ATTENTION");
        return NO;
    }
    
    [self.database close];
    return YES;
}

#pragma mark - Delete -

- (BOOL)deleteUserWithUID:(NSString *)UID
{
    BOOL result = [self.database open];
    if (result == NO) {
        NSLog(@"数据库打开失败");
        return NO;
    }
    
    result = [self.database executeUpdate:@"delete from ThirdUserTable where UID = ?", UID];
    [self.database close];
    
    if (result == NO) {
        NSLog(@"Error: Delete third user info failed!");
        return NO;
    }
    return YES;
}

- (BOOL)deleteAllHistory
{
    BOOL result = [self.database open];
    if (result == NO) {
        NSLog(@"数据库打开失败");
        return NO;
    }
    
    result = [self.database executeUpdate:@"delete from SearchHistoryTable"];
    [self.database close];
    
    if (result == NO) {
        NSLog(@"Error: Delete histories failed!");
        return NO;
    }
    return YES;
}

- (BOOL)cancelAttentionWithHouseID:(NSString *)houseID houseType:(NSString *)houseType userName:(NSString *)userName
{
    if (![self.database open]) {
        NSLog(@"数据库打开失败!");
        return NO;
    }
    
    BOOL result = [self.database executeUpdate:@"delete from AttentionTable where houseID = ? and userName = ? and houseType = ?", houseID, userName, houseType];
    if (!result) {
        NSLog(@"Error: failed to delete: %@", houseID);
        return NO;
    }
    
    [self.database close];
    return YES;
}

- (BOOL)cancelAllAttentionsOfUser:(NSString *)userName
{
    if (![self.database open]) {
        NSLog(@"数据库打开失败!");
        return NO;
    }
    
    BOOL result = [self.database executeUpdate:@"delete from AttentionTable where userName = ?", userName];
    if (!result) {\
        NSLog(@"Error: failed to delete");
        return NO;
    }
    
    [self.database close];
    return YES;
}

#pragma mark - Update -

- (BOOL)updateUserWithUID:(NSString *)UID updateDict:(NSDictionary *)updateDict
{
    if ([self.database open] == NO) {
        NSLog(@"数据库打开失败!");
        return NO;
    }
    
    BOOL result = [self.database executeUpdate:
                   @"update ThirdUserTable set Token = ?, NickName = ?, Gender = ?, HeadImageURL = ?, OpenID = ? where UID = ?",
                   [updateDict objectForKey:@"Token"],
                   [updateDict objectForKey:@"NickName"],
                   [updateDict objectForKey:@"Gender"],
                   [updateDict objectForKey:@"HeadImageURL"],
                   [updateDict objectForKey:@"OpenID"],
                   UID];
    [self.database close];
    
    if (!result) {
        NSLog(@"Error: failed to update table: ThirdUserTable");
        return NO;
    }
    return YES;
}

#pragma mark - Search -

- (BOOL)existsCityInfoOfCityID:(NSNumber *)cityID
{
    if (![self.database open]) {
        NSLog(@"数据库打开失败!");
        return NO;
    }
    
    FMResultSet *resultSet = [self.database executeQuery:@"select * from RegionTable where CityID = ?", cityID];
    if ([resultSet next]) {
        [resultSet close];
        [self.database close];
        return YES;
    }
    
    [self.database close];
    return NO;
}

- (NSDictionary *)cityRegion
{
    if (![self.database open]) {
        NSLog(@"数据库打开失败!");
        return nil;
    }
    
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    FMResultSet *resultSet = [self.database executeQuery:
                              @"select * from RegionTable where RegionTag = 0 and CityID = ?",
                              FZUserInfoWithKey(Key_CityID)];
    while ([resultSet next]) {
        [resultDict setObject:@([resultSet intForColumn:@"RegionID"]) forKey:[resultSet stringForColumn:@"Name"]];
    }
    
    [self.database close];
    return resultDict;
}

- (NSDictionary *)subregionsFromRegion:(NSString *)regionName
{
    if (![self.database open]) {
        NSLog(@"数据库打开失败!");
        return nil;
    }
    
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    FMResultSet *resultSet = [self.database executeQuery:
                              @"select * from RegionTable where Name = ? and CityID = ?",
                              regionName, FZUserInfoWithKey(Key_CityID)];
    
    if ([resultSet next]) {
        NSNumber *regionTag = [NSNumber numberWithInteger:[resultSet intForColumn:@"RegionID"]];
        resultSet = [self.database executeQuery:@"select * from RegionTable where RegionTag = ?", regionTag];
        
        while ([resultSet next]) {
            [resultDict setObject:@([resultSet intForColumn:@"RegionID"]) forKey:[resultSet stringForColumn:@"Name"]];
        }
    }
    
    [self.database close];
    return resultDict;
}

- (BOOL)existsUserWithUID:(NSString *)UID
{
    if (![self.database open]) {
        NSLog(@"数据库打开失败!");
        return NO;
    }

    FMResultSet *resultSet = [self.database executeQuery:@"select * from ThirdUserTable where UID = ?", UID];
    if ([resultSet next]) {
        [resultSet close];
        [self.database close];
        return YES;
    }
    
    [self.database close];
    return NO;
}

- (NSDictionary *)userInfoWithUID:(NSString *)UID
{
    BOOL result = [self.database open];
    if (result == NO) {
        NSLog(@"打开失败");
        return nil;
    }

    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    FMResultSet *resultSet = [self.database executeQuery:@"select * from ThirdUserTable"];
    
    while ([resultSet next]) {
        [resultDict setObject:[resultSet stringForColumnIndex:0] forKey:@"UID"];
        [resultDict setObject:[resultSet stringForColumnIndex:1] forKey:@"Token"];
        [resultDict setObject:[resultSet stringForColumnIndex:2] forKey:@"NickName"];
        [resultDict setObject:[resultSet stringForColumnIndex:3] forKey:@"Gender"];
        [resultDict setObject:[resultSet stringForColumnIndex:4] forKey:@"HeadImageURL"];
        [resultDict setObject:[resultSet stringForColumnIndex:5] forKey:@"OpenID"];
    }
    
    [self.database close];
    return resultDict;
}

- (NSArray *)historiesLatest:(NSInteger)number
{
    BOOL result = [self.database open];
    if (result == NO) {
        NSLog(@"打开失败");
        return nil;
    }
    
    NSMutableArray *resultArray = [NSMutableArray array];
    FMResultSet *resultSet = [self.database executeQuery:@"select * from SearchHistoryTable order by HistoryID asc"];
    
    int counter = 0;
    while ([resultSet next]) {
        if (counter == 10) {
            break;
        }
        [resultArray addObject:[resultSet stringForColumnIndex:1]];
        counter++;
    }
    
    [self.database close];
    return resultArray;
}

- (NSArray *)attentionsOfUser:(NSString *)userName houseType:(NSString *)houseType
{
    BOOL result = [self.database open];
    if (result == NO) {
        NSLog(@"打开失败");
        return nil;
    }
    
    NSMutableArray *resultArray = [NSMutableArray array];
    FMResultSet *resultSet = [self.database executeQuery:@"select * from AttentionTable where houseType = ? and userName = ?", houseType, userName];
    
    while ([resultSet next]) {
        [resultArray addObject:[resultSet stringForColumnIndex:0]];
    }
    
    [self.database close];
    return resultArray;
}

- (BOOL)isAttentionWithHouseID:(NSString *)houseID houseType:(NSString *)houseType userName:(NSString *)userName
{
    if (![self.database open]) {
        NSLog(@"数据库打开失败!");
        return NO;
    }
    
    if ([houseType isEqualToString:@"出租"]) {
        houseType = @"1";
    }
    if ([houseType isEqualToString:@"出售"]) {
        houseType = @"2";
    }
    
    FMResultSet *resultSet = [self.database executeQuery:@"select * from AttentionTable where houseID = ? and userName = ? and houseType = ?", houseID, userName, houseType];
    if ([resultSet next]) {
        [resultSet close];
        [self.database close];
        return YES;
    }
    return NO;
}



//
//- (BOOL)addTelephone:(NSString *)tel name:(NSString *)name houseID:(NSUInteger)houseID;
//{
//    if ([_dataBase open] == NO) {
//        NSLog(@"数据库打开失败!");
//        return NO;
//    }
//    
//    BOOL result = [_dataBase executeUpdate:@"insert into Telephone values(?, ?, ?)", [NSNumber numberWithInt:houseID], tel, name];
//    if (!result) {
//        NSLog(@"Error: failed to insert: Telephone");
//        return NO;
//    }
//    
//    [_dataBase close];
//    return YES;
//}
//


//
//- (NSString *)getTelephoneWithHouseID:(NSUInteger)houseID
//{
//    if (![_dataBase open]) {
//        NSLog(@"数据库打开失败!");
//        return NO;
//    }
//    
//    FMResultSet *resultSet = [_dataBase executeQuery:@"select * from Telephone where houseID=?", [NSNumber numberWithInt:houseID]];
//    if ([resultSet next]) {
//        [resultSet close];
//        [_dataBase close];
//        return [NSString stringWithFormat:@"%@\n%@", [resultSet stringForColumnIndex:1], [resultSet stringForColumnIndex:2]];
//    }
//    
//    return nil;
//}

////获取表中的数据
//- (NSArray *)getUsersInfo
//{
//    BOOL ret = [_dataBase open];
//    if (ret == NO) {
//        NSLog(@"打开失败");
//        return nil;
//    }
//    
//    FMResultSet *set = [_dataBase executeQuery:@"select * from USER"];
//    NSMutableArray *usersArray = [[[NSMutableArray alloc] init] autorelease];
//    
//    while ([set next]) {
//        UserModel *model = [[UserModel alloc] init];
//        model.userName = [set stringForColumnIndex:0];
//        model.school = [set stringForColumnIndex:1];
//        model.kungFu = [set stringForColumnIndex:2];
//        
//        [usersArray addObject:model];
//        [model release];
//    }
//    [_dataBase close];
//    
//    return usersArray;
//}

//删除表中的数据
//- (void)deleteUser:(NSString *)userName
//{
//    BOOL ret = [_dataBase open];
//    if (ret == NO) {
//        NSLog(@"数据库打开失败");
//        return;
//    }
//    
//    ret = [_dataBase executeUpdate:@"delete from USER where name=?", userName];
//    if (ret == NO) {
//        NSLog(@"删除用户失败");
//    }
//    
//    [_dataBase close];
//}

@end
