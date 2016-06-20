//
//  FZThirdLoginModel.m
//  Fangzhur
//
//  Created by --超-- on 14/11/5.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZThirdLoginModel.h"
#import "DataBaseManager.h"
#import <ShareSDK/ShareSDK.h>
#import <AFNetworking.h>
#import <JDStatusBarNotification.h>
#import "ProgressHUD.h"

@interface FZThirdLoginModel ()

@property (nonatomic, strong) NSMutableDictionary *userInfoDict;

@end

@implementation FZThirdLoginModel

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.userInfoDict = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)userLoginWithType:(ThirdType)type completed:(LoginResult)block
{
    self.block = block;
    
    if (type == ThirdTypeWeibo) {
        [ProgressHUD show:@"登录中，请稍后..." Interaction:NO];
        [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
            if (result == NO) {
                block(NO);
                return ;
            }
            
            NSDictionary *tempDict = [userInfo sourceData];
            NSLog(@"Sina\n%@", tempDict);
            [self.userInfoDict setObject:[tempDict objectForKey:@"avatar_hd"] forKey:@"HeadImageURL"];
            [self.userInfoDict setObject:@"1" forKey:@"OpenID"];
            [self.userInfoDict setObject:[tempDict objectForKey:@"name"] forKey:@"NickName"];
            if ([[tempDict objectForKey:@"gender"] isEqualToString:@"m"]) {
                [self.userInfoDict setObject:@"0" forKey:@"Gender"];
            }
            else {
                [self.userInfoDict setObject:@"1" forKey:@"Gender"];
            }
            
            //成功登录后，判断该用户的ID是否在自己的数据库中。
            //如果有直接登录，没有就将该用户的ID和相关资料在数据库中创建新用户。
            [self credentialWithType:ShareTypeSinaWeibo];
        }];
    }
    else {
        [ProgressHUD show:@"登录中，请稍后..." Interaction:NO];
        [ShareSDK getUserInfoWithType:ShareTypeWeixiSession authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
            if (result == NO) {
                block(NO);
                return ;
            }
            
            NSDictionary *tempDict = [userInfo sourceData];
            NSLog(@"Weixin\n%@", tempDict);
            
            [self.userInfoDict setObject:[tempDict objectForKey:@"headimgurl"] forKey:@"HeadImageURL"];
            [self.userInfoDict setObject:@"2" forKey:@"OpenID"];
            [self.userInfoDict setObject:[tempDict objectForKey:@"nickname"] forKey:@"NickName"];
            if ([[tempDict objectForKey:@"sex"] integerValue] == 1) {
                [self.userInfoDict setObject:@"0" forKey:@"Gender"];
            }
            else {
                [self.userInfoDict setObject:@"1" forKey:@"Gender"];
            }
            [self credentialWithType:ShareTypeWeixiSession];
        }];
    }
}

- (void)credentialWithType:(ShareType)type
{
    //授权信息，包括授权ID、授权有效期等。
    //此处可以在用户进入应用的时候直接调用，如授权信息不为空且不过期可帮用户自动实现登录。
    id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:type];
    [self.userInfoDict setObject:[credential uid] forKey:@"UID"];
    [self.userInfoDict setObject:[credential token] forKey:@"Token"];
    
    if (![[DataBaseManager shareManager] addUserWithDictionary:self.userInfoDict]) {
        NSLog(@"写入用户数据失败");
    }
    
    [[FZRequestManager manager] sendThirdLoginInfo:self.userInfoDict complete:^(BOOL success, NSDictionary *userInfo) {
        if (!success) {
            self.block(NO);
        }
        else {
            self.block(YES);
        }
    }];
}

@end
