//
//  FZFavouriteCell.h
//  Fangzhur
//
//  Created by --超-- on 14/11/22.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "FZHouseListModel.h"

@interface FZFavouriteCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIScrollView *tagScrollView;

@property (nonatomic, copy) void (^selectFavouriteHouseBlock)(FZHouseListModel *listModel);
@property (nonatomic, copy) void (^selectTagHandler)(UIButton *tagButton);

- (void)addFavouriteHousesWithHouseArray:(NSArray *)houseArray houseType:(NSString *)houseType tagArray:(NSArray *)tagArray currentLocation:(CLLocation *)currentLocation;

@end
