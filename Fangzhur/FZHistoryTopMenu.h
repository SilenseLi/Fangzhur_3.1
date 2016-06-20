//
//  FZHistoryTopMenu.h
//  Fangzhur
//
//  Created by --Chao-- on 14-7-3.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZHistoryTopMenu : UIScrollView 

@property (nonatomic, retain) NSArray *titleArray;
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;

- (void)installMenuInView:(UIView *)view;
- (void)addTarget:(id)target action:(SEL)action;
- (void)changeSelectedItem:(NSInteger)index;

@end
