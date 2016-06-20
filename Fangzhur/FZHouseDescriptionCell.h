//
//  FZHouseDescriptionCell.h
//  Fangzhur
//
//  Created by --超-- on 14/11/22.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZHouseDetailModel.h"

@interface FZHouseDescriptionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UILabel *floorLabel;
@property (weak, nonatomic) IBOutlet UILabel *squareLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleLabel;
@property (weak, nonatomic) IBOutlet UILabel *directionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *BottomLine;

- (void)configureCellWithModel:(FZHouseDetailModel *)detailModel;

@end
