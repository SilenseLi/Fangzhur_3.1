//
//  FZSideMenuCell.m
//  Fangzhur
//
//  Created by --超-- on 14/10/31.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZSideMenuCell.h"

@implementation FZSideMenuCell

- (void)awakeFromNib
{
}

- (void)drawRect:(CGRect)rect
{
    // 设置一个透明的选中背景，可以在满足显示样式的同时，还能不影响响应速度，
    // 如果选中样式设置为none，可能会产生延迟
    UIView *selectedView = [[UIView alloc] initWithFrame:self.bounds];
    selectedView.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = selectedView;
}

- (void)dealloc
{
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:Key_NewMessage];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)configureRow:(NSInteger)row WithData:(NSDictionary *)dict
{
    NSString *imageName      = [[dict objectForKey:@"ImageName"] objectAtIndex:row];
    self.cellImageView.image = [UIImage imageNamed:imageName];
    self.cellNameLabel.text  = [[dict objectForKey:@"Title"] objectAtIndex:row];
    
    __block NSString *newMessageNumber = [[NSUserDefaults standardUserDefaults] objectForKey:Key_NewMessage];
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        [[NSUserDefaults standardUserDefaults] addObserver:self
                                                forKeyPath:Key_NewMessage
                                                   options:NSKeyValueObservingOptionNew
                                                   context:NULL];
    });
    [[FZRequestManager manager] getMessageNumber:^(NSString *newMessageNum) {
        newMessageNumber = newMessageNum;
        [[NSUserDefaults standardUserDefaults] setObject:newMessageNum forKey:Key_NewMessage];
    }];
    
    if (row != 0) {
        [self.cellBadge removeFromSuperview];
    }
    
    if (!newMessageNumber ||
        newMessageNumber.length == 0 ||
        newMessageNumber.integerValue == 0) {
        self.cellBadge.hidden = YES;
    }
    else {
        self.cellBadge.hidden = NO;
        [self.cellBadge setTitle:newMessageNumber forState:UIControlStateNormal];
    }
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    if ([[change objectForKey:@"new"] isKindOfClass:[NSNull class]] ||
        [[change objectForKey:@"new"] isEqualToString:@"0"]) {
        self.cellBadge.hidden = YES;
    }
    else {
        self.cellBadge.hidden = NO;
        [self.cellBadge setTitle:[change objectForKey:@"new"] forState:UIControlStateNormal];
    }
}

@end
