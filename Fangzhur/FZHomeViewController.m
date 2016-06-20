//
//  FZHomeViewController.m
//  Fangzhur
//
//  Created by --超-- on 14/10/22.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZHomeViewController.h"
#import "FZHomeCell.h"
#import <RESideMenu.h>
#import <UIViewController+RESideMenu.h>
#import <UIImageView+WebCache.h>
#import "FZSearchViewController.h"
#import "FZTagListViewController.h"
#import "FZLoginViewController.h"
#import "FZReleaseTypeViewController.h"
#import "FZContractHouseViewController.h"
#import "FZAdvertisementViewController.h"
#import "FZMobileLoginViewController.h"
#import "JCheckPhoneNumber.h"
#import "EAIntroView.h"
#import "FZPaymentTipViewController.h"
#import "FZLocationModel.h"
#import "FZContractTipViewController.h"

#define TOP_VIEW_HEIGHT 220
CLLocationCoordinate2D kCoordinate;//获取经纬度


@interface FZHomeViewController ()
<EAIntroDelegate, RESideMenuDelegate>


//底部签约按钮
@property (nonatomic, strong) UIButton *tradeButton;
@property (nonatomic, strong) FZLocationModel *locationModel;
@property (nonatomic, retain) BMKGeoCodeSearch *geoCodeSearch;

- (void)configureUI;
- (void)addTableHeaderView;
- (void)addTableFooterView;
- (void)addBottomView;

@end

@implementation FZHomeViewController

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.imageURLArray = [[NSMutableArray alloc] init];
        self.linksArray = [[NSMutableArray alloc] init];
        self.adViewsArray = [[NSMutableArray alloc] init];
        self.locationModel = [FZLocationModel model];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"guide1"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"guide1"];
        [FZGuideView GuideViewWithImage:[UIImage imageNamed:@"guide1"] atView:self.navigationController.view];
    }
    
    if (!FZUserInfoWithKey(Key_FirstLaunch)) {
        [self showIntroWithCrossDissolve];
    }
    
    [self getCurrentPosition];
    [self configureUI];
}

//TODO:暂停，重启定时器
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self configureNavigationBar];
    [self.topScrollView.animationTimer resumeTimer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.topScrollView.animationTimer pauseTimer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)configureNavigationBar
{
    FZNavigationController *navController = (FZNavigationController *)self.navigationController;
    [navController addLogoAtFrame:CGRectMake(45, 7, 30, 27)];
    [self.navigationController performSelector:@selector(addTitle:) withObject:[NSString stringWithFormat:@"    %@", FZUserInfoWithKey(Key_CityName)]];
    
    self.sideMenuViewController.delegate = self;
    [self addButtonWithImageName:@"caidan_btn"
                          target:self.sideMenuViewController
                          action:@selector(presentLeftMenuViewController)
                        position:POSLeft];
    [self addButtonWithImageName:@"sousuo" target:self action:@selector(jumpToSearchView) position:POSRight];
}

- (void)configureUI
{
    [self loadAdView];
    [self addTableFooterView];
    [self addBottomView];
    
    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addHeaderWithCallback:^{
        if (!weakSelf.topScrollView) {
            [weakSelf loadAdView];
            [weakSelf getCurrentPosition];
        }
        
        [weakSelf.tableView headerEndRefreshing];
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FZHomeCell" bundle:nil] forCellReuseIdentifier:@"FZHomeCell"];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    UIView * bgView=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2+565, SCREEN_WIDTH, 1)];
//    bgView.backgroundColor=RGBColor(248, 248, 248);
 //   [self.tableView addSubview:bgView];
} 

- (void)loadAdView
{
    //从网络加载广告位
    [[FZRequestManager manager] getHomeADImages:^(NSArray *images, NSArray *links) {
        if (images.count != 0) {
            [self.imageURLArray setArray:images];
            [self.linksArray setArray:links];
            [self addTableHeaderView];
            [self.tableView reloadData];
        }
        [self.tableView headerEndRefreshing];
    }];
}

- (void)addTableHeaderView
{
    for (int i = 0; i < self.imageURLArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, TOP_VIEW_HEIGHT + kAdjustScale);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[self.imageURLArray objectAtIndex:i]]
                     placeholderImage:[UIImage imageNamed:@"adImage1"]];
        imageView.tag = [[self.linksArray objectAtIndex:i] integerValue];
        [self.adViewsArray addObject:imageView];
    }
    [[SDImageCache sharedImageCache] clearMemory];
    
    self.topScrollView = [[FZHomeTopScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TOP_VIEW_HEIGHT + kAdjustScale) duration:4];
    self.tableView.tableHeaderView = self.topScrollView;
    
    
    __weak typeof(self) weakSelf = self;
    [self.topScrollView setContentViewAtIndex:^UIView *(NSInteger pageIndex) {
        return [weakSelf.adViewsArray objectAtIndex:pageIndex];;
    }];
    [self.topScrollView setTotalPageCount:^NSInteger {
        return weakSelf.adViewsArray.count;
    }];
    [self.topScrollView setTapActionBlock:^(NSInteger pageIndex) {
        NSLog(@"%d tapped", (int)pageIndex);
        FZAdvertisementViewController *advertisementViewController = [[FZAdvertisementViewController alloc] init];
        advertisementViewController.adID = [NSString stringWithFormat:@"%d",
                                            (int)[(UIView *)weakSelf.adViewsArray[pageIndex] tag]];
        [weakSelf.navigationController pushViewController:advertisementViewController animated:YES];
    }]; 
}

- (void)addTableFooterView
{
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 2 * (190 + kAdjustScale))];
    NSArray *titles = @[@"发布房源", @"支付房租"];
    NSArray *images = @[@"fabufangyuan1_btn", @"payh"];
    for (int i = 0; i < 2; i++) {
        UIButton *footerButton = [UIButton homeBottomButtonWithTag:i title:titles[i] imageName:images[i]];
        [footerButton addTarget:self action:@selector(footerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [containerView addSubview:footerButton];
    }
    
    
    self.tableView.tableFooterView = containerView;
}

- (void)addBottomView
{
    self.tradeButton = kBottomButtonWithName(@"签约代办");
    [self.tradeButton addTarget:self action:@selector(gotoTradeView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.tradeButton];
}

#pragma mark - 引导页 -

- (void)showIntroWithCrossDissolve
{
    EAIntroPage *page1 = [EAIntroPage page];
    page1.bgImage = [UIImage imageNamed:@"hy01.jpg"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.bgImage = [UIImage imageNamed:@"hy02.jpg"];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.bgImage = [UIImage imageNamed:@"hy03.jpg"];
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.bgImage = [UIImage imageNamed:@"hy04.jpg"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.navigationController.view.bounds
                                                   andPages:@[page1,page2,page3, page4]];
    
    [intro setDelegate:self];
    [intro showInView:self.navigationController.view animateDuration:0.0];
}

- (void)introDidFinish
{
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:Key_FirstLaunch];
}


#pragma mark - 响应事件 -

- (void)jumpToSearchView
{
    if (!FZUserInfoWithKey(Key_LoginToken)) {
        FZLoginViewController *loginViewController = [[FZLoginViewController alloc] init];
        [self presentViewController:loginViewController animated:YES completion:^{
            [JDStatusBarNotification showWithStatus:@"赶快登录来享受更多的服务吧！" dismissAfter:2 styleName:JDStatusBarStyleError];
        }];
        return;
    }
    
    FZSearchViewController *searchViewController = [[FZSearchViewController alloc] init];
    FZNavigationController *navController = [[FZNavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)gotoTradeView:(UIButton *)sender
{
    JumpToLoginIfNeeded;
    
    FZContractTipViewController * ContractTipViewControoler=[[FZContractTipViewController alloc] init];
    
    FZNavigationController * navControoler=[[FZNavigationController alloc] initWithRootViewController:ContractTipViewControoler];
    [self presentViewController:navControoler animated:YES completion:nil];
}

- (void)footerButtonClicked:(UIButton *)sender
{
    if (sender.tag == 0) {
        JumpToLoginIfNeeded;
        FZReleaseTypeViewController *typeViewController = [[FZReleaseTypeViewController alloc] init];
        [self.navigationController pushViewController:typeViewController animated:YES];
    }
    else {
        FZPaymentTipViewController *paymentTipController = [[FZPaymentTipViewController alloc] init];
        [self.navigationController pushViewController:paymentTipController animated:YES];
    }
}

#pragma mark - Table view delegate -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!FZUserInfoWithKey(Key_LoginToken)) {
        FZLoginViewController *loginViewController = [[FZLoginViewController alloc] init];
        [self presentViewController:loginViewController animated:YES completion:^{
            [JDStatusBarNotification showWithStatus:@"赶快登录来享受更多的服务吧！" dismissAfter:2 styleName:JDStatusBarStyleError];
        }];
        return;
    }
    
    FZTagListViewController *tagListViewController = [[FZTagListViewController alloc] init];
    tagListViewController.houseType = [NSString stringWithFormat:@"%d", (int)(indexPath.row + 1)];
    [self.navigationController pushViewController:tagListViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 221 + kAdjustScale;
}

#pragma mark - Table view data source -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FZHomeCell *homeCell = [tableView dequeueReusableCellWithIdentifier:@"FZHomeCell"];
    [homeCell configureCellAtRow:indexPath.row];
    
    return homeCell;
}

#pragma mark - 获取用户当前位置

- (void)getCurrentPosition
{
    [self.locationModel getCurrentLocation:^(BOOL success, CLLocation *currentLocation) {
        if (success) {
            kCoordinate = currentLocation.coordinate;
            
            [self.tableView reloadData];
            [self startReverseGeocode];
        }
        
        [self.tableView headerEndRefreshing];
    }];
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
        
        [[NSUserDefaults standardUserDefaults] setValue:[cityInfoDict objectForKey:@"URL"] forKey:Key_CityURL];
        [[NSUserDefaults standardUserDefaults] setValue:result.addressDetail.city forKey:Key_CityName];
        
        [self.navigationController performSelector:@selector(addTitle:) withObject:[NSString stringWithFormat:@"    %@", FZUserInfoWithKey(Key_CityName)]];
    }
    
    [self.tableView reloadData];
}

@end
