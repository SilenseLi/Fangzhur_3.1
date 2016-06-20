//
//  FZManagementCell.h
//  Fangzhur
//
//  Created by --超-- on 14-7-21.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZHouseDetailModel.h"

@protocol FZManagementCellDelegate;

@interface FZManagementCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *houseNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *communityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIButton *againButton;
@property (nonatomic, retain) FZHouseDetailModel *infoModel;
@property (nonatomic, assign) id<FZManagementCellDelegate> delegate;

- (IBAction)bottomButtonClicked:(UIButton *)sender;
- (void)fillDataWithType:(NSString *)type Model:(FZHouseDetailModel *)model;

@end


@protocol FZManagementCellDelegate <NSObject>

- (void)manageReleasedHouse:(NSString *)houseID selectedIndex:(NSUInteger)index;
- (void)releaseAgain:(NSString *)houseID;

@end