//
//  FZRSelfHelperTableView.h
//  SelfBusiness
//
//  Created by --Chao-- on 14-6-9.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZRSelfHelperTableView : UITableView
<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) NSString *serviceContent;
@property (nonatomic, retain) NSArray *serviceProcedures;
@property (nonatomic, retain) NSArray *servicePrices;
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;

- (void)addTarget:(id)target action:(SEL)action;
- (void)UIConfig;

@end
