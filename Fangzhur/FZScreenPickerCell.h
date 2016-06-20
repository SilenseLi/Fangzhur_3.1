//
//  FZScreenPickerCell.h
//  Fangzhur
//
//  Created by --超-- on 14/11/9.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AKPickerView.h>

@interface FZScreenPickerCell : UITableViewCell <AKPickerViewDelegate>

@property (nonatomic, strong) AKPickerView *pickerView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSMutableArray *cacheArray;

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;

- (void)addTarget:(id)target action:(SEL)action;
- (void)updatePickerWithItems:(NSArray *)items selectedIndex:(NSInteger)selectedIndex;
- (void)addTipString:(NSString *)tipString;


@end
