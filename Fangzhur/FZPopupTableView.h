//
//  FZPopupTableView.h
//  Fangzhur
//
//  Created by --超-- on 14/11/28.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZHouseDetailModel.h"

@interface FZPopupTableView : UITableView
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) FZHouseDetailModel *detailModel;

@end
