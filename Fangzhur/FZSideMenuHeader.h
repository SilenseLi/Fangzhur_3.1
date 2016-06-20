//
//  FZSideMenuHeader.h
//  Fangzhur
//
//  Created by --超-- on 14/11/1.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZSideMenuHeader : UIView

@property (nonatomic, assign, readonly) id target;
@property (nonatomic, assign, readonly) SEL action;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *headerImage;

- (instancetype)initWithTarget:(id)target action:(SEL)action;

@end
