//
//  FZRequest.m
//  Fangzhur
//
//  Created by --超-- on 14/11/6.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZRequestManager.h"
#import <JDStatusBarNotification.h>
#import "DataBaseManager.h"
#import "JCheckPhoneNumber.h"

#define kScreenItemID(itemName, index)\
[[[sectionItemDict objectForKey:itemName] objectForKey:@"ItemID"] objectAtIndex:[[cacheArray objectAtIndex:index] integerValue]]

@interface FZRequestManager ()

@end

@implementation FZRequestManager

+ (FZRequestManager *)manager
{
    FZRequestManager *manager = [[self alloc] init];
    if (manager) {
        manager.requestManager = [AFHTTPRequestOperationManager manager];
    }
    
    return manager;
}

- (void)cancelAllOperations
{
    [self.requestManager.operationQueue cancelAllOperations];
}

- (void)loginWithUserName:(NSString *)userName password:(NSString *)password status:(NSString *)status helpCode:(NSString *)helpCode complete:(void (^)(BOOL, id))responseBlock
{
    if (helpCode && ![JCheckPhoneNumber isMobileNumber:helpCode]) {
        helpCode = @"空";
    }
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"easy_login", @"action",
                               userName, @"username",
                               password, @"passwd",
                               status, @"status",
                               helpCode, @"unvite_name", nil];
    [self.requestManager POST:URLStringByAppending(kLogin)
                   parameters:parameters
                      success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Login info: \n%@", responseObject);
         
         if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {//登录成功
             FZUserInfoReset;
             [JDStatusBarNotification showWithStatus:@"恭喜您，登录成功" dismissAfter:2 styleName:JDStatusBarStyleDark];
             responseBlock(YES, [responseObject objectForKey:@"data"]);
         }
         else {
             [JDStatusBarNotification showWithStatus:[responseObject objectForKey:@"msg"] dismissAfter:2 styleName:JDStatusBarStyleError];
             responseBlock(NO, nil);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         FZNetworkingError(@"Login Error");
         
         [JDStatusBarNotification dismiss];
         responseBlock(NO, nil);
     }];
}

- (void)sendThirdLoginInfo:(NSDictionary *)loginInfo complete:(void (^)(BOOL, NSDictionary *))responseBlock
{
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"third_login", @"action",
                               [loginInfo objectForKey:@"UID"], @"third_uid",
                               [loginInfo objectForKey:@"NickName"], @"realname",
                               [loginInfo objectForKey:@"Gender"], @"gender",
                               [loginInfo objectForKey:@"OpenID"], @"open_id", nil];
    [self.requestManager POST:URLStringByAppending(kLogin) parameters:paramDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"easy_login\n%@", responseObject);
        
        if ([[responseObject objectForKey:@"sucess"] intValue] == 1) {
            NSLog(@"第三方用户信息发送成功");
            
            [JDStatusBarNotification showWithStatus:@"登录成功" dismissAfter:2];
            responseBlock(YES, [responseObject objectForKey:@"data"]);
            
            NSDictionary *dataDict = [responseObject objectForKey:@"data"];
            [[NSUserDefaults standardUserDefaults] setObject:[dataDict objectForKey:@"memberid"] forKey:Key_MemberID];
            [[NSUserDefaults standardUserDefaults] setObject:[dataDict objectForKey:@"token"] forKey:Key_LoginToken];
            [[NSUserDefaults standardUserDefaults] setObject:[dataDict objectForKey:@"role_type"] forKey:Key_RoleType];
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:Key_UserCash];
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:Key_UserCredits];
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:Key_UserTickets];
            [[NSUserDefaults standardUserDefaults] setObject:@"Unbind" forKey:Key_BindingTag];
            [[NSUserDefaults standardUserDefaults] setObject:[loginInfo objectForKey:@"NickName"] forKey:Key_UserName];
            [[NSUserDefaults standardUserDefaults] setObject:[loginInfo objectForKey:@"HeadImageURL"] forKey:Key_HeadImage];
        }
        else {
            responseBlock(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        FZNetworkingError(@"Third Login Error");
    }];
}

- (void)getRegionInfo
{
    [self.requestManager GET:URLStringByAppending(kAreaList) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *regionDict = [NSMutableDictionary dictionary];
        
        for (NSDictionary *quyuDict in [responseObject objectForKey:@"quyu"]) {
            NSNumber *quyuID = [quyuDict objectForKey:@"id"];
            NSMutableArray *regionArray = [NSMutableArray array];
            
            for (NSDictionary *shangquanDict in [[responseObject objectForKey:@"shangquan"] objectForKey:quyuID]) {
                [regionArray addObject:[shangquanDict objectForKey:@"name"]];
            }
            
            [regionDict setObject:regionArray forKey:[quyuDict objectForKey:@"name"]];
        }
        [[NSUserDefaults standardUserDefaults] setObject:regionDict forKey:key_CityRegion];
        
        if (![[DataBaseManager shareManager] existsCityInfoOfCityID:FZUserInfoWithKey(Key_CityID)]) {
            for (NSDictionary *dict in [responseObject objectForKey:@"quyu"]) {
                [[DataBaseManager shareManager] addRegionWithDictionary:dict regionTag:@(0)];
            }
            
            for (NSNumber *regionTag in [responseObject objectForKey:@"shangquan"]) {
                for (NSDictionary *dict in [[responseObject objectForKey:@"shangquan"] objectForKey:regionTag]) {
                    [[DataBaseManager shareManager] addRegionWithDictionary:dict regionTag:regionTag];
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        FZNetworkingError(@"Get region info");
    }];
}

- (void)getSubwayInfo
{
    [self.requestManager GET:URLStringByAppending(kSubwayList) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:@"line"] forKey:Key_Subway];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        FZNetworkingError(@"Get region info");
    }];
}

- (void)getUserInfoComplete:(void (^)(BOOL, id))responseBlock
{
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               FZUserInfoWithKey(Key_UserName), @"username",
                               FZUserInfoWithKey(Key_LoginToken), @"token", nil];
    [self.requestManager POST:URLStringByAppending(kUserInfo) parameters:paramDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"\nGet user info \n%@", responseObject);
        
        //登录信息失效
        if ([responseObject objectForKey:@"token"] && FZUserInfoWithKey(Key_LoginToken)) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"登录信息失效，请重新登录！否则部分功能将无法正常使用。" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alertView show];
    
            FZUserInfoReset;
            if (responseBlock) {
                responseBlock(NO, responseObject);
            }
            
            return ;
        }
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *memberDict = [responseObject objectForKey:@"member"];
        [userDefaults setObject:[memberDict objectForKey:@"id"] forKey:Key_MemberID];
        if ([memberDict objectForKey:@"avatar"]) {
            [userDefaults setObject:[memberDict objectForKey:@"avatar"] forKey:Key_HeadImage];
        }
        [userDefaults setObject:[memberDict objectForKey:@"role_type"] forKey:Key_RoleType];
        [userDefaults setObject:[memberDict objectForKey:@"gender"] forKey:Key_Gender];
        [userDefaults setObject:[memberDict objectForKey:@"house_money"] forKey:Key_UserCash];
        [userDefaults setObject:[memberDict objectForKey:@"scores"] forKey:Key_UserCredits];
        [userDefaults setObject:[memberDict objectForKey:@"money"] forKey:Key_UserTickets];
        
        //存入本地数据库
        NSDictionary *tempDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [userDefaults objectForKey:Key_MemberID], @"UID",
                                  [userDefaults objectForKey:Key_LoginToken], @"Token",
                                  [userDefaults objectForKey:Key_UserName], @"NickName",
                                  [userDefaults objectForKey:Key_Gender], @"Gender",
                                  [userDefaults objectForKey:Key_HeadImage], @"HeadImageURL",
                                  @"3", @"OpenID", nil];
        if (![[DataBaseManager shareManager] addUserWithDictionary:tempDict]) {
            NSLog(@"用户数据写入失败!");
        }
        
        if (responseBlock) {
            responseBlock(YES, responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        FZNetworkingError(NSStringFromClass(self.class));
    }];
}

- (void)getAllTags
{
    [self.requestManager GET:URLStringByAppending(kGetTag) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Tags%@", responseObject);
        [[EGOCache globalCache] setPlist:responseObject forKey:Key_Tag withTimeoutInterval:NSNotFound];
        
        NSArray *tagArray = [responseObject objectForKey:@"data"];
        NSMutableDictionary *tagDictionary = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < tagArray.count; i++) {
            NSDictionary *tagDict = [tagArray objectAtIndex:i];
            [tagDictionary setObject:[tagDict objectForKey:@"name"] forKey:[tagDict objectForKey:@"id"]];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:tagDictionary forKey:Key_TagDictionary];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        FZNetworkingError(@"Get Tag info");
    }];
}

//Fangzhur[8276:2437721] {
//    data =     {
//        "index_scroll_ad" =         (
//                                     {
//                                         "pic_url" = "appimg/appimgs/20141104140857.jpg";
//                                         resolution = 4;
//                                         sort = 1;
//                                         "update_time" = 0;
//                                     },
//                                     {
//                                         "pic_url" = "appimg/appimgs/20141104140917.jpg";
//                                         resolution = 3;
//                                         sort = 2;
#warning 更新时间移到外层，还需增加活动持续时间 last_time
//                                         "update_time" = 0;
//                                     }
//                                     );
//    };
//    msg = "";
//    sucess = 1;
//}
- (void)getHomeADImages:(void (^)(NSArray *images, NSArray *links))block
{
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"index_scroll_ad", @"action",
                               @"2", @"appos", nil];
    [self.requestManager POST:URLStringByAppending(kGetAdImage) parameters:paramDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *resultDict = [responseObject objectForKey:@"data"];
        NSMutableArray *images = [NSMutableArray array];
        NSMutableArray *links = [NSMutableArray array];
        
        if ([[responseObject objectForKey:@"sucess"] intValue] == 1) {
            for (NSDictionary *infoDict in [resultDict objectForKey:@"index_scroll_ad"]) {
                [images addObject:ImageURL([infoDict objectForKey:@"pic_url"])];
                [links addObject:[infoDict objectForKey:@"id"]];
            }
        }
        
        block(images, links);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, nil);
        FZNetworkingError(@"Get AD images");
    }];
}

- (void)getHouseListWithOption:(NSArray *)paramArray
                     houseType:(NSString *)houseType
                      sortType:(NSString *)sortType
                          page:(NSInteger)page
                      complete:(void (^)(NSArray *houseListArray))responseBlock
{
    
    if ([paramArray.lastObject isEqualToString:@"Contract"]) {
        [self favouriteHouseWithType:houseType action:@"collectlist" houseID:nil complete:^(BOOL success, id responseObject) {
            if (success) {
                responseBlock([responseObject objectForKey:@"fanhui"]);
            }
            else {
                responseBlock(nil);
            }
        }];
        return;
    }
    if ([paramArray.lastObject isEqualToString:@"Screen"]) {
        [self getScreenDataWithCacheArray:paramArray houseType:houseType sortType:sortType page:page complete:responseBlock];
        return;
    }
    if ([paramArray.lastObject isEqualToString:@"Tag"]) {
        [self getHouseListWithTagID:[paramArray objectAtIndex:0] memberID:[paramArray objectAtIndex:1] houseType:houseType sortType:sortType page:page complete:responseBlock];
        return;
    }
    if ([paramArray.lastObject isEqualToString:@"PersonalCustom"]) {
        [self personalCustom:responseBlock];
        return;
    }
    
    ///////////////////////////////
    
    NSDictionary *paramDict = nil;
    if (paramArray.count == 2) {
        paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
                     paramArray.firstObject, @"q",
                     houseType, @"house_way",
                     sortType, @"order",
                     [NSNumber numberWithInt:page], @"page", nil];
    }
    else if (paramArray.count == 3) {
        paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
                     paramArray.firstObject, @"lat",
                     [paramArray objectAtIndex:1], @"lng",
                     houseType, @"house_way",
                     sortType, @"order",
                     [NSNumber numberWithInt:page], @"page", nil];
    }
    
    [self.requestManager POST:URLStringByAppending(kSearch) parameters:paramDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"HouseList: \n%@", responseObject);
        if ([[responseObject objectForKey:@"xinxi"] isKindOfClass:[NSString class]]) {
            responseBlock(nil);
        }
        else {
            NSArray *houseListArray = [responseObject objectForKey:@"xinxi"];
            responseBlock(houseListArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        responseBlock(nil);
        FZNetworkingError(@"house list:");
    }];
}

- (void)getScreenDataWithCacheArray:(NSArray *)cacheArray houseType:(NSString *)houseType sortType:(NSString *)sortType page:(NSInteger)page complete:(void (^)(NSArray *))responseBlock
{
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    NSDictionary *rootDict = [ZCReadFileMethods dataFromPlist:@"ScreenListData" ofType:Dictionary];
    NSDictionary *sectionItemDict = [[rootDict objectForKey:houseType] objectForKey:@"SectionItem"];
    
    if (sortType.length != 0) {
        [paramDict setObject:@"1" forKey:@"pricesort"];
    }
    [paramDict setObject:houseType forKey:@"house_way"];
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:sortType forKey:@"order"];
    [paramDict setObject:kScreenItemID(@"特殊标签", 9) forKey:@"feature"];
    [paramDict setObject:kScreenItemID(@"房屋类别", 3) forKey:@"house_type"];
    [paramDict setObject:kScreenItemID(@"户型", 4) forKey:@"house_room"];
    [paramDict setObject:kScreenItemID(@"装修", 7) forKey:@"house_fitment"];
    [paramDict setObject:kScreenItemID(@"朝向", 8) forKey:@"house_toward"];
    
    if (![[cacheArray objectAtIndex:11] isEqualToString:@"随时"]) {
        [paramDict setObject:[cacheArray objectAtIndex:11] forKey:@"canlive"];
    }
    
    NSString *square = [[[cacheArray objectAtIndex:5] componentsSeparatedByString:@","] firstObject];
    [paramDict setObject:square forKey:@"house_totalarea"];
    
    NSArray *priceRange = [[cacheArray objectAtIndex:6] componentsSeparatedByString:@","];
    if (houseType.integerValue == 1) {
        if ([priceRange.firstObject isEqualToString:priceRange.lastObject]) {
            if ([priceRange.firstObject isEqualToString:@"10000"]) {
                [paramDict setObject:@"10000-0" forKey:@"price"];
            }
            else {
                [paramDict setObject:[NSString stringWithFormat:@"0-%@", priceRange.firstObject] forKey:@"price"];
            }
        }
        else {
            [paramDict setObject:[NSString stringWithFormat:@"%@-%@", priceRange.firstObject, priceRange.lastObject] forKey:@"price"];
        }
    }
    else {
        if ([priceRange.firstObject isEqualToString:priceRange.lastObject]) {
            if ([priceRange.firstObject isEqualToString:@"10000000"]) {
                [paramDict setObject:@"1000-0" forKey:@"price"];
            }
            else {
                [paramDict setObject:[NSString stringWithFormat:@"0-%d", [priceRange.firstObject integerValue] / 10000] forKey:@"price"];
            }
        }
        else {
            [paramDict setObject:[NSString stringWithFormat:@"%d-%d", [priceRange.firstObject integerValue] / 10000, [priceRange.lastObject integerValue] / 10000] forKey:@"price"];
        }
    }
    
    NSInteger index = [[cacheArray objectAtIndex:0] integerValue];
    if (index > 0) {
        NSDictionary *regionDict = [[DataBaseManager shareManager] cityRegion];
        NSLog(@"%@", [regionDict allKeys]);
        NSString *region = [[FZUserInfoWithKey(key_CityRegion) allKeys] objectAtIndex:index - 1];
        [paramDict setObject:[regionDict objectForKey:region] forKey:@"cityarea_id"];
        
        index = [[cacheArray objectAtIndex:1] integerValue];
        if (index > 0) {
            NSDictionary *subregionDict = [[DataBaseManager shareManager] subregionsFromRegion:region];
            NSArray *subregionArray = [FZUserInfoWithKey(key_CityRegion) objectForKey:region];
            [paramDict setObject:[subregionDict objectForKey:[subregionArray objectAtIndex:index - 1]]
                          forKey:@"cityarea2_id"];
        }
    }
    
    index = [[cacheArray objectAtIndex:2] integerValue];
    if (index > 0) {
        NSDictionary *lineDict = [FZUserInfoWithKey(Key_Subway) objectAtIndex:index - 1];
        if ([lineDict objectForKey:@"ditie"]) {
            [paramDict setObject:[lineDict objectForKey:@"ditie"] forKey:@"line"];
        }
    }
    
    //=======================
    
    [self.requestManager POST:URLStringByAppending(kGetScreenData) parameters:paramDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Screen house list: \n%@", responseObject);
        if ([[responseObject objectForKey:@"xinxi"] isKindOfClass:[NSString class]]) {
            responseBlock(nil);
        }
        else {
            NSArray *houseListArray = [responseObject objectForKey:@"xinxi"];
            responseBlock(houseListArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        responseBlock(nil);
        FZNetworkingError(@"Screen house list:");
    }];
}

- (void)getHouseListWithTagID:(NSString *)tagID
                     memberID:(NSString *)memberID
                    houseType:(NSString *)houseType
                     sortType:(NSString *)sortType
                         page:(NSInteger)page
                     complete:(void (^)(NSArray *houseListArray))responseBlock
{
    NSDictionary *paramDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                               tagID, @"tag_id",
                               memberID, @"member_id",
                               sortType, @"order",
                               [NSString stringWithFormat:@"%d", (int)page], @"page", nil];
    NSString *URLString = nil;
    if ([houseType isEqualToString:@"1"] || [houseType isEqualToString:@"出租"]) {
        URLString = URLStringByAppending(kTag_RentList);
    }
    else {
        URLString = URLStringByAppending(kTag_SellList);
    }
    
    [self.requestManager POST:URLString parameters:paramDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[responseObject objectForKey:@"sucess"] intValue] == 0) {
            responseBlock(nil);
            return ;
        }
        responseBlock([responseObject objectForKey:@"data"]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        responseBlock(nil);
        FZNetworkingError(@"Tag house list:");
    }];
}

- (void)getHouseDetailWithHouseID:(NSString *)houseID memberID:(NSString *)memberID houseType:(NSString *)houseType complete:(void (^)(NSDictionary *detailData, NSDictionary *houseInfo))responseBlock
{
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               houseID, @"house_id",
                               memberID, @"member_id", nil];
    NSString *URLString = nil;
    if ([houseType isEqualToString:@"1"] || [houseType isEqualToString:@"出租"]) {
        URLString = URLStringByAppending(kRentDetail);
    }
    else {
        URLString = URLStringByAppending(kSellDetail);
    }
    
    [self.requestManager POST:URLString parameters:paramDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        responseBlock(responseObject, [[responseObject objectForKey:@"rentxiangqing"] lastObject]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        responseBlock(nil, nil);
        FZNetworkingError(@"House detail:");
    }];
}

- (void)getCommunitiesWithKey:(NSString *)key complete:(void (^)(NSArray *communityArray))responseBlock
{
    [self.requestManager POST:URLStringByAppending(kCommunityName) parameters:@{@"q" : key} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        responseBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        FZNetworkingError(@"Get communities:");
        responseBlock(nil);
    }];
}

- (void)uploadPhotosWithImages:(NSArray *)images complete:(void (^)(NSString *resultString))responseBlock
{
    for (int i = 0; i < images.count; i++) {
        [self.requestManager POST:URLStringByAppending(kUploadHousePic) parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            NSData *imageData = UIImageJPEGRepresentation(images[i], 0.5f);
            if (imageData.length > 2000) {
                imageData = UIImageJPEGRepresentation(images[i], 0.2f);
            }
            [formData appendPartWithFileData:imageData
                                        name:@"uploadfile"
                                    fileName:@"HouseImage.jpg"
                                    mimeType:@"image/jpg"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@", responseObject);
            responseBlock([responseObject objectForKey:@"file_url"]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            FZNetworkingError(@"Upload image:");
        }];
    }
}

- (void)uploadImage:(UIImage *)image imageType:(NSString *)imageType complete:(void (^)(BOOL, id))responseBlock
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSString stringWithFormat:@"uploadAvatarPicture|broker|%@", imageType], @"to",
                                FZUserInfoWithKey(Key_UserName), @"username",
                                FZUserInfoWithKey(Key_MemberID), @"member_id",
                                FZUserInfoWithKey(Key_LoginToken), @"token",
                                @"资料认证", @"photoContent", nil];
    [self.requestManager POST:URLStringByAppending(kUploadPic) parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5f);
        if (imageData.length > 2000) {
            imageData = UIImageJPEGRepresentation(image, 0.2f);
        }
        [formData appendPartWithFileData:imageData
                                    name:@"uploadfile"
                                fileName:@"Private.jpg"
                                mimeType:@"image/jpg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"fanhui"] intValue] == 1) {
                responseBlock(YES, responseObject);
            }
            else {
                responseBlock(NO, responseObject);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        responseBlock(NO, nil);
        FZNetworkingError(@"Upload image:");
    }];
}

- (void)releaseHouseWithType:(NSString *)type requestParameters:(NSDictionary *)paramDict complete:(void (^)(NSString *houseID))responseBlock
{
    NSString *URLString = nil;
    if (type.intValue == 1) {
        URLString = URLStringByAppending(kAllRent);
    }
    else {
        URLString = URLStringByAppending(kSell);
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:paramDict];
    [parameters setObject:FZUserInfoWithKey(Key_UserName) forKey:@"username"];
    [parameters setObject:FZUserInfoWithKey(Key_MemberID) forKey:@"member_id"];
    [parameters setObject:FZUserInfoWithKey(Key_LoginToken) forKey:@"token"];
    
    [self.requestManager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        responseBlock([responseObject objectForKey:@"house_id"]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        FZNetworkingError(@"Release house:");
        responseBlock(nil);
    }];
}

- (void)sendComment:(NSString *)comment withHouseID:(NSString *)houseID houseType:(NSString *)houseType complete:(void (^)(BOOL))responseBlock
{
    NSDictionary *paramDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                               @"add_comment", @"action",
                               houseID, @"house_id",
                               houseType, @"house_type",
                               comment, @"content",
                               FZUserInfoWithKey(Key_MemberID), @"member_id",
                               FZUserInfoWithKey(Key_LoginToken), @"token", nil];
    
    [self.requestManager POST:URLStringByAppending(kComment) parameters:paramDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        
        if ([[responseObject objectForKey:@"sucess"] intValue] == 1) {
            responseBlock(YES);
        }
        else {
            responseBlock(NO);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        FZNetworkingError(@"Send comment");
        responseBlock(NO);
    }];
}

- (void)getCommentListWithHouseID:(NSString *)houseID houseType:(NSString *)houseType page:(NSInteger)page complete:(void (^)(BOOL success, NSArray *commentList, NSDictionary *referenceDict))responseBlock
{
    NSDictionary *paramDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                               @"comment_list", @"action",
                               FZUserInfoWithKey(Key_MemberID), @"member_id",
                               FZUserInfoWithKey(Key_LoginToken), @"token",
                               [NSString stringWithFormat:@"%d", page], @"page",
                               houseID, @"house_id",
                               houseType, @"house_type",
                                nil];
    
    [self.requestManager POST:URLStringByAppending(kComment) parameters:paramDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        
        if ([[responseObject objectForKey:@"sucess"] intValue] == 1) {
            NSDictionary *resultDict = [responseObject objectForKey:@"data"];
            responseBlock(YES, [resultDict objectForKey:@"list"], [resultDict objectForKey:@"reply_list"]);
        }
        else {
            responseBlock(NO, nil, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        FZNetworkingError(@"Send comment");
        responseBlock(NO, nil, nil);
    }];
}

- (void)getAllCommentsWithPage:(NSInteger)page complete:(void (^)(BOOL, NSArray *, NSDictionary *))responseBlock
{
    NSDictionary *paramDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                              @"my_comment_list", @"action",
                              FZUserInfoWithKey(Key_MemberID), @"member_id",
                              FZUserInfoWithKey(Key_LoginToken), @"token",
                              [NSString stringWithFormat:@"%d", page], @"page", nil];
    
    [self.requestManager POST:URLStringByAppending(kComment) parameters:paramDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        
        if ([[responseObject objectForKey:@"sucess"] intValue] == 1) {
            NSDictionary *resultDict = [responseObject objectForKey:@"data"];
            if ([[resultDict objectForKey:@"reply_list"] isKindOfClass:[NSArray class]]) {
                responseBlock(YES, [resultDict objectForKey:@"list"], nil);
            }
            else {
                responseBlock(YES, [resultDict objectForKey:@"list"], [resultDict objectForKey:@"reply_list"]);
            }
        }
        else {
            responseBlock(NO, nil, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        FZNetworkingError(@"Send comment");
        responseBlock(NO, nil, nil);
    }];
}

- (void)markCommentsReaded
{
    NSDictionary *paramDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                               @"mark_read", @"action",
                               FZUserInfoWithKey(Key_MemberID), @"member_id",
                               FZUserInfoWithKey(Key_LoginToken), @"token", nil];
    
    [self.requestManager POST:URLStringByAppending(kComment) parameters:paramDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        FZNetworkingError(@"Send comment");
    }];
}

- (void)replyComment:(NSString *)comment withCommentID:(NSString *)commentID complete:(void (^)(BOOL))responseBlock
{
    NSDictionary *paramDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                               @"reply_comment", @"action",
                               commentID, @"reply_comment_id",
                               comment, @"content",
                               FZUserInfoWithKey(Key_MemberID), @"member_id",
                               FZUserInfoWithKey(Key_LoginToken), @"token", nil];
    
    [self.requestManager POST:URLStringByAppending(kComment) parameters:paramDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        
        if ([[responseObject objectForKey:@"sucess"] intValue] == 1) {
            responseBlock(YES);
        }
        else {
            responseBlock(NO);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        FZNetworkingError(@"Send comment");
        responseBlock(NO);
    }];
}

- (void)getOrdersWithType:(NSString *)type subtype:(NSString *)subtype page:(NSInteger)page complete:(void (^)(NSArray *))responseBlock
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                FZUserInfoWithKey(Key_UserName), @"username",
                                FZUserInfoWithKey(Key_MemberID), @"member_id",
                                FZUserInfoWithKey(Key_LoginToken), @"token",
                                subtype, @"sub_type",
                                type, @"type",
                                [NSString stringWithFormat:@"%d", page], @"page", nil];
    
    [self.requestManager POST:URLStringByAppending(kMyOrder) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            responseBlock(responseObject);
        }
        else {
            responseBlock(nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        FZNetworkingError(@"我的订单");
    }];
}

- (void)favouriteHouseWithType:(NSString *)type action:(NSString *)action houseID:(NSString *)houseID complete:(void (^)(BOOL, id))responseBlock
{
    if ([type isEqualToString:@"出租"] || [type isEqualToString:@"1"]) {
        type = @"rent";
    }
    else {
        type = @"sale";
    }
    
    NSDictionary *parameters = nil;
    if ([action hasSuffix:@"list"]) {
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                      type, @"type",
                      action, @"action",
                      FZUserInfoWithKey(Key_UserName), @"username",
                      FZUserInfoWithKey(Key_MemberID), @"member_id",
                      FZUserInfoWithKey(Key_LoginToken), @"token", nil];
    }
    else {
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                      type, @"type",
                      action, @"action",
                      houseID, @"id",
                      FZUserInfoWithKey(Key_UserName), @"username",
                      FZUserInfoWithKey(Key_MemberID), @"member_id",
                      FZUserInfoWithKey(Key_LoginToken), @"token", nil];
    }
    
    [self.requestManager POST:URLStringByAppending(kAttention) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        
        if ([[responseObject objectForKey:@"fanhui"] isKindOfClass:[NSArray class]]) {
            responseBlock(YES, responseObject);
        }
        else if ([[responseObject objectForKey:@"fanhui"] intValue] == 1) {
            responseBlock(YES, responseObject);
        }
        else {
            responseBlock(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        responseBlock(NO, nil);
        FZNetworkingError(@"收藏房源");
    }];
}

- (void)checkVersionHandler:(void (^)(NSString *))handler
{
    [self.requestManager GET:kAppVersion parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        
        NSArray *results = [responseObject objectForKey:@"results"];
        NSDictionary *proDic = [results firstObject];
        NSString *version = [proDic objectForKey:@"version"];
        
        handler(version);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        FZNetworkingError(@"检查版本");
        handler(nil);
    }];
}

- (void)sendMessage:(NSString *)content ofHouseID:(NSString *)houseID houseType:(NSString *)houseType from:(NSString *)sender to:(NSString *)receiver receiverPhone:(NSString *)receiverPhone complete:(void (^)(BOOL, id))responseBlock
{
    if ([houseType isEqualToString:@"出租"]) {
        houseType = @"1";
    }
    else if ([houseType isEqualToString:@"出售"]) {
        houseType = @"2";
    }
    
    NSDictionary *paramDict = nil;
    if ([receiver isEqualToString:@"0"] || !receiver) {
        paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
                     @"send_msg", @"action",
                     content, @"content",
                     houseID, @"house_id",
                     houseType, @"house_type",
                     sender, @"sender_id",
                     receiverPhone, @"receiver_username",
                     FZUserInfoWithKey(Key_LoginToken), @"token", nil];
    }
    else {
        paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
                     @"send_msg", @"action",
                     content, @"content",
                     houseID, @"house_id",
                     houseType, @"house_type",
                     sender, @"sender_id",
                     receiver, @"receiver_id",
                     FZUserInfoWithKey(Key_LoginToken), @"token", nil];
    }
    
    [self.requestManager POST:URLStringByAppending(kChat) parameters:paramDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"send chat\n%@", responseObject);
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"sucess"] isEqualToString:@"1"]) {
                responseBlock(YES, responseObject);
                dispatch_queue_t isolationQueueu = dispatch_queue_create("Chat.isolation", DISPATCH_QUEUE_CONCURRENT);
                dispatch_barrier_async(isolationQueueu, ^{
                    NSMutableArray *chatArray = [[NSMutableArray alloc] initWithArray:
                                                 [[EGOCache globalCache] plistForKey:houseID]];
                    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
                    NSDictionary *chatDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                              @(YES), @"fromMe",
                                              content, @"message",
                                              [NSString stringWithFormat:@"%f", interval], @"date",
                                              @"SOMessageTypeText", @"type", nil];
                    [chatArray addObject:chatDict];
                    [[EGOCache globalCache] setPlist:chatArray forKey:houseID withTimeoutInterval:NSNotFound];
                });
            }
            else {
                responseBlock(NO, responseObject);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        responseBlock(NO, nil);
        FZNetworkingError(@"发送私信");
    }];
}

- (void)receiveMessageWithAction:(NSString *)action
                        receiver:(NSString *)receiver
                          sender:(NSString *)sender
                         houseID:(NSString *)houseID
                       houseType:(NSString *)houseType
                        complete:(void (^)(BOOL, NSArray *, id))responseBlock
{
    if ([houseType isEqualToString:@"出租"]) {
        houseType = @"1";
    }
    else if ([houseType isEqualToString:@"出售"]) {
        houseType = @"2";
    }
    
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               action, @"action",
                               houseID, @"house_id",
                               houseType, @"house_type",
                               receiver, @"receiver_id",
                               FZUserInfoWithKey(Key_LoginToken), @"token",
                               sender, @"sender_id", nil];
    [self.requestManager POST:URLStringByAppending(kChat) parameters:paramDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"receive chat\n%@", responseObject);
        
        if (([[responseObject objectForKey:@"data"] isKindOfClass:[NSString class]]) ||
            ([[responseObject objectForKey:@"data"] count] == 0)) {
            responseBlock(NO, nil, responseObject);
        }
        else {
            NSMutableArray *chatArray = [NSMutableArray array];

            if ([action isEqualToString:@"my_all_msg"]) {
                NSArray *dataArray = [[responseObject objectForKey:@"data"] objectForKey:@"data"];

                for (NSDictionary *dataDict in dataArray) {
                    //根据信息发送者来判断信息是否来自自己
                    NSNumber *fromMe = nil;
                    if ([FZUserInfoWithKey(Key_MemberID) isEqualToString:[dataDict objectForKey:@"sender_id"]]) {
                        fromMe = @(YES);
                    }
                    else {
                        fromMe = @(NO);
                    }
                    NSDictionary *chatDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                              fromMe, @"fromMe",
                                              [dataDict objectForKey:@"content"], @"message",
                                              [dataDict objectForKey:@"created_on"], @"date",
                                              [dataDict objectForKey:@"username"], @"username",
                                              [dataDict objectForKey:@"sender_id"], @"sender_id",
                                              @"SOMessageTypeText", @"type", nil];
                    [chatArray addObject:chatDict];
                }
            }
            else {
                for (NSDictionary *dataDict in [responseObject objectForKey:@"data"]) {
                    NSDictionary *chatDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                              @(NO), @"fromMe",
                                              [dataDict objectForKey:@"content"], @"message",
                                              [dataDict objectForKey:@"created_on"], @"date",
                                              [dataDict objectForKey:@"username"], @"username",
                                              [dataDict objectForKey:@"sender_id"], @"sender_id",
                                              @"SOMessageTypeText", @"type", nil];
                    [chatArray addObject:chatDict];
            }
        
        }
            responseBlock(YES, chatArray, responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        FZNetworkingError(@"发送私信");
    }];
}

- (void)hasNewMessageOfHouseID:(NSString *)houseID houseType:(NSString *)houseType to:(NSString *)receiver complete:(void (^)(BOOL,  NSInteger, id))responseBlock
{
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"has_msg", @"action",
                               houseID, @"house_id",
                               houseType, @"house_type",
                               receiver, @"receiver_id",
                               FZUserInfoWithKey(Key_LoginToken), @"token", nil];
    [self.requestManager POST:URLStringByAppending(kChat) parameters:paramDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"has new message\n%@", responseObject);
        if ([[responseObject objectForKey:@"sucess"] intValue] == 1) {
            responseBlock(YES, [[[responseObject objectForKey:@"data"] objectForKey:@"has_msg"] intValue], responseObject);
        }
        else {
            responseBlock(NO, -1, responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        responseBlock(NO, -1, nil);
        FZNetworkingError(@"发送私信");
    }];
}

- (void)getCommunityInfoWithHouseNumber:(NSString *)houseNumber houseType:(NSString *)houseType complete:(void (^)(BOOL success, id responseObject))responseBlock
{
    if ([houseType isEqualToString:@"1"] || [houseType isEqualToString:@"rent"]) {
        houseType = @"rent";
    }
    else {
        houseType = @"sale";
    }
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"check_house_info", @"action",
                               houseType, @"htype",
                               houseNumber, @"h_no", nil];
    [self.requestManager POST:URLStringByAppending(kHouseInfoByID) parameters:paramDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject objectForKey:@"error"]) {
                responseBlock(NO, responseObject);
            }
            else {
                responseBlock(YES, responseObject);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        FZNetworkingError(@"订单编号");
        responseBlock(NO, nil);
    }];
}

- (void)releaseOrderWithParameters:(NSDictionary *)parameters complete:(void (^)(BOOL, id))responseBlock
{
    [self.requestManager POST:URLStringByAppending(kReleaseOrder) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject objectForKey:@"token"]) {
                responseBlock(NO, responseObject);
            }
            else {
                responseBlock(YES, responseObject);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        FZNetworkingError(@"发布订单");
    }];
}

- (void)finishContractWithJiaoyiID:(NSString *)jiaoyiID complete:(void (^)(BOOL, id))responseBlock
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                jiaoyiID, @"id",
                                FZUserInfoWithKey(Key_UserName), @"username",
                                FZUserInfoWithKey(Key_MemberID), @"member_id",
                                FZUserInfoWithKey(Key_LoginToken), @"token", nil];
    [self.requestManager POST:URLStringByAppending(kTradeFinished) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject objectForKey:@"token"]) {
            responseBlock(NO, responseObject);
        }
        else {
            responseBlock(YES, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        FZNetworkingError(@"完成线上订单");
    }];
}

- (void)informOrderWithParameters:(NSDictionary *)parameters complete:(void (^)(BOOL, id))responseBlock
{
    [self.requestManager POST:URLStringByAppending(kInformOrder) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"fanhui"] intValue] == 1) {
                responseBlock(YES, responseObject);
            }
            else {
                responseBlock(NO, responseObject);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        FZNetworkingError(@"举报订单");
    }];
}

- (void)chooseAdvicerWithID:(NSString *)advicerID jiaoyiID:(NSString *)jiaoyiID complete:(void (^)(BOOL))responseBlock
{
   NSDictionary *parameters =  [NSDictionary dictionaryWithObjectsAndKeys:
                                advicerID, @"advicer_id",
                                jiaoyiID, @"jiaoyi_id",
                                FZUserInfoWithKey(Key_LoginToken), @"token",
                                FZUserInfoWithKey(Key_UserName), @"username",
                                FZUserInfoWithKey(Key_MemberID), @"member_id", nil];
    [self.requestManager POST:URLStringByAppending(kChooseAgent) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"fanhui"] intValue] == 1) {
                responseBlock(YES);
            }
            else {
                responseBlock(NO);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        FZNetworkingError(@"选择顾问");
    }];
}

- (void)cancelOrderWithID:(NSString *)orderID complete:(void (^)(BOOL))responseBlock
{
    NSDictionary *parameters =  [NSDictionary dictionaryWithObjectsAndKeys:
                                 orderID, @"id",
                                 FZUserInfoWithKey(Key_LoginToken), @"token",
                                 FZUserInfoWithKey(Key_UserName), @"username",
                                 FZUserInfoWithKey(Key_MemberID), @"member_id", nil];
    [self.requestManager POST:URLStringByAppending(kCancelOrder) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"fanhui"] intValue] == 1) {
                responseBlock(YES);
            }
            else {
                responseBlock(NO);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        FZNetworkingError(@"取消订单");
    }];
}

- (void)appraiseHouseWithHouseID:(NSString *)houseID houseType:(NSString *)houseType appraiseType:(NSString *)appraiseType complete:(void (^)(BOOL, id))responseBlock
{
    if ([houseType isEqualToString:@"出租"] || [houseType isEqualToString:@"1"]) {
        houseType = @"rent";
    }
    else if ([houseType isEqualToString:@"出售"] || [houseType isEqualToString:@"2"]) {
        houseType = @"sell";
    }
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                houseID, @"house_id",
                                houseType, @"house_type",
                                appraiseType, @"report_type",
                                FZUserInfoWithKey(Key_UserName), @"username",
                                FZUserInfoWithKey(Key_MemberID), @"member_id",
                                FZUserInfoWithKey(Key_LoginToken), @"token",
                                nil];
    [self.requestManager POST:URLStringByAppending(kAppraise) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"举报%@", responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"sucess"] intValue] == 1) {
                responseBlock(YES, responseObject);
            }
            else {
                responseBlock(NO, responseObject);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        FZNetworkingError(@"举报接口");
    }];
}

- (void)personalCustom:(void (^)(NSArray *))responseBlock
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                FZUserInfoWithKey(Key_MemberID), @"member_id", nil];
    
    [self.requestManager POST:URLStringByAppending(kPersonalCustom) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"私人定制%@", responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            responseBlock([[responseObject objectForKey:@"data"] objectForKey:@"xinxi"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        responseBlock(nil);
        FZNetworkingError(@"私人定制");
    }];
}

- (void)getMessageList:(void (^)(BOOL success, NSString *newMessageNum, NSArray *listArray, id responseObject))responseBlock
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                FZUserInfoWithKey(Key_MemberID), @"receiver_id",
                                FZUserInfoWithKey(Key_LoginToken), @"token",
                                @"my_all_msg", @"action", nil];
    [self.requestManager POST:URLStringByAppending(kChat) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"消息列表%@", responseObject);
        
        NSDictionary *dataDict = [responseObject objectForKey:@"data"];
        if ([[responseObject objectForKey:@"sucess"] intValue] == 1) {
            responseBlock(YES, [dataDict objectForKey:@"count"], [dataDict objectForKey:@"data"], responseObject);
        }
        else {
            responseBlock(NO, @"0", nil, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        FZNetworkingError(@"消息列表");
    }];
}

- (void)getAdInfoWithID:(NSString *)adID complete:(void (^)(BOOL, NSArray *))responseBlock
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"2", @"appos",
                                adID, @"id", nil];
    [self.requestManager POST:URLStringByAppending(kAdDetail) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        
        if ([[responseObject objectForKey:@"sucess"] intValue] == 1) {
            responseBlock(YES, [[responseObject objectForKey:@"data"] objectForKey:@"detail"]);
        }
        else {
            responseBlock(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        FZNetworkingError(@"广告页");
    }];
}

- (void)getMessageNumber:(void (^)(NSString *))responseBlock
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                FZUserInfoWithKey(Key_MemberID), @"receiver_id",
                                FZUserInfoWithKey(Key_LoginToken), @"token",
                                @"all_msg_count", @"action", nil];
    [self.requestManager POST:URLStringByAppending(kChat) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"消息个数%@", responseObject);
        
        responseBlock([[responseObject objectForKey:@"data"] lastObject]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        FZNetworkingError(@"消息个数");
    }];
}

- (void)houseManagementWithManageType:(NSString *)type houseType:(NSString *)houseType action:(NSString *)action handler:(void (^)(id))responseBlock
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                type, @"type",
                                action, @"action",
                                FZUserInfoWithKey(Key_UserName), @"username",
                                FZUserInfoWithKey(Key_MemberID), @"member_id",
                                FZUserInfoWithKey(Key_LoginToken), @"token", nil];
    NSString *urlString = nil;
    if ([houseType isEqualToString:@"出租"]) {
        urlString = URLStringByAppending(kRentManagement);
    }
    else {
        urlString = URLStringByAppending(kSaleManagement);
    }
    
    [self.requestManager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        responseBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        FZNetworkingError(@"房源管理");
    }];
}

- (void)canBrowseWithAction:(NSString *)action houseID:(NSString *)houseID handler:(void (^)(BOOL, id))handler
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                action, @"action",
                                houseID, @"id",
                                FZUserInfoWithKey(Key_RoleType), @"role_type",
                                FZUserInfoWithKey(Key_UserName), @"username",
                                FZUserInfoWithKey(Key_MemberID), @"member_id",
                                FZUserInfoWithKey(Key_LoginToken), @"token", nil];
    [self.requestManager POST:URLStringByAppending(kTelephone) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"查看次数%@", responseObject);
        
        if ([[responseObject objectForKey:@"fanhui"] integerValue] == -2) {
            handler(NO, responseObject);
        }
        else {
            handler(YES, responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        FZNetworkingError(@"查看次数");
    }];
}

- (void)markAShareWithHouseID:(NSString *)houseID houseType:(NSString *)houseType
{
    if ([houseType isEqualToString:@"出租"] || [houseType isEqualToString:@"1"]) {
        houseType = @"1";
    }
    else if ([houseType isEqualToString:@"出售"] || [houseType isEqualToString:@"2"]) {
        houseType = @"2";
    }
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"add_share", @"action",
                                houseID, @"house_id",
                                houseType, @"type",
                                FZUserInfoWithKey(Key_MemberID), @"member_id",
                                FZUserInfoWithKey(Key_LoginToken), @"token", nil];
    [self.requestManager POST:URLStringByAppending(kShare) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"查看次数%@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        FZNetworkingError(@"查看次数");
    }];
}

- (void)requestBankListHandler:(void (^)(NSArray *))handler
{
    [[AFHTTPRequestOperationManager manager] GET:URLStringByAppending(kBankList) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if (handler) {
            handler(responseObject);
        }
        [[EGOCache globalCache] setPlist:responseObject forKey:@"Banklist" withTimeoutInterval:NSNotFound];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",operation.responseObject);
    }];
}

- (void)getCheckCodeOfUser:(NSString *)userName complete:(void (^)(BOOL, id))responseBlock
{
    NSDictionary *paramDict = [NSDictionary dictionaryWithObject:userName forKey:@"username"];
    [self.requestManager POST:URLStringByAppending(kGetPassword)
                   parameters:paramDict
                      success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         responseBlock(YES, responseObject);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         FZNetworkingError(@"Get Password Error");
         responseBlock(NO, nil);
     }];
}

- (void)requestPaymentURLByParameters:(NSDictionary *)parameters handler:(void (^)(BOOL, NSString *, NSString *))handler
{
    [self.requestManager POST:URLStringByAppending(kGetPaymentURL) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"易宝跳转链接%@", responseObject);
        if ([[responseObject objectForKey:@"sucess"] intValue] == 1) {
            handler(YES, [[responseObject objectForKey:@"data"] lastObject], nil);
        }
        else {
            handler(NO, nil, [responseObject objectForKey:@"msg"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        FZNetworkingError(@"易宝跳转链接");
        handler(NO, nil, operation.responseString);
    }];
}

@end
