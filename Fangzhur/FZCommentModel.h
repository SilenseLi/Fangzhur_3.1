//
//  FZCommentModel.h
//  Fangzhur
//
//  Created by --超-- on 14/12/7.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FZCommentModel : NSObject

//评论ID
@property (nonatomic, copy) NSString *commentID;
//评论内容
@property (nonatomic, copy) NSString *content;
//评论时间
@property (nonatomic, copy) NSString *created_on;
//回复ID
@property (nonatomic, copy) NSString *comment_id_str;
//房源ID
@property (nonatomic, copy) NSString *house_id;
//房源交易类型
@property (nonatomic, copy) NSString *house_type;
//评论发布者
@property (nonatomic, copy) NSString *username;

- (NSString *)stringByHidePhoneTail;

@end
