//
//  FZChooseTagView.h
//  Fangzhur
//
//  Created by --超-- on 14/11/17.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZChooseTagView : UIScrollView

@property (nonatomic, readonly) NSMutableArray *selectedTags;
@property (nonatomic, strong) UIButton *startButton;

- (void)addTags:(NSArray *)tags;

@end
