//
//  FZReleaseHouseRootViewController.m
//  Fangzhur
//
//  Created by --超-- on 14/12/3.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZReleaseHouseRootViewController.h"

@interface FZReleaseHouseRootViewController ()

@end

@implementation FZReleaseHouseRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *backButton = [self addButtonWithImageName:@"fanhui_brn" target:self action:@selector(popViewController) position:POSLeft];
    backButton.contentMode = UIViewContentModeLeft;
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
}

- (void)addTipLabelWithHeight:(CGFloat)height tipString:(NSString *)tipString
{
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, height)];
    tipLabel.backgroundColor = RGBColor(230, 230, 230);
    tipLabel.numberOfLines = 0;
    tipLabel.textColor = kDefaultColor;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont fontWithName:kFontName size:18];
    tipLabel.text = tipString;
    tipLabel.layer.borderColor = RGBColor(204, 204, 204).CGColor;
    tipLabel.layer.borderWidth = 0.5;
    self.tableView.tableHeaderView = tipLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Response event -

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
