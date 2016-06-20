//
//  FZSearchHistoryModel.m
//  Fangzhur
//
//  Created by --超-- on 14/11/7.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZSearchHistoryModel.h"
#import "DataBaseManager.h"

#define MAX_NUMBER 20

@implementation FZSearchHistoryModel

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.historyArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)addHistory:(NSString *)history
{
    if ([self.historyArray containsObject:history]) {
        [self.historyArray removeObject:history];
    }
    
    if (self.historyArray.count == MAX_NUMBER) {
        [self.historyArray removeObjectAtIndex:MAX_NUMBER - 1];
    }
    
    [self.historyArray insertObject:history atIndex:0];
}

- (void)storeInDatabase
{
    [[DataBaseManager shareManager] deleteAllHistory];
    [[DataBaseManager shareManager] addHistoriesFromArray:self.historyArray];
}

- (NSArray *)newestHistoryFromDatabase
{
    [self.historyArray addObjectsFromArray:[[DataBaseManager shareManager] historiesLatest:MAX_NUMBER]];
    return self.historyArray;
}


@end
