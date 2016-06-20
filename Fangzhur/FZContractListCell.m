//
//  FZHouseListCell.m
//  Fangzhur
//
//  Created by --超-- on 14/11/10.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZContractListCell.h"
#import <UIImageView+WebCache.h>
#import "FZLocationModel.h"
#import "FZDirectionManager.h"
#import "DataBaseManager.h"

@interface FZContractListCell ()

@property (nonatomic, strong) FZLocationModel *locationModel;
@property (nonatomic, copy) NSString *positionString;

@end

@implementation FZContractListCell

- (void)awakeFromNib {
    self.locationModel = [FZLocationModel model];
    self.positionString = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)loveButtonClicked:(UIButton *)sender
{
    //用户没有登录，不可以进行收藏
    if (!FZUserInfoWithKey(Key_LoginToken)) {
        [JDStatusBarNotification showWithStatus:@"赶紧登录，收藏自己喜欢的房源吧!" dismissAfter:2.5f styleName:JDStatusBarStyleError];
        return;
    }
    
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        [[FZRequestManager manager] favouriteHouseWithType:self.listModel.houseType action:@"collect" houseID:self.listModel.houseID complete:^(BOOL success, id responseObject) {
            if (success) {
                [[DataBaseManager shareManager] addAttentionWithHouseID:self.listModel.houseID houseType:self.listModel.houseType userName:FZUserInfoWithKey(Key_UserName)];
            }
            else {
                sender.selected = NO;
            }
        }];
    }
    else {
        [[FZRequestManager manager] favouriteHouseWithType:self.listModel.houseType action:@"qxcollect" houseID:self.listModel.houseID complete:^(BOOL success, id responseObject) {
            if (success) {
                [[DataBaseManager shareManager] cancelAttentionWithHouseID:self.listModel.houseID houseType:self.listModel.houseType userName:FZUserInfoWithKey(Key_UserName)];
            }
            else {
                sender.selected = YES;
            }
        }];
    }
}

- (void)configureCellWithModel:(FZHouseListModel *)listModel location:(CLLocation *)currentLocation
{
    _listModel = listModel;
    self.tag = listModel.houseID.integerValue;
    self.signButton.tag = self.tag;
    [self.signButton setTitle:listModel.house_no forState:UIControlStateDisabled];
    
    [self.houseImageView sd_setImageWithURL:[NSURL URLWithString:ImageURL(listModel.house_thumb)] placeholderImage:[UIImage imageNamed:@"adImage1"]];

    //价格偏差
    if (listModel.piancha.integerValue >= 0) {
        self.priceLabel.textColor = kDefaultColor;
    }
    else {
        self.priceLabel.textColor = [UIColor greenColor];
    }
    self.priceLabel.text = listModel.house_price;
    
    //添加标签
    for (int i = 0; i < 2; i++) {
        UILabel *tagLabel = (UILabel *)[self viewWithTag:(100 + i)];
        tagLabel.hidden = YES;
    }
    
    for (int i = 0; i < MIN(listModel.tag_id.count, 2); i++) {
        UILabel *tagLabel = (UILabel *)[self viewWithTag:(100 + i)];
        NSString *tagID = [listModel.tag_id objectAtIndex:i];
        if (tagID) {
            tagLabel.hidden = NO;
            tagLabel.text = [FZUserInfoWithKey(Key_TagDictionary) objectForKey:tagID];
            NSLog(@"%@", tagLabel.text);
        }
    }
    
    self.dateLabel.text = [NSString stringWithFormat:@"Date: %@", listModel.updated];
    self.watchLabel.text = listModel.click_num;
    self.HouseInfoLabel.text = listModel.houseInfo;
    
    if ([[DataBaseManager shareManager] isAttentionWithHouseID:self.listModel.houseID houseType:self.listModel.houseType userName:FZUserInfoWithKey(Key_UserName)]) {
        self.loveButton.selected = YES;
    }
    else {
        self.loveButton.selected = NO;
    }
    
    
    if (listModel.lng.doubleValue == 0 ||
        listModel.lat.doubleValue == 0 ||
        !currentLocation) {
        
        self.positionLabel.text = @"";
        return;
    }
    
    CLLocation *houseLocation = [[CLLocation alloc] initWithLatitude:listModel.lng.doubleValue
                                                           longitude:listModel.lat.doubleValue];
    self.positionLabel.text = [FZDirectionManager bearingToLocationFromCoordinate:currentLocation toCoordinate:houseLocation];
}

@end
