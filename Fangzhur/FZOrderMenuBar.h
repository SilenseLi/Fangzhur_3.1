//
//  FZOrderMenuBar.h
//  Fangzhur
//
//  Created by --Chao-- on 14-7-4.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ChangeChannelBlock)(NSUInteger index);

@interface FZOrderMenuBar : UIScrollView

@property (nonatomic, retain) NSArray *titleArray;
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, copy) ChangeChannelBlock channelBlock;

- (void)installMenuInView:(UIView *)view;
- (void)addTarget:(id)target action:(SEL)action;
- (void)changeChannel:(ChangeChannelBlock)block;
- (void)changeSelectedItem:(NSInteger)index;

@end
