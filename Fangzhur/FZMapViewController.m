//
//  FZMapViewController.m
//  Fangzhur
//
//  Created by --超-- on 14/11/25.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZMapViewController.h"
#import "MRFlipTransition.h"
#import "FZHouseMapView.h"

@interface FZMapViewController () <BMKMapViewDelegate>

@property (nonatomic, strong) UIView *fromView;
@property (nonatomic, strong) BMKMapView *mapView;

@end

@implementation FZMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.mapView.userInteractionEnabled = YES;
    self.mapView.delegate = self;
    [(MRFlipTransition *)self.transitioningDelegate updateContentSnapshot:self.view afterScreenUpdate:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.mapView.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addMapView:(BMKMapView *)mapView fromView:(UIView *)view
{
    [self.view insertSubview:mapView atIndex:0];
    
    self.mapView = mapView;
    self.mapView.zoomLevel = 18;
    self.fromView = view;
}

#pragma mark - 响应事件 -

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    self.mapView.userInteractionEnabled = NO;
    self.mapView.zoomLevel = 15;
    
    [(MRFlipTransition *)self.transitioningDelegate dismissTo:MRFlipTransitionPresentingFromBottom completion:nil];
    [self.fromView insertSubview:self.mapView atIndex:0];
    [((FZHouseMapView *)self.fromView) resetMapView];
}

@end
