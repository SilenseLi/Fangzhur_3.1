//
//  FZCommentModel.m
//  Fangzhur
//
//  Created by --超-- on 14/12/7.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZCommentModel.h"

@implementation FZCommentModel

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
