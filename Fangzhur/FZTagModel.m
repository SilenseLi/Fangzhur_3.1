//
//  FZTagModel.m
//  Fangzhur
//
//  Created by --超-- on 14/11/18.
//  Copyright (c) 2014年 Zc. All rights reserved.
//
// 标签规则：私人定制  特价房  选择标签  剩余标签

#import "FZTagModel.h"

@implementation FZTagModel

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.imageNames = [[NSMutableArray alloc] initWithArray:
                           [ZCReadFileMethods dataFromPlist:@"TagImageList" ofType:Array]];
        
        NSArray *selectedTags = FZUserInfoWithKey(Key_Tag);
        NSArray *allTags = [[[EGOCache globalCache] plistForKey:Key_Tag] objectForKey:@"data"];
        
        self.tagArray = [[NSMutableArray alloc] init];
        [self.tagArray addObject:@"0"];
        [self.tagArray addObject:@"私人订制"];
        [self.tagArray addObject:@"253743"];
        [self.tagArray addObject:@"特价房"];
        
        if (!selectedTags) {
            for (NSDictionary *tagDict in allTags) {
                [self.tagArray addObject:[tagDict objectForKey:@"id"]];
                [self.tagArray addObject:[tagDict objectForKey:@"name"]];
            }
        }
        else {
            [self.tagArray addObjectsFromArray:selectedTags];
            
            for (NSDictionary *tagDict in allTags) {
                if ([self.tagArray indexOfObject:[tagDict objectForKey:@"name"]] == NSNotFound) {
                    [self.tagArray addObject:[tagDict objectForKey:@"id"]];
                    [self.tagArray addObject:[tagDict objectForKey:@"name"]];
                }
            }
        }
    }
    
    return self;
}

@end
