//
//  FZScreenPickerCell.m
//  Fangzhur
//
//  Created by --超-- on 14/11/9.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZScreenPickerCell.h"


@interface FZScreenPickerCell () 

@end

@implementation FZScreenPickerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 70)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 5;
        bgView.clipsToBounds = YES;
        [self.contentView addSubview:bgView];
        
        self.pickerView = [[AKPickerView alloc] initWithFrame:bgView.bounds];
        [bgView addSubview:self.pickerView];
        self.pickerView.delegate = self;
        self.pickerView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
        self.pickerView.highlightedFont = [UIFont fontWithName:@"HelveticaNeue" size:17];
        self.pickerView.textColor = [UIColor darkGrayColor];
        self.pickerView.highlightedTextColor = RGBColor(233, 55, 72);
        self.pickerView.interitemSpacing = 20;
        self.pickerView.fisheyeFactor = 0.001;
    }
    
    return self;
}

- (void)addTarget:(id)target action:(SEL)action
{
    self.target = target;
    self.action = action;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updatePickerWithItems:(NSArray *)items selectedIndex:(NSInteger)selectedIndex
{
    self.items = nil;
    self.items = items;

    //要在加载新数据之后刷新视图，防止越界
    [self.pickerView reloadData];
    
    if (self.items.count <= selectedIndex) {
        return;
    }
    [self.pickerView selectItem:selectedIndex animated:NO];
}

- (void)addTipString:(NSString *)tipString
{
    if (!self.tipLabel) {
        self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.pickerView.frame.origin.y + self.pickerView.frame.size.height + 5, CGRectGetWidth(self.pickerView.frame), 30)];
        self.tipLabel.backgroundColor = [UIColor clearColor];
        self.tipLabel.text = tipString;
        self.tipLabel.numberOfLines = 0;
        self.tipLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.tipLabel.textAlignment = NSTextAlignmentCenter;
        self.tipLabel.font = [UIFont fontWithName:kFontName size:13];
        self.tipLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.tipLabel];
    }
}

#pragma mark - Picker view delegate -

- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView
{
    return self.items.count;
}

- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item
{
    return [self.items objectAtIndex:item];
}

- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item
{
    [self.cacheArray replaceObjectAtIndex:self.tag withObject:[NSString stringWithFormat:@"%d", (int)item]];
    
    if ([self.target respondsToSelector:self.action]) {
        [self.target performSelector:self.action withObject:self];
    }
}

@end
