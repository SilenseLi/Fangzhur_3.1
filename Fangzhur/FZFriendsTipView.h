//
//  FZFriendsTipView.h
//  AgentAPP
//
//  Created by L Suk on 14-4-30.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZFriendsTipView : UIView
{
    UILabel *_tipLabel;
    //判断视图是否出现
    BOOL _isTipOpen;
}

@property (nonatomic, retain) UILabel *tipLabel;
@property (nonatomic, readonly) BOOL isTipOpen;

@end
