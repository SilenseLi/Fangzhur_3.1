//
//  FZRSelfHelperViewController.m
//  SelfBusiness
//
//  Created by --Chao-- on 14-6-9.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZRSelfHelperViewController.h"
#import "FZDefaultTopView.h"
#import "FZRSelfHelperTableView.h"

@interface FZRSelfHelperViewController ()
{
    FZHistoryTopMenu *_topView;
    NSDictionary *_dataDict;
    NSString *_houseType;
}

- (void)UIConfig;

@end

@implementation FZRSelfHelperViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self UIConfig];
    _dataDict = [[NSDictionary alloc] initWithDictionary:[ZCReadFileMethods dataFromPlist:@"SelfHelperData" ofType:Dictionary]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.navigationController performSelector:@selector(addTitle:) withObject:@"交易流程"];
    [self addButtonWithImageName:@"fanhui" target:self action:@selector(dismissViewController) position:POSLeft];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 界面布局 -

- (void)UIConfig
{
    _topView = [[FZHistoryTopMenu alloc] init];
    _topView.titleArray = [NSArray arrayWithObjects:@"租赁代办", @"买卖代办", nil];
    [_topView addTarget:self action:@selector(changeChannel:)];
    [_topView installMenuInView:self.view];
    
    [self reverseTableView];
    self.tableView.frame = CGRectMake(0, 44 + 64, SCREEN_WIDTH, SCREEN_HEIGHT - 100);
}

- (void)changeChannel:(UIButton *)sender
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]
                          atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    _houseType = [NSString stringWithFormat:@"%d", sender.tag + 1];
}

#pragma mark - Table view delegate -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_WIDTH;
}

#pragma mark - Table view data source -

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        [_topView changeSelectedItem:0];
        _houseType = @"1";
    }
    else {
        [_topView changeSelectedItem:1];
        _houseType = @"2";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    CGRect cellFrame = cell.frame;
    cellFrame.size.width = tableView.frame.size.width;
    cell.frame = cellFrame;
    cell.transform = CGAffineTransformMakeRotation(M_PI / 2);
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    FZRSelfHelperTableView *helperView = [[FZRSelfHelperTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 100)
                                                                                 style:UITableViewStyleGrouped];
    [helperView addTarget:self action:@selector(dismissViewController)];
    
    if (indexPath.row == 0) {//租赁代办
        helperView.serviceContent = [[_dataDict objectForKey:@"Rent"] objectAtIndex:0];
        helperView.serviceProcedures = [[_dataDict objectForKey:@"Rent"] objectAtIndex:1];
        helperView.servicePrices = [[_dataDict objectForKey:@"Rent"] objectAtIndex:2];
    }
    else {//买卖代办
        helperView.serviceContent = [[_dataDict objectForKey:@"Sale"] objectAtIndex:0];
        helperView.serviceProcedures = [[_dataDict objectForKey:@"Sale"] objectAtIndex:1];
        helperView.servicePrices = [[_dataDict objectForKey:@"Sale"] objectAtIndex:2];
    }
    
    [helperView UIConfig];
    [cell.contentView addSubview:helperView];
    return cell;
}

#pragma mark - Response events -

- (void)dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
