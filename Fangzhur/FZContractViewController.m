//
//  FZContractViewController.m
//  Fangzhur
//
//  Created by --超-- on 14/12/14.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZContractViewController.h"
#import "FZTextFieldCell.h"
#import "FZLabelCell.h"
#import "FZScreenPickerCell.h"
#import "CommunityNameViewController.h"
#import "FZScreenTitleLabel.h"
#import "FZRReleaseSuccessViewController.h"
#import "FZRGenerateOrderViewController.h"
#import "FZContractHouseViewController.h"
#define ShowError(string)\
[JDStatusBarNotification showWithStatus:string dismissAfter:2 styleName:JDStatusBarStyleError]

@interface FZContractViewController ()
<ChooseCommunityDelegate, FZTextFieldCellDelegate, UIAlertViewDelegate>

- (void)configureUI;
- (void)loadCommunityInfo;

@end

@implementation FZContractViewController

- (instancetype)init
{
    self = [super init];

    if (self) {
        if (!FZUserInfoWithKey(key_CityRegion)) {
            [[FZRequestManager manager] getRegionInfo];
        }
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _contractModel = [[FZContractModel alloc] initWithHouseNumber:self.houseNumber];
    
    if (self.houseNumber.length != 0) {
        [self loadCommunityInfo];
    }
    else {
        self.houseType = @"rent";
    }
    
    [self configureUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController performSelector:@selector(addTitle:) withObject:@"签约"];
    [self addButtonWithImageName:@"fanhui" target:self action:@selector(popViewController) position:POSLeft];
    
    UIButton *collectButton = [UIButton buttonWithFrame:CGRectMake(0, 0, 70, 30) title:@"个人收藏" fontSize:17 bgImageName:nil];
    collectButton.titleEdgeInsets = UIEdgeInsetsMake(5, -20, 0, 0);
    collectButton.imageEdgeInsets = UIEdgeInsetsMake(3, 35, 0, 0);
    [collectButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [collectButton addTarget:self action:@selector(collectButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:collectButton];
    self.navigationItem.rightBarButtonItem = buttonItem;
    
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if ([JDStatusBarNotification isVisible]) {
        [JDStatusBarNotification dismiss];
        [self.contractModel resetCacheArray];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureUI
{
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableView registerClass:[FZScreenPickerCell class] forCellReuseIdentifier:@"FZScreenPickerCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FZLabelCell" bundle:nil] forCellReuseIdentifier:@"FZLabelCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FZTextFieldCell" bundle:nil] forCellReuseIdentifier:@"FZTextFieldCell"];
    
    UIButton *footerButton = kFooterButtonWithName(@"提交订单");
    [footerButton addTarget:self action:@selector(submitOrder) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = footerButton;
}

#pragma mark - Table view delegate -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        CommunityNameViewController *communityController = [[CommunityNameViewController alloc] init];
        communityController.nameDelegate = self;
        FZNavigationController *navController = [[FZNavigationController alloc] initWithRootViewController:communityController];
        [self presentViewController:navController animated:YES completion:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == self.contractModel.sectionTitles.count - 1) {
        return 130;
    }
    else {
        return 70;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

//TODO:添加section title
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FZScreenTitleLabel *titleLabel = [[FZScreenTitleLabel alloc] init];
    titleLabel.font = [UIFont fontWithName:kFontName size:17];
    
    if (section == 6) {
        titleLabel.text = [NSString stringWithFormat:@"%@\n(%@元)",
                           [self.contractModel.sectionTitles objectAtIndex:section],
                           FZUserInfoWithKey(Key_UserCash)];
    }
    else if (section == 7) {
        titleLabel.text = [NSString stringWithFormat:@"%@\n(%@元)",
                           [self.contractModel.sectionTitles objectAtIndex:section],
                           FZUserInfoWithKey(Key_UserTickets)];
    }
    else {
        titleLabel.text = [self.contractModel.sectionTitles objectAtIndex:section];
    }
    
    return titleLabel;
}

#pragma mark - Table view data source -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.contractModel.sectionTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 1) {//小区名称
        FZLabelCell *labelCell = [tableView dequeueReusableCellWithIdentifier:@"FZLabelCell"];
        labelCell.tag = indexPath.section;
        labelCell.titleLabel.text = [self.contractModel.cacheArray objectAtIndex:indexPath.section];
        
        cell = labelCell;
    }
    else if ((indexPath.section == 2) ||
             (indexPath.section == 4) ||
             (indexPath.section == 5) ||
             (indexPath.section == 6) ||
             (indexPath.section == 7)) {//城区 & 服务类型 & 付款方式 & 现金 & 房码
        FZScreenPickerCell *pickerCell = [tableView dequeueReusableCellWithIdentifier:@"FZScreenPickerCell"];
        pickerCell.tag = indexPath.section;
        [pickerCell setCacheArray:self.contractModel.cacheArray];
        [pickerCell addTarget:self action:@selector(pickerCellValueChanged:)];
        
        NSArray *items = [self.contractModel contentsOfSection:[self.contractModel.sectionTitles objectAtIndex:indexPath.section]];
        NSInteger selectedIndex = [[self.contractModel.cacheArray objectAtIndex:indexPath.section] intValue];
        [pickerCell updatePickerWithItems:items selectedIndex:selectedIndex];
        pickerCell.userInteractionEnabled = YES;
        
        //现金账户没有余额，不可以进行选择
        if (indexPath.section == 6) {
            if ([FZUserInfoWithKey(Key_UserCash) intValue] == 0 ||
                [[self.contractModel.cacheArray objectAtIndex:5] intValue] == 1) {
                pickerCell.userInteractionEnabled = NO;
            }
        }
        
        // 根据服务类型决定是否可以使用房码，租赁代办不能使用
        if (indexPath.section == 7) {
            [pickerCell addTipString:@"房码可按照1:1的比例抵扣服务费用"];
            
            if ([[self.contractModel.cacheArray objectAtIndex:4] intValue] == 0 ||
                [[self.contractModel.cacheArray objectAtIndex:5] intValue] == 1 ||
                [FZUserInfoWithKey(Key_UserTickets) intValue] == 0) {
                pickerCell.userInteractionEnabled = NO;
            }
        }
        
        cell = pickerCell;
    }
    else {
        FZTextFieldCell *textFieldCell = [tableView dequeueReusableCellWithIdentifier:@"FZTextFieldCell"];
        textFieldCell.tag = indexPath.section;
        textFieldCell.cacheArray = self.contractModel.cacheArray;
        textFieldCell.delegate = self;
        textFieldCell.textField.keyboardType = UIKeyboardTypeNumberPad;
        textFieldCell.textField.placeholder = @"";
        textFieldCell.textField.text = [self.contractModel.cacheArray objectAtIndex:indexPath.section];
        
        if (indexPath.section == 3) {
            if ([[self.contractModel.cacheArray objectAtIndex:4] intValue] == 0) {
                textFieldCell.rightLabel.text = @"元/月";
            }
            else {
                textFieldCell.rightLabel.text = @"万元";
            }
        }
        else {
            [textFieldCell hideSideLabel];
        }
        
        cell = textFieldCell;
    }
    
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    return cell;
}

#pragma mark - FZTextFieldCell delegate -

- (void)textFieldCell:(FZTextFieldCell *)cell didEndEditing:(NSString *)text
{
    if (cell.tag == 0 && text.length != 0) {
        self.houseNumber = text;
        [self.contractModel.cacheArray replaceObjectAtIndex:0 withObject:text];
        [self loadCommunityInfo];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Community search delegate -

- (void)selectCommunityName:(NSString *)name communityID:(NSString *)communityID address:(NSString *)address
{
    [self.contractModel.paramDict setObject:communityID forKey:@"borough_id"];
    [self.contractModel.paramDict setObject:name forKey:@"borough_name"];
    [self.contractModel.cacheArray replaceObjectAtIndex:1 withObject:name];
    
    //自己重新选择小区后，房源编号要清空，区域归位
    self.houseNumber = @"";
    [self.contractModel.cacheArray replaceObjectAtIndex:0 withObject:@""];
    [self.contractModel.cacheArray replaceObjectAtIndex:2 withObject:@"0"];
    
    [self.tableView reloadData];
}



#pragma mark - Response events -

- (void)pickerCellValueChanged:(FZScreenPickerCell *)pickerCell
{
    //防止滚轮滑动时，滑动tableview造成的越界
    if (pickerCell.pickerView.selectedItem >= pickerCell.items.count) {
        return;
    }
    
    //如果上次的选中和该次选中相同，不进行视图刷新
    self.contractModel.selectedRegion = [pickerCell.items objectAtIndex:pickerCell.pickerView.selectedItem];
    if ([[self.contractModel.cacheArray objectAtIndex:pickerCell.tag] intValue] == pickerCell.pickerView.selectedItem) {
        return;
    }
    
    if (pickerCell.tag == 2) {
        [self.contractModel.cacheArray replaceObjectAtIndex:0 withObject:@""];
        [self.tableView reloadData];
    }
    //每次切换服务类型，房码归位
    else if (pickerCell.tag == 4) {
        if (pickerCell.pickerView.selectedItem == 0) {
            self.houseType = @"rent";
        }
        else {
            self.houseType = @"sale";
        }
        
        [self.contractModel.cacheArray replaceObjectAtIndex:6 withObject:@"0"];
        [self.contractModel.cacheArray replaceObjectAtIndex:7 withObject:@"0"];
        [self.tableView reloadData];
    }
    //线下支付不可以选用现金账户或房码
    else if (pickerCell.tag == 5) {
        [self.contractModel.cacheArray replaceObjectAtIndex:6 withObject:@"0"];
        [self.contractModel.cacheArray replaceObjectAtIndex:7 withObject:@"0"];
        [self.tableView reloadData];
    }
}

- (void)submitOrder
{
    if ([[self.contractModel.cacheArray objectAtIndex:1] isEqualToString:@"选择"]) {
        ShowError(@"请选择小区");
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        return;
    }
    else if ([[self.contractModel.cacheArray objectAtIndex:3] length] == 0) {
        ShowError(@"请填入成交价格");
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        return;
    }

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请确保您的信息已准确填入!" delegate:self cancelButtonTitle:@"再次确认" otherButtonTitles:@"下一步", nil];
    [alertView show];
    
    NSLog(@"%@", self.contractModel.cacheArray);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.contractModel loadRequestParameters];
    
    //提交订单
    if (buttonIndex == 1) {
        //线下付款，直接提交订单
        if ([[self.contractModel.cacheArray objectAtIndex:5] intValue] == 1) {
            [JDStatusBarNotification showWithStatus:@"提交订单中，请稍等..."];
            [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleWhite];
            
            [[FZRequestManager manager] releaseOrderWithParameters:self.contractModel.paramDict complete:^(BOOL success, id responseObject) {
                if (success) {
                    [JDStatusBarNotification showWithStatus:@"发布成功"];
                    
                    [self.contractModel.orderModel setValuesForKeysWithDictionary:responseObject];
                    FZRReleaseSuccessViewController * successViewController = [[FZRReleaseSuccessViewController alloc] init];
                    successViewController.orderId = self.contractModel.orderModel.jiaoy_no;
                    [self.navigationController pushViewController:successViewController animated:YES];
                }
                else {
                    ShowError(@"发布失败，请核对信息稍后重试!");
                }
            }];
        }
        //线上付款，进行下一步操作
        else {
            [self.contractModel generateOrderInfo];
            
            FZRGenerateOrderViewController *generatorController = [[FZRGenerateOrderViewController alloc] init];
            generatorController.contractModel = self.contractModel;
            [self.navigationController pushViewController:generatorController animated:YES];
        }
    }
}

- (void)collectButton:(UIButton *)btn
{
    FZContractHouseViewController * ContractHouseViewController=[[FZContractHouseViewController alloc] init];
    FZNavigationController * navController=[[FZNavigationController alloc] initWithRootViewController:ContractHouseViewController];
    [self presentViewController:navController animated:YES completion:nil];
    

}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 根据编号获取订单信息 -

- (void)loadCommunityInfo
{
    [JDStatusBarNotification showWithStatus:@"获取订单信息中，请稍后..."];
    [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.tableView.userInteractionEnabled = NO;
    
    [[FZRequestManager manager] getCommunityInfoWithHouseNumber:self.houseNumber houseType:self.houseType complete:^(BOOL success, id responseObject) {
        self.tableView.userInteractionEnabled = YES;
        if ([[self.contractModel.cacheArray objectAtIndex:0] length] == 0) {
            return ;
        }
        
        if (success && responseObject) {
            [JDStatusBarNotification showWithStatus:@"信息已更新" dismissAfter:2];
            
            [self.contractModel.paramDict setObject:[responseObject objectForKey:@"borough_id"] forKey:@"borough_id"];
            [self.contractModel.paramDict setObject:[responseObject objectForKey:@"borough_name"] forKey:@"borough_name"];
            [self.contractModel.paramDict setObject:[responseObject objectForKey:@"house_id"] forKey:@"house_id"];
            [self.contractModel.paramDict setObject:[responseObject objectForKey:@"cityarea_id"] forKey:@"cityarea_id"];
            
            [self.contractModel.cacheArray replaceObjectAtIndex:1 withObject:[responseObject objectForKey:@"borough_name"]];
            [self.contractModel.cacheArray replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%d", [self.contractModel.regionArray indexOfObject:[responseObject objectForKey:@"quyu"]]]];
        }
        else if (responseObject) {
            ShowError(@"不存在该房源编号!");
            [self.contractModel.cacheArray replaceObjectAtIndex:0 withObject:@""];
        }
        
        [self.tableView reloadData];
    }];
}

@end
