//
//  ContentManager.m
//  SOSimpleChatDemo
//
// Created by : arturdev
// Copyright (c) 2014 SocialObjects Software. All rights reserved.
//

#import "ContentManager.h"
#import "Message.h"
#import "SOMessageType.h"

@implementation ContentManager

+ (ContentManager *)sharedManager
{
    static ContentManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

- (NSArray *)generateConversationWithChatArray:(NSArray *)chatArray
{
    NSMutableArray *result = [NSMutableArray new];
    for (NSDictionary *msg in chatArray) {
        Message *message = [[Message alloc] init];
        message.fromMe = [msg[@"fromMe"] boolValue];
        message.text = msg[@"message"];
        message.type = [self messageTypeFromString:msg[@"type"]];
        message.date = [NSDate dateWithTimeIntervalSince1970:[msg[@"date"] doubleValue]];
        message.username = msg[@"username"];
        message.sender_id = msg[@"sender_id"];
        
//        int index = (int)[data indexOfObject:msg];
//        if (index > 0) {
//            Message *prevMesage = result.lastObject;
//            message.date = [NSDate dateWithTimeInterval:((index % 2) ? 2 * 24 * 60 * 60 : 120) sinceDate:prevMesage.date];
//        }
        
        if (message.type == SOMessageTypePhoto) {
            message.media = UIImageJPEGRepresentation([UIImage imageNamed:msg[@"image"]], 1);
        } else if (message.type == SOMessageTypeVideo) {
            message.media = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:msg[@"video"] ofType:@"mp4"]];
            message.thumbnail = [UIImage imageNamed:msg[@"thumbnail"]];
        }

        [result addObject:message];
    }
    
    return result;
}

- (SOMessageType)messageTypeFromString:(NSString *)string
{
    if ([string isEqualToString:@"SOMessageTypeText"]) {
        return SOMessageTypeText;
    } else if ([string isEqualToString:@"SOMessageTypePhoto"]) {
        return SOMessageTypePhoto;
    } else if ([string isEqualToString:@"SOMessageTypeVideo"]) {
        return SOMessageTypeVideo;
    }

    return SOMessageTypeOther;
}

@end
