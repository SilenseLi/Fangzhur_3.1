//
//  FZHouseLocationCell.h
//  Fangzhur
//
//  Created by --超-- on 14/11/22.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZHouseMapView.h"
#import "FZHouseDetailModel.h"

@interface FZHouseLocationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *houseLocationLabel;
@property (weak, nonatomic) IBOutlet FZHouseMapView *houseMapView;

- (void)configureCellWithModel:(FZHouseDetailModel *)detailModel;

@end
