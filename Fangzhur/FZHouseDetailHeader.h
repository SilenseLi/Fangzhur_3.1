//
//  FZHouseDetailHeader.h
//  Fangzhur
//
//  Created by --超-- on 14/11/22.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZHouseDetailModel.h"
#import "FZHomeTopScrollView.h"

@interface FZHouseDetailHeader : UIView

@property (strong, nonatomic) FZHomeTopScrollView *headerScrollView;
@property (weak, nonatomic) IBOutlet UIButton *headerLoveButton;
@property (weak, nonatomic) IBOutlet UIButton *headerCommentButton;
@property (weak, nonatomic) IBOutlet UIButton *headerCommunicationButton;
@property (weak, nonatomic) IBOutlet UILabel *headerPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerTagLabel;

@property (weak, nonatomic) IBOutlet UILabel *headerAddrLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *headerValidDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerMasterLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerHouseTypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *messageTag;
@property (weak, nonatomic) IBOutlet UIImageView *commentTag;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (nonatomic, strong) FZHouseDetailModel *detailModel;
@property (nonatomic, strong) NSArray *imageURLs;
@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, copy) void (^gotoChatHandler)(UIButton *sender);

- (void)configureDetailHeaderWithModel:(FZHouseDetailModel *)detailModel;
- (IBAction)loveButtonClicked:(UIButton *)sender;
- (IBAction)communicationButtonClicked:(UIButton *)sender;

@end
