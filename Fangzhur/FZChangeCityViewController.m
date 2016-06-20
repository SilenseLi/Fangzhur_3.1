//
//  FZChangeCityViewController.m
//  Fangzhur
//
//  Created by --Chao-- on 14-6-23.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZChangeCityViewController.h"
#import "UIButton+ZCCustomButtons.h"
#import "FZLocationModel.h"

extern CLLocationCoordinate2D kCoordinate;//获取经纬度

@interface FZChangeCityViewController ()
{
    NSArray *_cityArray;
    NSString *_locationCity;
}

@property (nonatomic, strong) FZLocationModel *locationModel;
@property (nonatomic, retain) BMKGeoCodeSearch *geoCodeSearch;

- (void)prepareData;
- (void)UIConfig;
- (void)getCurrentPosition;
- (void)startReverseGeocode;
- (void)doneButtonClicked;

@end

@implementation FZChangeCityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareData];
    [self UIConfig];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    _geoCodeSearch.delegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareData
{
    _cityArray    = [[NSArray alloc] initWithArray:[ZCReadFileMethods dataFromPlist:@"CityNameData" ofType:Array]];
    _locationCity = @"定位中...";
    
    self.locationModel = [FZLocationModel model];
    [self getCurrentPosition];
}

- (void)UIConfig
{
    [self addButtonWithImageName:@"fanhui" target:self action:@selector(doneButtonClicked) position:POSLeft];
    [self.tableView addHeaderWithTarget:self action:@selector(dropViewDidBeginRefreshing)];
    self.tableView.headerRefreshingText = @"定位中";
    self.tableView.headerReleaseToRefreshText = @"下拉可重新定位";
}

- (void)doneButtonClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dropViewDidBeginRefreshing
{
    [self getCurrentPosition];
}

#pragma mark - 获取用户当前位置

- (void)getCurrentPosition
{
    [self.locationModel getCurrentLocation:^(BOOL success, CLLocation *currentLocation) {
        if (success) {
            [self.tableView reloadData];
            kCoordinate = currentLocation.coordinate;
            
            [self startReverseGeocode];
        }
        else {
            _locationCity = @"定位失败!";
        }
        
        [self.tableView headerEndRefreshing];
    }];
}

//反编码获取城市信息
- (void)startReverseGeocode
{
    _geoCodeSearch          = [[BMKGeoCodeSearch alloc] init];
    _geoCodeSearch.delegate = self;
    
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){kCoordinate.latitude, kCoordinate.longitude};
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
        
        [[NSUserDefaults standardUserDefaults] setValue:[cityInfoDict objectForKey:@"URL"] forKey:@"CityURL"];
        _locationCity = result.addressDetail.city;
        [[NSUserDefaults standardUserDefaults] setObject:_locationCity forKey:Key_CityName];
	}
    else {
        _locationCity = @"位置信息获取失败";
    }
    
    [self.tableView reloadData];
}


#pragma mark - Table view delegate -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
    if ((indexPath.section == 0) ||
        (indexPath.section == 1 && [currentCell.textLabel.text isEqualToString:FZUserInfoWithKey(Key_CityName)])) {
        //信息获取失败，点击后重新获取
        if ([currentCell.textLabel.text isEqualToString:@"位置信息获取失败"]) {
            [self getCurrentPosition];
            return;
        }
    }
    else {
        NSDictionary *cityDict = [ZCReadFileMethods dataFromPlist:@"CityURLData" ofType:Dictionary];
        NSDictionary *cityInfo = [cityDict objectForKey:currentCell.textLabel.text];
        NSString *latString = [cityInfo objectForKey:@"Latitude"];
        NSString *lngString = [cityInfo objectForKey:@"Longitude"];
        kCoordinate         = CLLocationCoordinate2DMake(latString.floatValue, lngString.floatValue);
        UpdateCityURL([cityInfo objectForKey:@"URL"]);
        
        [[NSUserDefaults standardUserDefaults] setObject:currentCell.textLabel.text forKey:Key_CityName];
    }
    
    [[FZRequestManager manager] getRegionInfo];
    [[FZRequestManager manager] getSubwayInfo];
    
    UIViewController *presentingViewController = self.presentingViewController;
    [self dismissViewControllerAnimated:YES completion:^{
        [presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"当前定位城市";
    }
    return @"其他城市";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}


#pragma mark - Table view data source -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {//当前定位城市
        return 1;
    }
    else {//其他城市
        return _cityArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"CityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        cell.textLabel.font         = [UIFont systemFontOfSize:15];
    }
    
    //=========================================================
    
    if (indexPath.section == 0) {
        cell.textLabel.text = _locationCity;
    }
    else {
        cell.textLabel.text = [_cityArray objectAtIndex:indexPath.row];
    }
    
    return cell;
}

@end
