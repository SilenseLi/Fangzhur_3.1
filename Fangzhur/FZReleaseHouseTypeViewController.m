//
//  FZReleaseHouseTypeViewController.m
//  Fangzhur
//
//  Created by --超-- on 14/11/28.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZReleaseHouseTypeViewController.h"
#import "FZReleaseHouseViewController.h"

@interface FZReleaseHouseTypeViewController ()

@property (nonatomic, strong) NSArray *dataArray;

- (void)configureUI;

@end

@implementation FZReleaseHouseTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataArray = @[@"住宅", @"公寓", @"别墅", @"ZhuZhai", @"Gongyu", @"BieShu", @"1", @"10", @"2"];
    
    [self configureUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureUI
{
    if ([self.releaseType isEqualToString:@"1"]) {
        self.title = @"出租";
    }
    else {
        self.title = @"出售";
    }
    
    [self addTipLabelWithHeight:(SCREEN_HEIGHT - 240 - 64) tipString:@"为您的房子选择物业类型"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HouseTypeCell"];
}

#pragma mark - Table view delegate -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    FZReleaseHouseViewController *releaseViewController = [[FZReleaseHouseViewController alloc] initWithReleaseType:self.releaseType houseType:[NSString stringWithFormat:@"%d", selectedCell.tag]];
    [self.navigationController pushViewController:releaseViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark - Table view data source -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HouseTypeCell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage imageNamed:[self.dataArray objectAtIndex:(3 + indexPath.row)]];
    cell.textLabel.text = [self.dataArray objectAtIndex:(indexPath.row)];
    cell.tag = [[self.dataArray objectAtIndex:(6 + indexPath.row)] integerValue];
    
    return cell;
}

#pragma mark - Response event -

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
