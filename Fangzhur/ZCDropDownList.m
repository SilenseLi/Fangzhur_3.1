//
//  ZCDropDownList.m
//  Fangzhur
//
//  Created by --Chao-- on 14-6-4.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "ZCDropDownList.h"

@interface ZCDropDownList ()

//用来存储list view items
@property (nonatomic, retain) NSArray *listArray;

@end

@implementation ZCDropDownList

- (id)initWithFrame:(CGRect)frame defaultTitle:(NSString *)title list:(NSArray *)listArray
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _titleButton                 = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleButton.frame           = self.bounds;
        _titleButton.backgroundColor = [UIColor clearColor];
        _titleButton.titleLabel.font = [UIFont fontWithName:kFontName size:13];
        [_titleButton setTitle:title forState:UIControlStateNormal];
        [_titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_titleButton setImage:[UIImage imageNamed:@"Fenlei"] forState:UIControlStateNormal];
        
        _titleButton.imageEdgeInsets = UIEdgeInsetsMake(3, 0, 0, 0);
        if (kScreenScale == 3) {
            _titleButton.titleEdgeInsets = UIEdgeInsetsMake(7, 4, 0, 0);
        }
        else {
            _titleButton.titleEdgeInsets = UIEdgeInsetsMake(7, 10, 0, 0);
        }
        
        [_titleButton addTarget:self action:@selector(toggleListView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_titleButton];
        
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y + frame.size.height + 25, frame.size.width + 15, 44 * self.listArray.count) style:UITableViewStylePlain];
        _listView.alpha                 = 0;
        _listView.delegate              = self;
        _listView.dataSource            = self;
        _listView.bounces               = NO;
        _listView.showsVerticalScrollIndicator = NO;
        _listView.backgroundColor       = [UIColor whiteColor];
        _listView.separatorColor        = RGBColor(230, 230, 230);
        _listView.separatorInset    = UIEdgeInsetsMake(0, 0, 0, 0);
        _listView.layer.masksToBounds   = NO;
        _listView.layer.cornerRadius    = 3;
        _listView.layer.shadowOffset    = CGSizeMake(-2, 2);
        _listView.layer.shadowRadius    = 2;
        _listView.layer.shadowOpacity   = 0.3;
        [[UIApplication sharedApplication].windows.lastObject addSubview:_listView];
        
        self.listArray = listArray;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame Image:(UIImage *)image list:(NSArray *)listArray
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _titleButton                 = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleButton.frame           = self.bounds;
        _titleButton.backgroundColor = [UIColor clearColor];
        _titleButton.titleLabel.font = [UIFont fontWithName:kFontName size:12];
        [_titleButton setTitle:[listArray objectAtIndex:0] forState:UIControlStateNormal];
        [_titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_titleButton setImage:[UIImage imageNamed:@"xiala_btn"] forState:UIControlStateNormal];
        [_titleButton setBackgroundImage:image forState:UIControlStateNormal];
        _titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        _titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0);
        [_titleButton addTarget:self action:@selector(toggleListView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_titleButton];
        
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(frame.origin.x, 64, frame.size.width + 15, 44 * self.listArray.count) style:UITableViewStylePlain];
        _listView.alpha                 = 0;
        _listView.delegate              = self;
        _listView.dataSource            = self;
        _listView.bounces               = NO;
        _listView.showsVerticalScrollIndicator = NO;
        _listView.backgroundColor       = [UIColor whiteColor];
        _listView.separatorColor        = RGBColor(230, 230, 230);
        _listView.separatorInset    = UIEdgeInsetsMake(0, 0, 0, 0);
        _listView.layer.masksToBounds   = NO;
        _listView.layer.cornerRadius    = 3;
        _listView.layer.shadowOffset    = CGSizeMake(-2, 2);
        _listView.layer.shadowRadius    = 2;
        _listView.layer.shadowOpacity   = 0.3;
        [[UIApplication sharedApplication].windows.lastObject addSubview:_listView];
        
        self.listArray = listArray;
    }
    
    return self;
}

- (void)toggleListView
{
    if (_listView.alpha == 0) {
        [self show];
        if ([_target respondsToSelector:_action]) {
            [_target performSelector:_action withObject:self];
        }
    }
    else {
        [self hide];
    }
}

- (void)addTarget:(id)target action:(SEL)action
{
    self.target = target;
    self.action = action;
}

#pragma mark - 显示 || 隐藏 下拉列表 -
- (void)show
{
    self.willShow = YES;
    [UIView animateWithDuration:0.25 animations:^{
        _listView.alpha = 1;
        CGRect frame = _listView.frame;
        frame.size.height = _listArray.count * 44;
        _listView.frame = frame;
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.25 animations:^{
        _listView.alpha = 0;
        CGRect frame = _listView.frame;
        frame.size.height = 0;
        _listView.frame = frame;
    }];
}

- (void)reset
{
    [_titleButton setTitle:[_listArray objectAtIndex:0] forState:UIControlStateNormal];
    [self hide];
}

#pragma mark - Table view delegate -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    self.willShow = NO;
    [_titleButton setTitle:[self.listArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    self.selectedIndex = indexPath.row;
    if ([_target respondsToSelector:_action]) {
        [_target performSelector:_action withObject:self];
    }
    
    [self hide];
}

#pragma mark - Table view data source -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"ListCell";
    UITableViewCell *listCell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (!listCell) {
        listCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        listCell.backgroundColor   = RGBColor(240, 240, 240);
        UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:listCell.bounds];
        cellImageView.image        = [UIImage imageNamed:@"pic_xuanzhong.png"];
        [listCell.selectedBackgroundView addSubview:cellImageView];
    }
    
    listCell.textLabel.text = [self.listArray objectAtIndex:indexPath.row];
    listCell.textLabel.font = [UIFont systemFontOfSize:14];
    listCell.textLabel.textAlignment = NSTextAlignmentCenter;
    return listCell;
}

@end
