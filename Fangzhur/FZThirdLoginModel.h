//
//  FZThirdLoginModel.h
//  Fangzhur
//
//  Created by --超-- on 14/11/5.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ThirdType) {
    ThirdTypeWeibo,
    ThirdTypeWeixin
};

typedef void(^LoginResult)(BOOL success);

@interface FZThirdLoginModel : NSObject

@property (nonatomic, copy) LoginResult block;

- (void)userLoginWithType:(ThirdType)type completed:(LoginResult)block;

@end
