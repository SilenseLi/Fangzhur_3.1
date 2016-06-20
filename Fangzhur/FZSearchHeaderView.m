//
//  FZSearchHeaderView.m
//  Fangzhur
//
//  Created by --超-- on 14/11/7.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZSearchHeaderView.h"
#import "UIButton+ZCCustomButtons.h"
#import "FZLocationModel.h"

extern CLLocationCoordinate2D kCoordinate;//获取经纬度

@interface FZSearchHeaderView ()

@property (nonatomic, strong) UIButton *changeCityButton;
@property (nonatomic, strong) FZLocationModel *locationModel;
@property (nonatomic, retain) BMKGeoCodeSearch *geoCodeSearch;

- (void)configureUI;
- (void)getCurrentLocation;

@end

@implementation FZSearchHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self configureUI];
        
        self.locationModel = [FZLocationModel model];
        [self.locationModel getCurrentLocation:^(BOOL success, CLLocation *currentLocation) {
            if (success) {
                [self startReverseGeocode];
            }
            else {
                [JDStatusBarNotification showWithStatus:@"定位服务没有打开!" dismissAfter:2 styleName:JDStatusBarStyleError];
            }
        }];
    }
    
    return self;
}

- (void)configureUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.locateButton = [UIButton buttonWithFrame:CGRectMake(10, 0, 200, CGRectGetHeight(self.bounds)) title:[NSString stringWithFormat:@"当前位置：%@", FZUserInfoWithKey(Key_CityName)] fontSize:15 bgImageName:nil];
    [self addSubview:self.locateButton];
    [self.locateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.locateButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    self.locateButton.titleEdgeInsets = UIEdgeInsetsMake(0, -70, 0, 0);
    [self.locateButton addTarget:self action:@selector(getCurrentLocation) forControlEvents:UIControlEventTouchUpInside];
    
    self.changeCityButton = [UIButton buttonWithFrame:CGRectMake(SCREEN_WIDTH - 100, 0, 120, CGRectGetHeight(self.bounds)) title:@"切换城市" imageName:@"jiantou" bgImageName:nil];
    [self addSubview:self.changeCityButton];
    [self.changeCityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.changeCityButton.titleLabel.font = [UIFont fontWithName:kFontName size:15];
    self.changeCityButton.titleEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    self.changeCityButton.imageEdgeInsets = UIEdgeInsetsMake(0, 60, 0, 0);
    [self.changeCityButton addTarget:self action:@selector(gotoChangeCity) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(self.bounds) - 0.5, SCREEN_WIDTH - 20, 0.5)];
    lineView.backgroundColor = RGBColor(200, 200, 200);
    [self addSubview:lineView];
}

#pragma mark - 响应事件 -

- (void)getCurrentLocation
{
    [self.locationModel getCurrentLocation:^(BOOL success, CLLocation *currentLocation) {
        if (success) {
            [self.delegate searchHeaderView:self completedLocation:CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)];
            [self startReverseGeocode];
        }
        else {
            [JDStatusBarNotification showWithStatus:@"定位服务没有打开!" dismissAfter:2 styleName:JDStatusBarStyleError];
        }
    }];
    
    [self.delegate searchHeaderView:self completedLocation:CLLocationCoordinate2DMake(kCoordinate.latitude, kCoordinate.longitude)];
}

//反编码获取城市信息
- (void)startReverseGeocode
{
    _geoCodeSearch          = [[BMKGeoCodeSearch alloc] init];
    _geoCodeSearch.delegate = self;
    
    CLLocationCoordinate2D pt =
    (CLLocationCoordinate2D){self.locationModel.currentCoordinate.latitude, self.locationModel.currentCoordinate.longitude};
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    
    BOOL flag = [_geoCodeSearch reverseGeoCode:reverseGeocodeSearchOption];
    flag ? NSLog(@"反geo检索发送成功") : NSLog(@"反geo检索发送失败");
}

//获取当前城市名称, 转换城市站点
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        NSLog(@"City: %@", result.addressDetail.city);
        NSDictionary *cityDict     = [ZCReadFileMethods dataFromPlist:@"CityURLData" ofType:Dictionary];
        NSDictionary *cityInfoDict = [cityDict objectForKey:result.addressDetail.city];
        NSLog(@"CityInfo:\n%@", cityInfoDict);
        
        if ([FZUserInfoWithKey(Key_CityName) isEqualToString:result.addressDetail.city]) {
            [self.locateButton setTitle:[NSString stringWithFormat:@"当前位置：%@", result.addressDetail.city] forState:UIControlStateNormal];
        }
        else {
            kCoordinate = self.locationModel.currentCoordinate;
        }
    }
}

- (void)gotoChangeCity
{
    [self.delegate changeCityButtonClicked];
}

@end
