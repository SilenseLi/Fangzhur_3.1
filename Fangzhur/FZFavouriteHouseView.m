//
//  FZFavouriteHouseView.m
//  Fangzhur
//
//  Created by --超-- on 14/11/22.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZFavouriteHouseView.h"
#import <UIImageView+WebCache.h>
#import "FZDirectionManager.h"

@implementation FZFavouriteHouseView

- (void)drawRect:(CGRect)rect
{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 80);
}

- (void)setHouseViewWithModel:(FZHouseListModel *)listModel currentLocation:(id)currentLocation
{
    _listModel = listModel;
    _currentLocation = currentLocation;
    self.tag = listModel.houseID.integerValue;
    
    [self.houseImageView sd_setImageWithURL:[NSURL URLWithString:ImageURL(listModel.house_thumb)] placeholderImage:[UIImage imageNamed:@"tp"]];
    
    if (listModel.piancha.integerValue >= 0) {
        self.housePriceLabel.textColor = kDefaultColor;
    }
    else {
        self.housePriceLabel.textColor = [UIColor greenColor];
    }
    self.housePriceLabel.text = listModel.house_price;
    self.houseInfoLabel.text = listModel.houseInfo;
    
    CLLocation *houseLocation = [[CLLocation alloc] initWithLatitude:listModel.lng.doubleValue
                                                           longitude:listModel.lat.doubleValue];
    if (currentLocation && listModel.lng) {
        self.houseLocationLabel.text = [FZDirectionManager bearingToLocationFromCoordinate:currentLocation toCoordinate:houseLocation];
    }
    else {
        self.houseLocationLabel.text = @"";
    }
}

@end
