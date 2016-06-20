//
//  FZSearchHistoryModel.h
//  Fangzhur
//
//  Created by --超-- on 14/11/7.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FZSearchHistoryModel : NSObject

@property (nonatomic, retain) NSMutableArray *historyArray;

/** 增加新数据，如果有重复的，移除旧的一条 */
- (void)addHistory:(NSString *)history;

/** 讲记录存入数据库 */
- (void)storeInDatabase;

/** 从数据库读取最新的10条数据 */
- (NSArray *)newestHistoryFromDatabase;

@end
