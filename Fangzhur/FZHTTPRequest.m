//
//  FZHTTPRequest.m
//  AgentAPP
//
//  Created by --Chao-- on 14-5-4.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZHTTPRequest.h"
#import "NSString+Hashing.h"

@implementation NSFileManager (PathMethods)

+ (BOOL)isTimeOutWithPath:(NSString *)path timeInterval:(NSTimeInterval)interval
{
    NSDictionary *attributesDict    = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    NSDate *creatTime               = [attributesDict objectForKey:NSFileCreationDate];
    NSDate *currentTime             = [NSDate date];
    NSTimeInterval existedInterval  = [currentTime timeIntervalSinceDate:creatTime];
    
    if (existedInterval > interval) {
        return YES;
    }
    
    return NO;
}

@end

//__________________________________________
//__________________________________________

@interface FZHTTPRequest ()

+ (NSString *)filePathWithName:(NSString *)fileName;

@end

@implementation FZHTTPRequest

- (void)dealloc
{
    if (_asiRequest) {
        [_asiRequest clearDelegatesAndCancel];
        [_asiRequest release];
    }
    if (_formDataRequest) {
        [_formDataRequest clearDelegatesAndCancel];
        [_formDataRequest release];
    }
    
    [_URLString release];
    [_contentType release];
    [_downloadedData release];
    self.target = nil;
    
    [super dealloc];
}

- (id)initWithURLString:(NSString *)URLString cacheInterval:(NSTimeInterval)interval
{
    self = [super init];
    if (self) {
        self.URLString      = URLString;
        self.contentType    = @"Application/x-www-form-urlencoded";
        _downloadedData     = [[NSMutableData alloc] init];
        self.interval       = interval;
    }
    
    return self;
}

- (void)addTarget:(id)target action:(SEL)action
{
    self.target = target;
    self.action = action;
}

+ (NSString *)filePathWithName:(NSString *)fileName
{
    return [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", [fileName MD5Hash]];
}

//在视图跳转的时候要取消代理，并且释放请求
- (void)cancelRequest
{
    if (_asiRequest) {
        [_asiRequest clearDelegatesAndCancel];
        _asiRequest.delegate = nil;
        self.asiRequest      = nil;
    }
    else {
        [_formDataRequest clearDelegatesAndCancel];
        _formDataRequest.delegate = nil;
        self.formDataRequest      = nil;
    }
}

//获取系统时间
- (NSString *)dateString
{
    NSString* date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd%hh:mm:ss"];
    date = [formatter stringFromDate:[NSDate date]];
    return date;
}

#pragma mark - 发起请求 -

- (void)startGetRequest
{
    [self cancelRequest];
    
    _asiRequest          = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:_URLString]];
    _asiRequest.delegate = self;
    
    //获取文件路径
    NSString *path             = [FZHTTPRequest filePathWithName:_URLString];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //如果文件存在，没有超出缓存时间，存文件中取出数据
    if ([fileManager fileExistsAtPath:path] && ![NSFileManager isTimeOutWithPath:path timeInterval:_interval]) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        [self.downloadedData setLength:0];
        [self.downloadedData appendData:data];
        if ([self.target respondsToSelector:self.action]) {
            [self.target performSelector:self.action withObject:self];
        }
    }
    else {
        [_asiRequest startAsynchronous];
    }
}

- (void)startPostWithString:(NSString *)postString
{
    if (_asiRequest) {
        [self cancelRequest];
    }
    
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    
    _asiRequest               = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:_URLString]];
    _asiRequest.requestMethod = @"POST";
    [_asiRequest addRequestHeader:@"Content-Type" value:_contentType];
    [_asiRequest addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%u", postData.length]];
    [_asiRequest setPostBody:[NSMutableData dataWithData:postData]];
    _asiRequest.tag      = self.tag;
    _asiRequest.delegate = self;
    
    //获取文件路径
    NSString *path             = [FZHTTPRequest filePathWithName:_URLString];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //如果文件存在，没有超出缓存时间，存文件中取出数据
    if ([fileManager fileExistsAtPath:path] && ![NSFileManager isTimeOutWithPath:path timeInterval:_interval]) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        [self.downloadedData setLength:0];
        [self.downloadedData appendData:data];
        if ([self.target respondsToSelector:self.action]) {
            [self.target performSelector:self.action withObject:self];
        }
    }
    else {
        [_asiRequest startAsynchronous];
    }
}

- (void)startPostWithDictionary:(NSDictionary *)paramDict
{
    if (_formDataRequest) {
        [self cancelRequest];
    }
    
    _formDataRequest            = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:_URLString]];
    _formDataRequest.postFormat = ASIMultipartFormDataPostFormat;
    _formDataRequest.tag        = self.tag;
    _formDataRequest.delegate   = self;
    
    NSMutableString *paramString = [NSMutableString string];
    for (NSString *key in paramDict) {
        [paramString appendString:[paramDict objectForKey:key]];
    }
    //获取文件路径
    NSString *path             = [FZHTTPRequest filePathWithName:[paramString MD5Hash]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //如果文件存在，没有超出缓存时间，存文件中取出数据
    if ([fileManager fileExistsAtPath:path] && ![NSFileManager isTimeOutWithPath:path timeInterval:_interval]) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        [self.downloadedData setLength:0];
        [self.downloadedData appendData:data];
        if ([self.target respondsToSelector:self.action]) {
            [self.target performSelector:self.action withObject:self];
        }
    }
    else {
        for (NSString *key in paramDict) {
            [_formDataRequest setPostValue:[paramDict objectForKey:key] forKey:key];
        }
        [_formDataRequest startAsynchronous];
    }
}

- (void)startPostImageData:(NSData *)data withDictionary:(NSDictionary *)paramDict
{
    if (_formDataRequest) {
        [self cancelRequest];
    }
    
    _formDataRequest            = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:_URLString]];
    _formDataRequest.postFormat = ASIMultipartFormDataPostFormat;
    _formDataRequest.tag        = self.tag;
    _formDataRequest.delegate   = self;
    NSString *photoName         = [NSString stringWithFormat:@"%@.jpg",[self dateString]];
    
    //获取文件路径
    NSString *path             = [FZHTTPRequest filePathWithName:_URLString];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //如果文件存在，没有超出缓存时间，存文件中取出数据
    if ([fileManager fileExistsAtPath:path] && ![NSFileManager isTimeOutWithPath:path timeInterval:_interval]) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        [self.downloadedData setLength:0];
        [self.downloadedData appendData:data];
        if ([self.target respondsToSelector:self.action]) {
            [self.target performSelector:self.action withObject:self];
        }
    }
    else {
        [_formDataRequest addData:data withFileName:photoName andContentType:@"image/jpeg/jpg/gif/bmp/png" forKey:@"uploadfile"];
        for (NSString *key in paramDict) {
            [_formDataRequest setPostValue:[paramDict objectForKey:key] forKey:key];
        }
        [_formDataRequest startAsynchronous];
    }
}

#pragma mark - ASIHTTPRequest delegate -

- (void)requestFinished:(ASIHTTPRequest *)request
{
    _error = NO;
    
    NSString *path = [FZHTTPRequest filePathWithName:_URLString];
    [request.responseData writeToFile:path atomically:YES];
    [_downloadedData appendData:request.responseData];
    
    if ([_target respondsToSelector:_action]) {
        [_target performSelector:_action withObject:self];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    _error = YES;
    NSLog(@"%@", request.responseString);
    
    if ([_target respondsToSelector:_action]) {
        [_target performSelector:_action withObject:self];
    }
}

@end
