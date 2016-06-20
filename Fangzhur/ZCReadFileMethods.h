//
//  ZCReadFileMethods.h
//  Fangzhur
//
//  Created by --Chao-- on 14-5-30.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _DataType {
    Dictionary,
    Array
} PlistDataType;

@interface ZCReadFileMethods : NSObject
/**
 * @brief 从Plist文件中读取数据(字典、数组)
 */
+ (id)dataFromPlist:(NSString *)fileName ofType:(PlistDataType)type;

/**
 * @brief 根据文件名获取沙盒中文件路径
 */
+ (NSString *)getFilePathInDocuments:(NSString *)fileName;

@end
