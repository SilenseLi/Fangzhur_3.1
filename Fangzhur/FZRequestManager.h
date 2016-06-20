//
//  FZRequest.h
//  Fangzhur
//
//  Created by --超-- on 14/11/6.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface FZRequestManager : NSObject 

@property (nonatomic, strong) AFHTTPRequestOperationManager *requestManager;

/** 获取网络请求管理器实例 */
+ (FZRequestManager *)manager;

- (void)cancelAllOperations;

/** 登录 */
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password status:(NSString *)status helpCode:(NSString *)helpCode complete:(void (^)(BOOL success, id userInfo))responseBlock;
- (void)sendThirdLoginInfo:(NSDictionary *)loginInfo complete:(void (^)(BOOL success, NSDictionary *userInfo))responseBlock;

/** 获取验证码 */
- (void)getCheckCodeOfUser:(NSString *)userName complete:(void(^)(BOOL success, id responseObject))responseBlock;

/** 获取城区信息 */
- (void)getRegionInfo;

/** 获取地铁信息 */
- (void)getSubwayInfo;

/** 请求用户数据，并缓存 */
- (void)getUserInfoComplete:(void (^)(BOOL success, id responseObject))responseBlock;

/** 获取所有Tag */
- (void)getAllTags;

/** 请求首页轮播图片数据 */
- (void)getHomeADImages:(void (^)(NSArray *images, NSArray *links))block;

/** 
 * @brief 两种搜索模式，1根据关键字  2根据当前位置 
 * @param paramArray 1传入key   2传入经纬度 first: lon，last: lat
 * @param houseType 1出租 2出售
 * @param sortType price_inc 价格升序 , price_desc 价格降序 ,distance 距离
 */
- (void)getHouseListWithOption:(NSArray *)paramArray
                     houseType:(NSString *)houseType
                      sortType:(NSString *)sortType
                          page:(NSInteger)page
                      complete:(void (^)(NSArray *houseListArray))responseBlock;


/**
 * @brief 筛选房源数据
 * @param cacheArray 存储筛选选择的项
 * @param houseType 1出租 2出售
 * @param sortType price_inc 价格升序 , price_desc 价格降序 ,distance 距离
 */
- (void)getScreenDataWithCacheArray:(NSArray *)cacheArray
                          houseType:(NSString *)houseType
                           sortType:(NSString *)sortType
                               page:(NSInteger)page
                           complete:(void (^)(NSArray *houseListArray))responseBlock;


/**
 * @brief 获取标签房源列表数据
 */
- (void)getHouseListWithTagID:(NSString *)tagID
                     memberID:(NSString *)memberID
                    houseType:(NSString *)houseType
                     sortType:(NSString *)sortType
                         page:(NSInteger)page
                     complete:(void (^)(NSArray *houseListArray))responseBlock;

/**
 * @brief 获取房源详情数据
 */
- (void)getHouseDetailWithHouseID:(NSString *)houseID
                         memberID:(NSString *)memberID
                        houseType:(NSString *)houseType
                         complete:(void (^)(NSDictionary *detailData, NSDictionary *houseInfo))responseBlock;
/** 
 * @brief 查看房主电话次数
 * @param action sellcounter/rentcounter
 * @param role_type
 * @param id     house_id不是house_no
 */
- (void)canBrowseWithAction:(NSString *)action houseID:(NSString *)houseID handler:(void (^)(BOOL success, id responseObject))handler;
- (void)markAShareWithHouseID:(NSString *)houseID houseType:(NSString *)houseType;

/** 根据关键字检索小区 */
- (void)getCommunitiesWithKey:(NSString *)key complete:(void (^)(NSArray *communityArray))responseBlock;

/** 上传照片 */
- (void)uploadPhotosWithImages:(NSArray *)images complete:(void (^)(NSString *resultString))responseBlock;
- (void)uploadImage:(UIImage *)image imageType:(NSString *)imageType complete:(void (^)(BOOL success, id responseObject))responseBlock;
/** 
 * @brief 发布房源
 * @param type 1出租 2出售
 */
- (void)releaseHouseWithType:(NSString *)type requestParameters:(NSDictionary *)paramDict complete:(void (^)(NSString *houseID))responseBlock;

/** 发布评论 */
- (void)sendComment:(NSString *)comment withHouseID:(NSString *)houseID houseType:(NSString *)houseType complete:(void (^)(BOOL success))responseBlock;

/** 获取评论列表 */
- (void)getCommentListWithHouseID:(NSString *)houseID houseType:(NSString *)houseType page:(NSInteger)page complete:(void (^)(BOOL success, NSArray *commentList, NSDictionary *referenceDict))responseBlock;
/** 获取所有和我相关的评论 */
- (void)getAllCommentsWithPage:(NSInteger)page complete:(void (^)(BOOL success, NSArray *commentList, NSDictionary *referenceDict))responseBlock;

/** 标记评论为已读 */
- (void)markCommentsReaded;

/** 回复评论 */
- (void)replyComment:(NSString *)comment withCommentID:(NSString *)commentID complete:(void (^)(BOOL success))responseBlock;

/** 我的订单 */
- (void)getOrdersWithType:(NSString *)type subtype:(NSString *)subtype page:(NSInteger)page complete:(void (^)(NSArray *))responseBlock;

/** 
 * @brief 关注房源 
 * @param type: sale rent
 * @param action: collect qxcollect collectlist clearlist */
- (void)favouriteHouseWithType:(NSString *)type action:(NSString *)action houseID:(NSString *)houseID complete:(void(^)(BOOL success, id responseObject))responseBlock;

/** 
 * @brief 发送私信
 * @param content 内容
 * @param sender 发送者 memeber id
 * @param receiver 接收者 member id
 */
- (void)sendMessage:(NSString *)content ofHouseID:(NSString *)houseID houseType:(NSString *)houseType from:(NSString *)sender to:(NSString *)receiver receiverPhone:(NSString *)receiverPhone complete:(void (^)(BOOL success, id responseObject))responseBlock;

/** 接收私信 */
- (void)receiveMessageWithAction:(NSString *)action receiver:(NSString *)receiver sender:(NSString *)sender houseID:(NSString *)houseID houseType:(NSString *)houseType complete:(void (^)(BOOL success, NSArray *chatArray, id responseObject))responseBlock;

/** 是否有新消息 */
- (void)hasNewMessageOfHouseID:(NSString *)houseID houseType:(NSString *)houseType to:(NSString *)receiver complete:(void (^)(BOOL success, NSInteger messageNumber, id responseObject))responseBlock;

/** 消息列表 */
- (void)getMessageList:(void (^)(BOOL success, NSString *newMessageNum, NSArray *listArray, id responseObject))responseBlock;

/** 未读消息个数 */
- (void)getMessageNumber:(void(^)(NSString *newMessageNum))responseBlock;

/** 举报订单 */
- (void)informOrderWithParameters:(NSDictionary *)parameters complete:(void (^)(BOOL success ,id responseObject))responseBlock;
/** 选择顾问 */
- (void)chooseAdvicerWithID:(NSString *)advicerID jiaoyiID:(NSString *)jiaoyiID complete:(void (^)(BOOL success))responseBlock;
/** 取消订单 */
- (void)cancelOrderWithID:(NSString *)orderID complete:(void (^)(BOOL success))responseBlock;

/** 
 * @brief 评价 
 * @param houseType rent sell
 * @param appraiseType 1 是房主 2 未接通 3已成交 4错误房源 5中介冒充
 */
- (void)appraiseHouseWithHouseID:(NSString *)houseID houseType:(NSString *)houseType appraiseType:(NSString *)appraiseType complete:(void (^)(BOOL success, id responseObject))responseBlock;

//===============签约=================

/** 
 * @brief 根据房源编号获取小区信息
 * @param houseType rent sale 
 */
- (void)getCommunityInfoWithHouseNumber:(NSString *)houseNumber houseType:(NSString *)houseType complete:(void (^)(BOOL success, id responseObject))responseBlock;

/** 发布订单 */
- (void)releaseOrderWithParameters:(NSDictionary *)parameters complete:(void (^)(BOOL success, id responseObject))responseBlock;
/** 完成线上订单 */
- (void)finishContractWithJiaoyiID:(NSString *)jiaoyiID complete:(void (^)(BOOL success, id responseObject))responseBlock;

/** 私人定制 */
- (void)personalCustom:(void (^)(NSArray *houseListArray))responseBlock;

/** 首页广告 */
- (void)getAdInfoWithID:(NSString *)adID complete:(void (^)(BOOL success, NSArray *detailArray))responseBlock;

/** 房源管理 */
- (void)houseManagementWithManageType:(NSString *)type houseType:(NSString *)houseType action:(NSString *)action handler:(void (^)(id responseObject))responseBlock;

/** Check version */
- (void)checkVersionHandler:(void (^)(NSString *versionString))handler;

//================支付==================

/** 请求银行列表 */
- (void)requestBankListHandler:(void (^)(NSArray *))handler;
/** 请求支付链接 */
- (void)requestPaymentURLByParameters:(NSDictionary *)parameters handler:(void (^)(BOOL success, NSString *URLString, NSString *errorMessage))handler;

@end
