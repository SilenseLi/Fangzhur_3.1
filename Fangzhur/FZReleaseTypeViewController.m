//
//  FZReleaseTypeViewController.m
//  Fangzhur
//
//  Created by --超-- on 14/11/28.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZReleaseTypeViewController.h"
#import "FZReleaseHouseTypeViewController.h"

@interface FZReleaseTypeViewController ()

@property (nonatomic, strong) NSArray *dataArray;

- (void)configureUI;

@end

@implementation FZReleaseTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = @[@"出租", @"出售", @"ChuZu", @"ChuShou", @"1", @"2"];
    
    [self configureUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureUI
{
    [self addTipLabelWithHeight:(SCREEN_HEIGHT - 160 - 64) tipString:@"为您的房子选择发布类型"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HouseTypeCell"];
}

#pragma mark - Table view delegate -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    FZReleaseHouseTypeViewController *typeViewController = [[FZReleaseHouseTypeViewController alloc] init];
    typeViewController.releaseType = [NSString stringWithFormat:@"%d", selectedCell.tag];
    [self.navigationController pushViewController:typeViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark - Table view data source -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HouseTypeCell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage imageNamed:[self.dataArray objectAtIndex:(2 + indexPath.row)]];
    cell.imageView.contentMode = UIViewContentModeCenter;
    cell.imageView.frame = CGRectMake(0, 0, 30, 30);
    cell.textLabel.text = [self.dataArray objectAtIndex:(indexPath.row)];
    cell.tag = [[self.dataArray objectAtIndex:(4 + indexPath.row)] integerValue];
    
    return cell;
}

#pragma mark - Response event -



@end
