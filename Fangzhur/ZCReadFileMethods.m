//
//  ZCReadFileMethods.m
//  Fangzhur
//
//  Created by --Chao-- on 14-5-30.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "ZCReadFileMethods.h"

//读文件操作
@implementation ZCReadFileMethods

+ (id)dataFromPlist:(NSString *)fileName ofType:(PlistDataType)type
{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    if (type == Array) {
        return [NSArray arrayWithContentsOfFile:path];
    }
    else {
        return [NSDictionary dictionaryWithContentsOfFile:path];
    }
}

+ (NSString *)getFilePathInDocuments:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths firstObject] stringByAppendingPathComponent:fileName];
    
    return filePath;
}

@end
