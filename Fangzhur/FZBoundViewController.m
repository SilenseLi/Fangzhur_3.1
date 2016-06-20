//
//  FZBoundViewController.m
//  Fangzhur
//
//  Created by fq on 15/1/12.
//  Copyright (c) 2015年 Zc. All rights reserved.
//

#import "FZBoundViewController.h"

@interface FZBoundViewController ()

- (void)UIConfig;

@end

@implementation FZBoundViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIConfig];
}

- (void)UIConfig
{
    self.title = @"绑定协议";
    [self.navigationController performSelector:@selector(addTitle:) withObject:@""];
    [self addButtonWithImageName:@"fanhui" target:self action:@selector(popViewController) position:POSLeft];
    NSString* path = [[NSBundle mainBundle] pathForResource:@"boundServe"
                                                     ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 64, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 64)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(scrollView.bounds), 0)];
    tipLabel.text=content;
    tipLabel.font            = [UIFont fontWithName:kFontName size:15];
    tipLabel.numberOfLines   = 0;
    tipLabel.lineBreakMode   = NSLineBreakByWordWrapping;
    tipLabel.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:tipLabel];
    
    CGSize contentSize=[content boundingRectWithSize:CGSizeMake(CGRectGetWidth(scrollView.frame), 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:kFontName size:15]} context:nil].size;
    tipLabel.frame=CGRectMake(0, 0, contentSize.width, contentSize.height);
    scrollView.contentSize=contentSize;
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
