//
//  FZChooseTagViewController.m
//  Fangzhur
//
//  Created by --超-- on 14/11/17.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZChooseTagViewController.h"
#import "FZChooseTagView.h"

@interface FZChooseTagViewController ()

@property (nonatomic, strong) FZChooseTagView *tagView;

- (void)configureUI;
- (void)tagChooseFinished;

@end

@implementation FZChooseTagViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self configureUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureUI
{
    [self addButtonWithImageName:@"fanhui" target:self action:@selector(dismissChooseTagController) position:POSLeft];
    [self addBackgroundView];

    self.tagView = [[FZChooseTagView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [self.view addSubview:self.tagView];
    NSDictionary *tagDict = (NSDictionary *)[[EGOCache globalCache] plistForKey:Key_Tag];
    [self.tagView addTags:[tagDict objectForKey:@"data"]];
    [self.tagView.startButton addTarget:self action:@selector(tagChooseFinished) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - 响应事件 -

- (void)dismissChooseTagController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tagChooseFinished
{
    [[NSUserDefaults standardUserDefaults] setObject:self.tagView.selectedTags forKey:Key_Tag];
    [self dismissChooseTagController];
}


@end
