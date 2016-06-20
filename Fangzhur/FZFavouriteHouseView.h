//
//  FZFavouriteHouseView.h
//  Fangzhur
//
//  Created by --超-- on 14/11/22.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZHouseListModel.h"
#import <CoreLocation/CoreLocation.h>

@interface FZFavouriteHouseView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *houseImageView;
@property (weak, nonatomic) IBOutlet UILabel *houseInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *housePriceLabel;

@property (nonatomic, readonly) FZHouseListModel *listModel;
@property (nonatomic, readonly) CLLocation *currentLocation;

- (void)setHouseViewWithModel:(FZHouseListModel *)listModel currentLocation:(CLLocation *)currentLocation;

@end
