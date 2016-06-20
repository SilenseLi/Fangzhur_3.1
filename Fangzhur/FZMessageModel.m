//
//  FZMessageModel.m
//  Fangzhur
//
//  Created by --超-- on 14/12/19.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZMessageModel.h"

@implementation FZMessageModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{}

- (NSString *)stringByHidePhoneTail
{
    NSMutableString *tempString = [self.username mutableCopy];
    if (tempString.length == 11) {
        [tempString replaceCharactersInRange:NSMakeRange(7, 4) withString:@"****"];
    }
    return [tempString copy];
}

@end
