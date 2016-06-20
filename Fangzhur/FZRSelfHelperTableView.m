//
//  FZRSelfHelperTableView.m
//  SelfBusiness
//
//  Created by --Chao-- on 14-6-9.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZRSelfHelperTableView.h"
#import "FZRProcedureCell.h"

@interface FZRSelfHelperTableView ()

@end

@implementation FZRSelfHelperTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)UIConfig
{
    self.backgroundColor = [UIColor clearColor];
    self.separatorColor = [UIColor clearColor];
    self.allowsSelection = NO;
    self.delegate = self;
    self.dataSource = self;
    [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ServiceContent"];
    [self registerNib:[UINib nibWithNibName:@"FZRProcedureCell" bundle:nil] forCellReuseIdentifier:@"FZRProcedureCell"];
}

- (void)addTarget:(id)target action:(SEL)action
{
    self.target = target;
    self.action = action;
}

- (void)releaseButtonClicked
{
    if ([_target respondsToSelector:_action]) {
        [_target performSelector:_action withObject:self];
    }
}

#pragma mark - Table view delegate -

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView  = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 30)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    titleLabel.center   = headerView.center;
    titleLabel.font     = [UIFont systemFontOfSize:15];
    titleLabel.backgroundColor = [UIColor clearColor];
    switch (section) {
        case 0:
            titleLabel.text = @"服务内容";
            break;
        case 1:
            titleLabel.text = @"服务流程";
            break;
        default:
            titleLabel.text = @"服务价格";
            break;
    }
    [headerView addSubview:titleLabel];
    
    ////////////////////////
    
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x - 120, headerView.center.y - 4, 120, 8)];
    leftImageView.image        = [UIImage imageNamed:@"biaot_left"];
    [headerView addSubview:leftImageView];
    UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x + 60, headerView.center.y - 4, 120, 8)];
    rightImageView.image        = [UIImage imageNamed:@"biaot_right"];
    [headerView addSubview:rightImageView];
    
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 100;
        case 1:
            return 44;
        default:
            return 200;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

#pragma mark - Table view data source -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return _serviceProcedures.count;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *currentCell = nil;
    
    switch (indexPath.section) {
        case 0:{//服务内容
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ServiceContent"];
            cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(cell.frame));
            cell.textLabel.text = _serviceContent;
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.numberOfLines = 0;
            
            currentCell = cell;
        }
        break;
        case 1:{//服务流程
            FZRProcedureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FZRProcedureCell"];
            if (indexPath.row % 2 == 0) {
                [cell fillDataWithTitle:[_serviceProcedures objectAtIndex:indexPath.row] position:POSLeft];
            }
            else {
                [cell fillDataWithTitle:[_serviceProcedures objectAtIndex:indexPath.row] position:POSRight];
            }
            
            currentCell = cell;
        }
        break;
        default:{//服务价格
            currentCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            for (int i = 0; i < _servicePrices.count; i++) {
                UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, i * 40, SCREEN_WIDTH - 40, 40)];
                priceLabel.textAlignment = NSTextAlignmentCenter;
                priceLabel.backgroundColor = [UIColor clearColor];
                NSArray *substringArray  = [[_servicePrices objectAtIndex:i] componentsSeparatedByString:@"|"];
                
                priceLabel.text = [NSString stringWithFormat:@"%@: %@", [substringArray objectAtIndex:0], [substringArray objectAtIndex:1]];
                [currentCell.contentView addSubview:priceLabel];
            }
            
            UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
            releaseButton.frame = CGRectMake(15, _servicePrices.count * 40 + 15, SCREEN_WIDTH - 30, 40);
            [releaseButton setTitle:@"返回" forState:UIControlStateNormal];
            [releaseButton setBackgroundImage:[UIImage imageNamed:@"kaishi_btn"] forState:UIControlStateNormal];
            [releaseButton addTarget:self action:@selector(releaseButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [currentCell.contentView addSubview:releaseButton];
        }
        break;
    }
    
    currentCell.backgroundColor = [UIColor clearColor];
    currentCell.contentView.backgroundColor = [UIColor clearColor];
    return currentCell;
}

@end
