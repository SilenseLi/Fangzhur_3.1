//
//  FZHTTPRequest.h
//  AgentAPP
//
//  Created by --Chao-- on 14-5-4.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface NSFileManager (PathMethods)

//判断指定路径下的文件是否超时
+ (BOOL)isTimeOutWithPath:(NSString *)path timeInterval:(NSTimeInterval)interval;

@end

//__________________________________________
//________________________________________________


//用于网络请求, 带有缓存功能
@interface FZHTTPRequest : NSObject <ASIHTTPRequestDelegate>
{
    ASIHTTPRequest *_asiRequest;
    ASIFormDataRequest *_formDataRequest;
    
    NSString *_URLString;
    NSString *_contentType;
    NSMutableData *_downloadedData;
    NSTimeInterval _interval;
    BOOL _error;
}

@property (nonatomic, retain) ASIHTTPRequest *asiRequest;
@property (nonatomic, retain) ASIFormDataRequest *formDataRequest;
@property (nonatomic, assign)   int tag;
@property (nonatomic, copy)     NSString *URLString;
@property (nonatomic, copy)     NSString *contentType;
@property (nonatomic, assign)   NSTimeInterval interval;//缓存时长
@property (nonatomic, retain)   NSMutableData *downloadedData;//获取加载好的数据
@property (nonatomic, assign)   BOOL error;
@property (nonatomic, assign)   id target;
@property (nonatomic, assign)   SEL action;

/**
 * @brief 实例化对象，并设置缓存时间
 * @param URLString 请求地址
 */
- (id)initWithURLString:(NSString *)URLString cacheInterval:(NSTimeInterval)interval;
- (void)addTarget:(id)target action:(SEL)action;
/**
 * @brief GET 请求
 */
- (void)startGetRequest;
/**
 * @brief 根据请求体字符串发起网络请求
 * @param postString 请求体字符串
 */
- (void)startPostWithString:(NSString *)postString;
/**
 * @brief 根据参数对（字典），进行网络请求
 * @param paramDict 请求体参数字典
 */
- (void)startPostWithDictionary:(NSDictionary *)paramDict;
/**
 * @brief 上传图片
 */
- (void)startPostImageData:(NSData *)data withDictionary:(NSDictionary *)paramDict;
/**
 * @brief 手动取消请求
 */
- (void)cancelRequest;

@end
