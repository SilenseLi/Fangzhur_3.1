//
//  FZFriendsCenterView.h
//  AgentAPP
//
//  Created by L Suk on 14-4-30.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZFriendsCenterView : UIScrollView
{
    NSInteger _selectedIndex;
    UIImageView *_codeImageView;
}

@property (nonatomic, retain) UIImageView *codeImageView;
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;

- (void)addTarget:(id)target action:(SEL)action;

@end
