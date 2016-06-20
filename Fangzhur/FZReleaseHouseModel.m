//
//  FZReleaseHouseModel.m
//  Fangzhur
//
//  Created by --超-- on 14/11/30.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZReleaseHouseModel.h"

@interface FZReleaseHouseModel ()

@property (nonatomic, strong) NSDictionary *dataDict;

@end

@implementation FZReleaseHouseModel

- (instancetype)initWithReleaseType:(NSString *)releaseType houseType:(NSString *)houseType
{
    self = [super init];
    
    if (self) {
        self.cacheArray = [[NSMutableArray alloc] init];
        self.dataDict = [ZCReadFileMethods dataFromPlist:@"ReleaseHouseData" ofType:Dictionary];
        self.releaseType = releaseType;
        self.houseType = houseType;
        self.sectionTitles = [[self.dataDict objectForKey:releaseType] objectForKey:@"SectionTitle"];
        self.count = self.sectionTitles.count;
        if ([releaseType integerValue] == 1) {
            self.cacheArray = [[NSMutableArray alloc] initWithObjects:
                               @"选择", @"-", @"现在", @"0", @"1", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"", @"", @"", @"", @"", @"", @"选择", nil];
        }
        else {
            self.cacheArray = [[NSMutableArray alloc] initWithObjects:
                               @"选择", @"-", @"现在", @"0", @"1", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"", @"", @"", @"", @"", @"", @"", @"选择", nil];
        }
    }
    
    return self;
}

- (id)contentsOfSectionTitle:(NSString *)sectionTitle
{
    if ([sectionTitle isEqualToString:@"拎包入住"] ||
        [sectionTitle isEqualToString:@"地铁房"] ||
        [sectionTitle isEqualToString:@"可短租"] ||
        [sectionTitle isEqualToString:@"免税"] ||
        [sectionTitle isEqualToString:@"满五唯一"] ||
        [sectionTitle isEqualToString:@"不限购"] ||
        [sectionTitle isEqualToString:@"学区房"] ||
        [sectionTitle isEqualToString:@"朝向"] ||
        [sectionTitle isEqualToString:@"装修"] ||
        [sectionTitle isEqualToString:@"圈子"] ||
        [sectionTitle isEqualToString:@"配套设施"]) {
        
        return [[[[self.dataDict objectForKey:self.releaseType]
                  objectForKey:@"SectionItem"]
                 objectForKey:sectionTitle]
                objectForKey:@"ItemName"];
    }
    
    return [[[self.dataDict objectForKey:self.releaseType]
             objectForKey:@"SectionItem"]
            objectForKey:sectionTitle];
}

- (NSString *)cacheOfSection:(NSInteger)section
{
    return [self.cacheArray objectAtIndex:section];
}

- (NSString *)featureIDInSection:(NSInteger)section
{
    return [[[[[self.dataDict objectForKey:self.releaseType]
               objectForKey:@"SectionItem"]
              objectForKey:[self.sectionTitles objectAtIndex:section]]
             objectForKey:@"ItemID"] lastObject];
}

@end
