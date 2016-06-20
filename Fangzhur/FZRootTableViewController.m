//
//  FZRootTableViewController.m
//  Fangzhur
//
//  Created by --Chao-- on 14-6-19.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZRootTableViewController.h"

@interface FZRootTableViewController ()

@end

@implementation FZRootTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)
                                                  style:UITableViewStylePlain];
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.scrollsToTop = YES;
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置横向 Tableview
- (void)reverseTableView
{
    _tableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    _tableView.allowsSelection = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.frame = CGRectMake(0, 36 + 64, SCREEN_WIDTH, SCREEN_HEIGHT - 100);
    _tableView.pagingEnabled = YES;
    _tableView.showsVerticalScrollIndicator = NO;
}

#pragma mark - Table view delegate -

#pragma mark - Table view data source - 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
