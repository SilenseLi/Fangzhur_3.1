//
//  FZHouseMapView.m
//  Fangzhur
//
//  Created by --超-- on 14/11/24.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZHouseMapView.h"

@interface FZHouseMapView ()
{
    BMKAnnotationView* newAnnotation;
}

@property (nonatomic, strong) BMKGeoCodeSearch *geoCodeSearch;
@property (nonatomic, strong) BMKPointAnnotation *pointAnnotation;
@property (nonatomic, assign) CLLocationCoordinate2D houseLocation;

@end

@implementation FZHouseMapView

- (void)awakeFromNib
{
    [self createMapView];
}

- (void)dealloc
{
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
}

- (void)layoutSubviews
{
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.layer.borderWidth = 0.5;
    
    [super layoutSubviews];
}

- (void)createMapView
{
    self.mapView                   = [[BMKMapView alloc] initWithFrame:
                                      CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.mapView.showMapScaleBar   = NO;
    self.mapView.showsUserLocation = NO;
    self.mapView.rotateEnabled     = NO;
    self.mapView.mapType           = BMKMapTypeStandard;
    self.mapView.delegate          = self;
    self.mapView.maxZoomLevel      = 18;
    self.mapView.minZoomLevel      = 10;
    self.mapView.zoomLevel         = 15;
    self.mapView.zoomEnabledWithTap     = NO;
    self.mapView.userInteractionEnabled = NO;
    [self addSubview:_mapView];
    
    [self.mapView viewWillAppear];
}

#pragma mark - 反编码

- (void)startReverseGeocodeWithLatitude:(NSString *)latitude longitude:(NSString *)longitude
{
    if (!self.geoCodeSearch) {
        self.geoCodeSearch          = [[BMKGeoCodeSearch alloc] init];
        self.geoCodeSearch.delegate = self;
    }
    
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){[latitude floatValue], [longitude floatValue]};
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    
    BOOL flag = [_geoCodeSearch reverseGeoCode:reverseGeocodeSearchOption];
    flag ? NSLog(@"反geo检索发送成功") : NSLog(@"反geo检索发送失败");
}

//获取当前房源位置
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        _address = result.address;
        self.houseLocation = result.location;
        self.reverseEgocodeBlock(result.address);
        
        [self.mapView removeAnnotation:self.pointAnnotation];
        self.pointAnnotation = [[BMKPointAnnotation alloc] init];
        self.pointAnnotation.coordinate = result.location;
        self.pointAnnotation.title = self.address;
        [self.mapView addAnnotation:self.pointAnnotation];
        
        [self resetMapView];
    }
    else {
        self.reverseEgocodeBlock(@"位置信息获取失败!");
    }
}

- (void)resetMapView
{
    self.mapView.centerCoordinate = self.houseLocation;
    
    // 完成缩放效果 18
    if (self.mapView.zoomLevel == 18) {
        self.mapView.zoomLevel = 15;
    }
}

#pragma mark - 标注 -

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"renameMark";
    
    if (newAnnotation == nil) {
        newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)newAnnotation).pinColor = BMKPinAnnotationColorRed;
        ((BMKPinAnnotationView*)newAnnotation).animatesDrop = NO;
        ((BMKPinAnnotationView*)newAnnotation).draggable = NO;
        ((BMKPinAnnotationView*)newAnnotation).enabled = NO;
    }
    
    return newAnnotation;
}

// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    NSLog(@"paopaoclick");
}

@end
