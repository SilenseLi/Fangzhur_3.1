//
//  FZEquipmentsSelector.h
//  Fangzhur
//
//  Created by --超-- on 14/12/1.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZEquipmentsSelector : UIView

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableDictionary *selectedItems;
@property (nonatomic, strong) NSMutableArray *cacheArray;
@property (nonatomic, copy) void (^finishedBlock)(NSString *equipmentString);

- (void)show;
- (void)dismiss;

@end
