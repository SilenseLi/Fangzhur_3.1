//
//  FZHouseListCell.h
//  Fangzhur
//
//  Created by --超-- on 14/11/10.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "FZHouseListModel.h"

@interface FZContractListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *houseImageView;
@property (weak, nonatomic) IBOutlet UIImageView *freeTag;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *watchLabel;
@property (weak, nonatomic) IBOutlet UILabel *HouseInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UIButton *loveButton;
@property (weak, nonatomic) IBOutlet UIButton *signButton;
@property (nonatomic, readonly) FZHouseListModel *listModel;

- (IBAction)loveButtonClicked:(UIButton *)sender;
- (void)configureCellWithModel:(FZHouseListModel *)listModel location:(CLLocation *)currentLocation;

@end
