//
//  ZCDropDownList.h
//  Fangzhur
//
//  Created by --Chao-- on 14-6-4.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCDropDownList : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIButton *titleButton;
@property (nonatomic, strong) UITableView *listView;

@property (nonatomic, assign) BOOL willShow;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;

/**
 * @brief 初始化下拉列表对象
 * @param title 默认显示的标题
 * @param list 下拉列表数组，用于显示的数据项
 */
- (id)initWithFrame:(CGRect)frame defaultTitle:(NSString *)title list:(NSArray *)listArray;
- (id)initWithFrame:(CGRect)frame Image:(UIImage *)image list:(NSArray *)listArray;
- (void)addTarget:(id)target action:(SEL)action;
- (void)show;
- (void)hide;
- (void)reset;

@end
