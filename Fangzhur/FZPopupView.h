//
//  FZPopupView.h
//  Fangzhur
//
//  Created by --超-- on 14/11/26.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZHouseDetailModel.h"
#import "FZPopupTableView.h"

@interface FZPopupView : UIView

@property (nonatomic, strong) FZPopupTableView *tableView;
@property (nonatomic, strong) UIButton *closeButton;

+ (void)viewWillDisappear;
+ (void)showWithModel:(FZHouseDetailModel *)detailModel;
+ (void)dismiss;

@end
