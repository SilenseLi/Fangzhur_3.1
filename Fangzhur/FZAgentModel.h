//
//  FZAgentModel.h
//  Fangzhur
//
//  Created by --超-- on 14-7-23.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FZAgentModel : NSObject

/** 等级 0（无级别）；1（初级）；2（中级）；3（高级） */
@property (nonatomic, copy) NSString *level;
/** 顾问名字 */
@property (nonatomic, copy) NSString *realname;
/** 服务承诺 */
@property (nonatomic, copy) NSString *fw_accep;
/** 服务次数 */
@property (nonatomic, copy) NSString *fw_servicecount;
/** 好评率 */
@property (nonatomic, copy) NSString *fw_pl_zonglvt;
//照片
@property (nonatomic, copy) NSString *avatar;
//服务类型
@property (nonatomic, copy) NSString *service_typea;
//信用度
@property (nonatomic, copy) NSString *xinyong;
//顾问ID
@property (nonatomic, copy) NSString *advicer_id;

@end
