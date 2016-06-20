//
//  FZPopupTableView.m
//  Fangzhur
//
//  Created by --超-- on 14/11/28.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZPopupTableView.h"
#import "FZHouseBaseInfoCell.h"

#define DynamicLabelSizeOf(string)\
[string sizeWithFont:[UIFont fontWithName:kFontName size:15] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, 999) lineBreakMode:NSLineBreakByWordWrapping]

@interface FZPopupTableView ()

@property (nonatomic, strong) FZHouseBaseInfoCell *baseInfoCell;

@end

@implementation FZPopupTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.9];
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self registerNib:[UINib nibWithNibName:@"FZHouseBaseInfoCell" bundle:nil] forCellReuseIdentifier:@"FZHouseBaseInfoCell"];
    }
    
    return self;
}

- (void)layoutSubviews
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 12;
    
    [super layoutSubviews];
}

#pragma mark - Table view delegate -

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return DynamicLabelSizeOf(self.baseInfoCell.infoLabel.text).height * 2;
    }
    else {
        return 0;
    }
}


#pragma mark - Table view data source -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    switch (indexPath.row) {
        case 0:{
            self.baseInfoCell = [tableView dequeueReusableCellWithIdentifier:@"FZHouseBaseInfoCell"];
            [self.baseInfoCell configureCellWithModel:self.detailModel];
            cell = self.baseInfoCell;
        }
            break;
        case 1:{}
            break;
        case 2:{}
            break;
            
        default:
            break;
    }
    
    return cell;
}


@end
