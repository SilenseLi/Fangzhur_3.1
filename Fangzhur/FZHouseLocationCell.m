//
//  FZHouseLocationCell.m
//  Fangzhur
//
//  Created by --超-- on 14/11/22.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZHouseLocationCell.h"
#import <UIImageView+WebCache.h>

@implementation FZHouseLocationCell

- (void)awakeFromNib {
    [self.houseMapView setReverseEgocodeBlock:^(NSString *address) {
        self.houseLocationLabel.text = address;
//        NSString *urlString = [NSString stringWithFormat:@"http://api.map.baidu.com/staticimage?center=%f,%f&width=%f&height=%f&zoom=15", self.houseMapView.mapView.centerCoordinate.longitude, self.houseMapView.mapView.centerCoordinate.latitude, CGRectGetWidth(self.houseMapView.bounds), CGRectGetHeight(self.houseMapView.bounds)];
//        NSLog(@"%@", urlString);
//        UIImageView *mapImageView = [[UIImageView alloc] initWithFrame:self.houseMapView.frame];
//        [mapImageView sd_setImageWithURL:[NSURL URLWithString:urlString]];
//        [self.contentView addSubview:mapImageView];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithModel:(FZHouseDetailModel *)detailModel
{
    [self.houseMapView startReverseGeocodeWithLatitude:detailModel.latitude longitude:detailModel.longitude];
}

@end
