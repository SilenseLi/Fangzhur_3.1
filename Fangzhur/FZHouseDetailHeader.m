//
//  FZHouseDetailHeader.m
//  Fangzhur
//
//  Created by --超-- on 14/11/22.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZHouseDetailHeader.h"
#import <UIImageView+WebCache.h>
#import "DataBaseManager.h"

#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface FZHouseDetailHeader ()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) NSMutableArray *photos;

@end

@implementation FZHouseDetailHeader

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.headerScrollView = [[FZHomeTopScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 220 + kAdjustScale) duration:4];
        [self insertSubview:self.headerScrollView atIndex:0];
        self.bgImageView = [[UIImageView alloc] initWithFrame:self.headerScrollView.bounds];
        self.bgImageView.image = [UIImage imageNamed:@"adImage1"];
        [self insertSubview:self.bgImageView atIndex:0];
        
        self.imageViews = [[NSMutableArray alloc] init];
        self.photos = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)configureDetailHeaderWithModel:(FZHouseDetailModel *)detailModel
{
    [self.imageViews removeAllObjects];
    [self.photos removeAllObjects];
    
    self.detailModel = detailModel;
    __weak typeof(self) weakSelf = self;
    
    // 添加轮播图
    self.imageURLs = detailModel.tupian;
    for (NSString *imageURL in self.imageURLs) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.headerScrollView.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView sd_setImageWithURL:[NSURL URLWithString:ImageURL(imageURL)]
                     placeholderImage:[UIImage imageNamed:@"adImage1"]];
        
        [self.imageViews addObject:imageView];
    }
    
    // 没有图片的时候禁用滑动手势
    if (self.imageViews.count == 0) {
        self.headerScrollView.userInteractionEnabled = NO;
    }
    else {
        [self.headerScrollView setTotalPageCount:^NSInteger {
            return weakSelf.detailModel.tupian.count;
        }];
        [self.headerScrollView setContentViewAtIndex:^UIView* (NSInteger pageIndex) {
            return [weakSelf.imageViews objectAtIndex:pageIndex];
        }];
        [self.headerScrollView setTapActionBlock:^(NSInteger pageIndex) {
            NSLog(@"%d tapped", (int)pageIndex);
            if (detailModel.tupian.count == 0) {
                //没有图片
                return ;
            }
            
            if (weakSelf.photos.count == 0) {
                for (int i = 0; i < weakSelf.imageURLs.count; i++) {
                    MJPhoto *photo = [[MJPhoto alloc] init];
                    photo.url = [NSURL URLWithString:ImageURL([weakSelf.imageURLs objectAtIndex:i])]; // 图片路径
                    photo.srcImageView = [weakSelf.imageViews objectAtIndex:i]; // 来源于哪个UIImageView
                    [weakSelf.photos addObject:photo];
                }
            }
            
            MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
            browser.currentPhotoIndex = pageIndex; // 弹出相册时显示的第一张图片是？
            browser.photos = weakSelf.photos; // 设置所有的图片
            [browser show];
            
            weakSelf.bgImageView.hidden = YES;
        }];
    }
    
    /////////////////////////////////////////
                                    /////////////////////////////////////////
    
    if (detailModel.piancha.integerValue >= 0) {
        self.headerPriceLabel.textColor = kDefaultColor;
    }
    else {
        self.headerPriceLabel.textColor = [UIColor greenColor];
    }
    
    if ([[DataBaseManager shareManager] isAttentionWithHouseID:detailModel.houseID houseType:detailModel.houseType userName:FZUserInfoWithKey(Key_UserName)]) {
        self.headerLoveButton.selected = YES;
    }
    
    self.headerPriceLabel.text = detailModel.house_price;
    self.headerAddrLabel.text = detailModel.houseInfo;
    self.headerDateLabel.text = detailModel.releaseDate;
    self.headerValidDateLabel.text = detailModel.canlive;
    self.headerMasterLabel.text = detailModel.owner_name;
    
    NSString *houseType = nil;
    if ([detailModel.houseType isEqualToString:@"1"]) {
        houseType = @"出租";
    }
    else {
        houseType = @"出售";
    }
    if (detailModel.house_type) {
        self.headerHouseTypeLabel.text = [NSString stringWithFormat:@"%@ / %@", houseType, detailModel.house_type];
    }
    else {
        self.headerHouseTypeLabel.text = houseType;
    }
    
    //添加标签
    for (int i = 0; i < MIN(2, detailModel.tag_id.count); i++) {
        UILabel *tagLabel = (UILabel *)[self viewWithTag:(100 + i)];
        NSString *tagID = [detailModel.tag_id objectAtIndex:i];
        if (tagID) {
            tagLabel.hidden = NO;
            tagLabel.text = [FZUserInfoWithKey(Key_TagDictionary) objectForKey:tagID];
        }
    }
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
        [[FZRequestManager manager] favouriteHouseWithType:self.detailModel.houseType action:@"collect" houseID:self.detailModel.houseID complete:^(BOOL success, id responseObject) {
            if (success) {
                [[DataBaseManager shareManager] addAttentionWithHouseID:self.detailModel.houseID houseType:self.detailModel.houseType userName:FZUserInfoWithKey(Key_UserName)];
            }
            else {
                sender.selected = NO;
            }
        }];
    }
    else {
        [[FZRequestManager manager] favouriteHouseWithType:self.detailModel.houseType action:@"qxcollect" houseID:self.detailModel.houseID complete:^(BOOL success, id responseObject) {
            if (success) {
                [[DataBaseManager shareManager] cancelAttentionWithHouseID:self.detailModel.houseID houseType:self.detailModel.houseType userName:FZUserInfoWithKey(Key_UserName)];
            }
            else {
                sender.selected = YES;
            }
        }];
    }
}

- (IBAction)communicationButtonClicked:(UIButton *)sender
{
    if (sender.tag == 1) {
        self.messageTag.hidden = YES;
    }
    
    self.gotoChatHandler(sender);
}


@end
