//
//  FZHouseDetailViewController.m
//  Fangzhur
//
//  Created by --超-- on 14/11/21.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZHouseDetailViewController.h"
#import "MJRefresh.h"
#import "FZHouseDescriptionCell.h"
#import "FZHouseEstablishmentCell.h"
#import "FZHouseLocationCell.h"
#import "FZFavouriteCell.h"
#import "FZCommentListCell.h"
#import "FZDetailCommentTagCell.h"
#import "FZLocationModel.h"
#import <CoreLocation/CoreLocation.h>
#import "FZMapViewController.h"
#import "MRFlipTransition.h"
#import "FZPopupView.h"
#import "RDRStickyKeyboardView.h"
#import "FZCommentModel.h"
#import "FZCommentViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "FZAppDelegate.h"
#import "FZMessageViewController.h"
#import "FZLoginViewController.h"
#import "FZMobileLoginViewController.h"
#import "FZSignHouseViewController.h"
#import "FZHouseListViewController.h"
#import "DataBaseManager.h"
#import "FZLocationNotification.h"
#import "IQKeyboardManager.h"

#define DynamicLabelSizeOf(string)\
[string sizeWithFont:[UIFont fontWithName:kFontName size:15] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, 999) lineBreakMode:NSLineBreakByWordWrapping]

@interface FZHouseDetailViewController ()
{
    dispatch_once_t predicate;
}

@property (nonatomic, strong) FZLocationModel *locationModel;
@property (nonatomic, strong) CLLocation *currentLocation;

@property (nonatomic, strong) MRFlipTransition *flipTransition;
@property (nonatomic, strong) RDRStickyKeyboardView *commentBoard;

@property (nonatomic, strong) FZHouseLocationCell *locationCell;
@property (nonatomic, strong) FZFavouriteCell *favouriteCell;
@property (nonatomic, strong) FZWaitingView *waitingView;

@property (nonatomic, weak) FZAppDelegate *appDelegate;

- (void)configureUI;
- (void)getCurrentLocation;
- (void)requestForHouseDetailInfo;
- (void)checkNewMessage;
- (void)requestForLimitCounter;

- (void)gotoSeeTheHouse;
- (void)gotoCommentTheHouse;

- (void)payAttentionToTheHouse;

@end

@implementation FZHouseDetailViewController

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.detailModel = [[FZHouseDetailModel alloc] init];
        self.appDelegate = (FZAppDelegate *)[UIApplication sharedApplication].delegate;
        
        if ([FZUserInfoWithKey(Key_LocationPush) isEqualToString:@"YES"]) {
            UILocalNotification *notification = [FZLocationNotification openLocationPush];
            if ([[NSDate date] timeIntervalSinceDate:notification.fireDate] >= 7 * 24 * 3600) {
                [FZLocationNotification closeLocationPush];
                [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:Key_LocationPush];
            }
        }
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureUI];
    [self requestForHouseDetailInfo];
    [self requestForLimitCounter];
    [self getCurrentLocation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController performSelector:@selector(addTitle:) withObject:@"房源详情"];
    [self addButtonWithImageName:@"fanhui" target:self action:@selector(popViewController) position:POSLeft];
    [self addButtonWithImageName:@"lianjie" target:self action:@selector(shareTheHouse) position:POSRight];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [FZPopupView viewWillDisappear];
    [self.commentBoard hideKeyboard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureUI
{
    [IQKeyboardManager sharedManager].enable = NO;
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"guide3"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"guide3"];
        [FZGuideView GuideViewWithImage:[UIImage imageNamed:@"guide3"] atView:[UIApplication sharedApplication].keyWindow];
    }
    
    self.flipTransition = [[MRFlipTransition alloc] initWithPresentingViewController:self];
    [self addBottomButton];
    
    self.headerView = [[[NSBundle mainBundle] loadNibNamed:@"FZHouseDetailHeader" owner:self options:nil] lastObject];
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(self.headerView.frame) + kAdjustScale);
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
    [self registerCells];
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    
    self.waitingView = [[FZWaitingView alloc] init];
    [self.view addSubview:self.waitingView];
    
    //评论、私信句柄
    __block typeof(self) weakSelf = self;
    [self.headerView setGotoChatHandler:^(UIButton *sender) {
        if (sender.tag == 0) {
            FZCommentViewController *commentViewController = [[FZCommentViewController alloc] init];
            commentViewController.houseID = weakSelf.detailModel.houseID;
            commentViewController.houseType = weakSelf.houseType;
            FZNavigationController *navController = [[FZNavigationController alloc] initWithRootViewController:commentViewController];

            [weakSelf presentViewController:navController animated:YES completion:nil];
        }
        else {
            if ([FZUserInfoWithKey(Key_RoleType) intValue] == 4) {
                [JDStatusBarNotification showWithStatus:@"您没有访问权限!" dismissAfter:2 styleName:JDStatusBarStyleError];
                return ;
            }
            
            FZMessageViewController *messageViewController = [[FZMessageViewController alloc] init];
            messageViewController.detailModel = weakSelf.detailModel;
            [weakSelf.navigationController pushViewController:messageViewController animated:YES];
            
            [weakSelf payAttentionToTheHouse];
        }
    }];
}

- (void)setupCommentBoard
{
    self.commentBoard = [[RDRStickyKeyboardView alloc] initWithScrollView:nil];
    self.commentBoard.frame = self.view.bounds;
    [self.commentBoard.inputView.rightButton addTarget:self action:@selector(didTapSend) forControlEvents:UIControlEventTouchUpInside];
    [self.commentBoard.inputView.leftButton addTarget:self action:@selector(didTapCancel) forControlEvents:UIControlEventTouchUpInside];
    self.commentBoard.hidden = YES;
    [self.view addSubview:self.commentBoard];
}

- (void)addBottomButton
{
    self.seeHouseButton = kBottomButtonWithName(@"联系房主");
    [self.seeHouseButton setTitle:@"您已经用完今天的查看权限" forState:UIControlStateDisabled];
    [self.seeHouseButton addTarget:self action:@selector(gotoSeeTheHouse) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.seeHouseButton];
    
    UIButton *commentButton = [UIButton buttonWithFrame:CGRectMake(SCREEN_WIDTH - 45, 11, 30, 30) bgImage:[UIImage imageNamed:@"pinglun"]];
    [commentButton addTarget:self action:@selector(gotoCommentTheHouse) forControlEvents:UIControlEventTouchUpInside];
    [self.seeHouseButton addSubview:commentButton];
}

- (void)registerCells
{
    [self.tableView registerNib:[UINib nibWithNibName:@"FZHouseDescriptionCell" bundle:nil]
         forCellReuseIdentifier:@"FZHouseDescriptionCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FZHouseEstablishmentCell" bundle:nil]
         forCellReuseIdentifier:@"FZHouseEstablishmentCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FZHouseLocationCell" bundle:nil]
         forCellReuseIdentifier:@"FZHouseLocationCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FZFavouriteCell" bundle:nil]
         forCellReuseIdentifier:@"FZFavouriteCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FZDetailCommentTagCell" bundle:nil]
         forCellReuseIdentifier:@"FZDetailCommentTagCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FZCommentListCell" bundle:nil]
         forCellReuseIdentifier:@"FZCommentListCell"];
    
    self.favouriteCell = [self.tableView dequeueReusableCellWithIdentifier:@"FZFavouriteCell"];
    self.locationCell = [self.tableView dequeueReusableCellWithIdentifier:@"FZHouseLocationCell"];
}

- (void)getCurrentLocation
{
    self.locationModel = [FZLocationModel model];
    [self.locationModel getCurrentLocation:^(BOOL success, CLLocation *currentLocation) {
        if (!success) {
            [JDStatusBarNotification showWithStatus:@"定位服务没有打开!" dismissAfter:2 styleName:JDStatusBarStyleError];
        }
        else {
            self.currentLocation = currentLocation;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - 网络请求 -

- (void)requestForHouseDetailInfo
{
    [[FZRequestManager manager] getHouseDetailWithHouseID:self.detailModel.houseID memberID:FZUserInfoWithKey(Key_MemberID) houseType:self.houseType complete:^(NSDictionary *detailData, NSDictionary *houseInfo) {
        
        if (!detailData) {
            [self.waitingView loadingFailedWithImage:[UIImage imageNamed:@"loadFailed"] handler:^{
                [self requestForHouseDetailInfo];
            }];
            return ;
        }
        
        [self.detailModel setValuesForKeysWithDictionary:houseInfo];
        self.detailModel.tongxiaoqu = [detailData objectForKey:@"tongxiaoqu"];
        
        // 获取新评论个数
        if ([[detailData objectForKey:@"comment_count"] intValue] != 0) {
            self.headerView.commentTag.hidden = NO;
        }
        else {
            self.headerView.commentTag.hidden = YES;
        }
        
        if ([[detailData objectForKey:@"xiaoqu"] count] != 0) {
            [self.detailModel setValuesForKeysWithDictionary:[detailData objectForKey:@"xiaoqu"]];
            self.detailModel.tupian = [detailData objectForKey:@"tupian"];
            self.detailModel.longitude = [[detailData objectForKey:@"xiaoqu"] objectForKey:@"lat"];
            self.detailModel.latitude = [[detailData objectForKey:@"xiaoqu"] objectForKey:@"lng"];
        }
        
        // Configure cell here insure that easy user interaction.
        if (self.imageURLs) {
            self.detailModel.house_thumb = self.imageURLs;
        }
        
        FZHouseDetailHeader *detailHeader = (FZHouseDetailHeader *)self.tableView.tableHeaderView;
        [detailHeader configureDetailHeaderWithModel:self.detailModel];
        
        [self.locationCell configureCellWithModel:self.detailModel];
        [self.favouriteCell addFavouriteHousesWithHouseArray:self.detailModel.tongxiaoqu
                                                   houseType:self.detailModel.houseType
                                                    tagArray:self.detailModel.tags_id
                                             currentLocation:self.currentLocation];
        
        // Chang to the view of the favourite house.
        __weak typeof(self) weakSelf = self;
        [self.favouriteCell setSelectFavouriteHouseBlock:^(FZHouseListModel *listModel) {
            FZHouseDetailViewController *detailController = [[FZHouseDetailViewController alloc] init];
            
            detailController.houselistType = weakSelf.houselistType;
            detailController.detailModel.houseType = weakSelf.detailModel.houseType;
            detailController.houseType = weakSelf.houseType;
            detailController.detailModel.tag_id = listModel.tag_id;
            detailController.detailModel.houseID = listModel.houseID;
            detailController.detailModel.houseTitle = listModel.houseInfo;
            detailController.detailModel.releaseDate = listModel.updated;
            detailController.detailModel.latitude = listModel.lng;
            detailController.detailModel.longitude = listModel.lat;
            [weakSelf.navigationController pushViewController:detailController animated:YES];
        }];
        
        // Change tag list.
        [self.favouriteCell setSelectTagHandler:^(UIButton *tagButton) {
            FZHouseListViewController *listViewController = (FZHouseListViewController *)weakSelf.navigationController.viewControllers.firstObject;
            if (![listViewController isKindOfClass:[FZHouseListViewController class]]) {
                listViewController = [[FZHouseListViewController alloc] init];
                
                listViewController.tagName = tagButton.titleLabel.text;
                [listViewController.requestArray addObject:[NSString stringWithFormat:@"%d", (int)tagButton.tag]];
                [listViewController.requestArray addObject:@"Tag"];
                listViewController.houseType = weakSelf.detailModel.houseType;
                [weakSelf.navigationController pushViewController:listViewController animated:YES];
            }
            else {
                listViewController.tagName = tagButton.titleLabel.text;
                [listViewController.requestArray removeAllObjects];
                [listViewController.requestArray addObject:[NSString stringWithFormat:@"%d", (int)tagButton.tag]];
                [listViewController.requestArray addObject:FZUserInfoWithKey(Key_MemberID)];
                [listViewController.requestArray addObject:@"Tag"];
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }
            
            
            [listViewController.tableView headerBeginRefreshing];
        }];
        
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        [self.waitingView hide];
        [self checkNewMessage];
        
        // 为了确保图片正常显示，要在这里重新请求一次房源数据
        dispatch_once(&predicate, ^{
            [self requestForHouseDetailInfo];
        });
    }];
}

- (void)requestForLimitCounter
{
    NSString *action = nil;
    if ([self.detailModel.houseType isEqualToString:@"出租"] ||
        [self.detailModel.houseType isEqualToString:@"1"]) {
        action = @"rentcounter";
    }
    else {
        action = @"sellcounter";
    }
    
    [[FZRequestManager manager] canBrowseWithAction:action houseID:self.detailModel.houseID handler:^(BOOL success, id responseObject) {
        if (!success) {//达到查询电话上限
            self.seeHouseButton.enabled = NO;
            self.seeHouseButton.titleLabel.font = [UIFont fontWithName:kFontName size:13];
        }
        else {
            self.seeHouseButton.enabled = YES;
            self.seeHouseButton.titleLabel.font = [UIFont fontWithName:kFontName size:15];
        }
    }];
}

- (void)checkNewMessage
{
    [[FZRequestManager manager] hasNewMessageOfHouseID:self.detailModel.houseID houseType:self.houseType to:FZUserInfoWithKey(Key_MemberID) complete:^(BOOL success, NSInteger messageNumber, id responseObject) {
        
        if (success && messageNumber != 0) {
            self.headerView.messageTag.hidden = NO;
        }
        else {
            self.headerView.messageTag.hidden = YES;
        }
    }];
}

- (void)payAttentionToTheHouse
{
    [[FZRequestManager manager] favouriteHouseWithType:self.detailModel.houseType action:@"collect" houseID:self.detailModel.houseID complete:^(BOOL success, id responseObject) {
        if (success) {
            self.headerView.headerLoveButton.selected = YES;
            [[DataBaseManager shareManager] addAttentionWithHouseID:self.detailModel.houseID houseType:self.detailModel.houseType userName:FZUserInfoWithKey(Key_UserName)];
        }
        else {
            self.headerView.headerLoveButton.selected = NO;
        }
    }];
}

#pragma mark - Table view delegate -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            [FZPopupView showWithModel:self.detailModel];
        }
            break;
        case 1: {
            FZMapViewController *mapViewController = [[FZMapViewController alloc] init];
            [mapViewController addMapView:self.locationCell.houseMapView.mapView
                                 fromView:self.locationCell.houseMapView];
            [self.flipTransition present:mapViewController from:MRFlipTransitionPresentingFromBottom completion:^{
                [self.locationCell.houseMapView startReverseGeocodeWithLatitude:self.detailModel.latitude
                                                                      longitude:self.detailModel.longitude];
            }];
        }
            break;
        default: {
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            return 141 + DynamicLabelSizeOf(self.detailModel.house_desc).height;
        }
        case 1:
            return 210;
        case 2:
            return 220 + (self.detailModel.tongxiaoqu.count * 80);
        default:
            return 0;
    }
}

#pragma mark - Table view data source -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.detailModel.tongxiaoqu.count == 0) {
        return 2;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    switch (indexPath.row) {
        case 0: {
            FZHouseDescriptionCell *descriptionCell = [tableView dequeueReusableCellWithIdentifier:@"FZHouseDescriptionCell"];
            [descriptionCell configureCellWithModel:self.detailModel];
            cell = descriptionCell;
        }
            break;
        case 1: {
            cell = self.locationCell;
        }
            break;
        case 2: {
            cell = self.favouriteCell;
        }
            break;
        default:
            break;
    }
    
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    return cell;
}

#pragma mark - 响应事件 -

- (void)shareTheHouse
{
    //我在无中介找房神器—房主儿网上看到了一条房东房源， 在 永定门，新奥洋房，租金3700 元/月，1室1厅1卫，点击链接，查看房源详情，直接联系房主。
    NSString *URLString = nil;
    if ([_houseType isEqualToString:@"2"]) {
        URLString = [NSString stringWithFormat:@"http://www.fangzhur.com/wap/saledetail.php?id=%@", self.detailModel.houseID];
    }
    else {
        URLString = [NSString stringWithFormat:@"http://www.fangzhur.com/wap/rentdetail.php?id=%@", self.detailModel.houseID];
    }
    NSString *text = [NSString stringWithFormat:
                       @"我在无中介找房神器—房主儿网上看到了一条房东房源，在%@，%@， 点击链接，查看房源详情，直接联系房主。",
                       self.headerView.headerAddrLabel.text, self.headerView.headerPriceLabel.text];
    [self gotoShareContent:[NSString stringWithFormat:@"%@\n%@", text, URLString]];
}

- (void)gotoShareContent:(NSString *)content
{
    [ShareSDK ssoEnabled:NO];
    NSArray *shareList = [NSArray arrayWithObjects:
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:22],
                          [NSNumber numberWithInt:23],
                          [NSNumber numberWithInt:24],
                          [NSNumber numberWithInt:19],
                          [NSNumber numberWithInt:37], nil];
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"Icon-76" ofType:@"png"];
    id<ISSCAttachment> imageAttach = [ShareSDK imageWithPath:imagePath];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:_appDelegate.viewDelegate];
    
    //创建容器
    id<ISSContainer> container = [ShareSDK container];
    //创建内容
    id<ISSContent> contentObj = [ShareSDK content:content
                                   defaultContent:@"来自房主儿网"
                                            image:imageAttach
                                            title:@"房主儿网"
                                              url:@"http://www.fangzhur.com"
                                      description:nil
                                        mediaType:SSPublishContentMediaTypeText];
    
    id<ISSShareOptions> shareViewOptions = [ShareSDK defaultShareOptionsWithTitle:@"房源分享"
                                                                  oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                                   qqButtonHidden:NO
                                                            wxSessionButtonHidden:NO
                                                           wxTimelineButtonHidden:NO
                                                             showKeyboardOnAppear:NO
                                                                shareViewDelegate:_appDelegate.viewDelegate
                                                              friendsViewDelegate:_appDelegate.viewDelegate
                                                            picViewerViewDelegate:nil];
    
    //显示分享选择菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:contentObj
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:shareViewOptions
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSPublishContentStateSuccess)
                                {
                                    [[FZRequestManager manager] markAShareWithHouseID:self.detailModel.houseID houseType:self.detailModel.houseType];
                                    
                                    NSString *msg = nil;
                                    switch (type)
                                    {
                                        case ShareTypeAirPrint:
                                            msg = NSLocalizedString(@"TEXT_PRINT_SUC", @"打印成功");
                                            break;
                                        case ShareTypeCopy:
                                            msg = NSLocalizedString(@"TEXT_COPY_SUC", @"拷贝成功");
                                            break;
                                        default:
                                            break;
                                    }
                                    
                                    if (msg)
                                    {
                                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TEXT_TIPS", @"提示")
                                                                                            message:msg
                                                                                           delegate:nil
                                                                                  cancelButtonTitle:NSLocalizedString(@"TEXT_KNOW", @"知道了")
                                                                                  otherButtonTitles: nil];
                                        [alertView show];
                                    }
                                }
                            }];
}

- (void)gotoSeeTheHouse
{
    if ([FZUserInfoWithKey(Key_MemberID) isEqualToString:self.detailModel.broker_id]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"亲爱的房主儿网用户，这是您自己发布的房源哦!" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    //TODO:第三方登录状态下完善信息后可直接查看业主电话
    if ([FZUserInfoWithKey(Key_BindingTag) isEqualToString:@"Unbind"]) {
        [JDStatusBarNotification showWithStatus:@"使用手机号码登录后才能查看业主电话哦！" dismissAfter:3];
        
        FZMobileLoginViewController *loginViewController = [[FZMobileLoginViewController alloc] init];
        loginViewController.title = @"手机登录";
        [self presentViewController:loginViewController animated:YES completion:nil];
    }
    else if ([FZUserInfoWithKey(Key_RoleType) integerValue] == 4) {
        [JDStatusBarNotification showWithStatus:@"您没有相应权限!" dismissAfter:2 styleName:JDStatusBarStyleError];
    }
    else {
        FZSignHouseViewController *signViewController = [[FZSignHouseViewController alloc] init];
        signViewController.houseType = self.detailModel.houseType;
        signViewController.houseNumber = self.detailModel.house_no;
        signViewController.detailModel = self.detailModel;
        [self.navigationController pushViewController:signViewController animated:YES];
        
        [self payAttentionToTheHouse];
    }
}

- (void)gotoCommentTheHouse
{
    //顾问不可以发布评论, 只可以回复
    if ([FZUserInfoWithKey(Key_RoleType) intValue] == 4) {
        [JDStatusBarNotification showWithStatus:@"您没有相应权限" dismissAfter:2 styleName:JDStatusBarStyleError];
        return;
    }
    if (!self.commentBoard) {
        [self setupCommentBoard];
    }
    
    self.commentBoard.hidden = NO;
    [self.commentBoard showKeyboard];
}

- (void)didTapSend
{
    [self.commentBoard hideKeyboard];
    self.commentBoard.hidden = YES;
    
    [[FZRequestManager manager] sendComment:self.commentBoard.inputView.textView.text withHouseID:self.detailModel.houseID houseType:self.houseType complete:^(BOOL success) {
        if (success) {
            [JDStatusBarNotification showWithStatus:@"评论成功" dismissAfter:2 styleName:JDStatusBarStyleDark];
        }
    }];
    
    [self.commentBoard clearTextView];
}

- (void)didTapCancel
{
    [self.commentBoard hideKeyboard];
    self.commentBoard.hidden = YES;
}

- (void)headerRefreshing
{
    self.tableView.footerHidden = NO;
    self.tableView.tableHeaderView = self.headerView;
    [self requestForHouseDetailInfo];
}

- (void)popViewController
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
