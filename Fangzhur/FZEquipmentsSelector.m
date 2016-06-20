//
//  FZEquipmentsSelector.m
//  Fangzhur
//
//  Created by --超-- on 14/12/1.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZEquipmentsSelector.h"
#import "FZEquipmentCell.h"

@interface FZEquipmentsSelector ()
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation FZEquipmentsSelector

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.selectedItems = [[NSMutableDictionary alloc] init];
        
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        self.hidden = YES;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 21)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont fontWithName:kFontName size:17];
        titleLabel.text = @"配套设施";
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 60, SCREEN_WIDTH - 30, 1)];
        lineView.backgroundColor = [UIColor whiteColor];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, SCREEN_HEIGHT - 70 - 60)];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerNib:[UINib nibWithNibName:@"FZEquipmentCell" bundle:nil]
             forCellReuseIdentifier:@"FZEquipmentCell"];
        
        UIButton *bottomButton = kBottomButtonWithName(@"确  认");
        [bottomButton addTarget:self action:@selector(bottomButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:bottomButton];
        [self addSubview:titleLabel];
        [self addSubview:lineView];
        [self addSubview:self.tableView];
    }
    
    return self;
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    [self.tableView reloadData];
}

- (void)show
{
    self.hidden = NO;
}

- (void)dismiss
{
    self.hidden = YES;
}

#pragma mark - Table view delegate -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.selectedItems objectForKey:[self.dataArray objectAtIndex:indexPath.row]]) {
        [self.selectedItems removeObjectForKey:[self.dataArray objectAtIndex:indexPath.row]];
    }
    else {
        [self.selectedItems setObject:[NSString stringWithFormat:@"%d", (int)(indexPath.row + 1)] forKey:[self.dataArray objectAtIndex:indexPath.row]];
    }
    
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - Table view data source -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FZEquipmentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FZEquipmentCell"];
    cell.tag = indexPath.row;
    cell.equipmentNameLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    
    if ([self.selectedItems objectForKey:[self.dataArray objectAtIndex:indexPath.row]]) {
        cell.equipmentNameLabel.textColor = kDefaultColor;
    }
    else {
        cell.equipmentNameLabel.textColor = [UIColor whiteColor];
    }
    
    return cell;
}

#pragma mark - Response events -

- (void)bottomButtonClicked:(UIButton *)sender
{
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSMutableString *paramString = [[NSMutableString alloc] init];
    
    for (NSString *key in self.selectedItems) {
        [resultString appendFormat:@"%@,", key];
    }
    if (resultString.length != 0) {
        [self.cacheArray replaceObjectAtIndex:self.tag withObject:[resultString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]]];
    }
    
    for (NSString *key in self.selectedItems) {
        [paramString appendFormat:@"%@,", [self.selectedItems objectForKey:key]];
    }
    if (paramString.length != 0) {
        self.finishedBlock([paramString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]]);
    }
    
    [self dismiss];
}

@end
