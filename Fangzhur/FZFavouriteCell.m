//
//  FZFavouriteCell.m
//  Fangzhur
//
//  Created by --超-- on 14/11/22.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZFavouriteCell.h"
#import "FZFavouriteHouseView.h"

@interface FZFavouriteCell ()

@property (nonatomic, strong) NSMutableArray *houseViews;

@end

@implementation FZFavouriteCell

- (void)awakeFromNib {
    self.houseViews = [[NSMutableArray alloc] init];
    self.tagScrollView.scrollsToTop = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)addFavouriteHousesWithHouseArray:(NSArray *)houseArray houseType:(NSString *)houseType tagArray:(NSArray *)tagArray currentLocation:(CLLocation *)currentLocation
{
    for (int i = 0; i < houseArray.count; i++) {
        NSDictionary *houseInfoDict = [houseArray objectAtIndex:i];
        FZHouseListModel *listModel = [[FZHouseListModel alloc] init];
        [listModel setValue:[houseInfoDict objectForKey:@"id"] forKey:@"houseID"];
        [listModel setValue:houseType forKey:@"houseType"];
        [listModel setValuesForKeysWithDictionary:houseInfoDict];
        
        FZFavouriteHouseView *houseView = [self.contentView viewWithTag:i + 10].subviews.lastObject;
        if (!houseView) {
            houseView = [[[NSBundle mainBundle] loadNibNamed:@"FZFavouriteHouseView" owner:self options:nil] lastObject];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(houseViewSelected:)];
            [houseView addGestureRecognizer:tapGesture];
            [[self.contentView viewWithTag:i + 10] addSubview:houseView];
        }
        [houseView setHouseViewWithModel:listModel currentLocation:currentLocation];
    }
    
    for (int i = 0; i < tagArray.count; i++) {
        NSString *tagID = [tagArray objectAtIndex:i];
        UIButton *tagButton = [UIButton buttonWithFrame:CGRectMake(15 + (60 + ((SCREEN_WIDTH - 210) / 2.0f)) * i, 0, 60, 60) title:[FZUserInfoWithKey(Key_TagDictionary) objectForKey:tagID] fontSize:13 bgImageName:@"quanzi"];
        tagButton.tag = tagID.integerValue;
        [tagButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [tagButton addTarget:self action:@selector(tagButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.tagScrollView addSubview:tagButton];
    }
}

#pragma mark - Response events -

- (void)houseViewSelected:(UITapGestureRecognizer *)recognizer
{
    FZFavouriteHouseView *houseView = (FZFavouriteHouseView *)recognizer.view;
    self.selectFavouriteHouseBlock(houseView.listModel);
}

- (void)tagButtonClicked:(UIButton *)sender
{
    self.selectTagHandler(sender);
}

@end
