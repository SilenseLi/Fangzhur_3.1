//
//  FZAdvertisementViewController.m
//  Fangzhur
//
//  Created by --超-- on 14/12/14.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZAdvertisementViewController.h"
#import <UIImageView+WebCache.h>

@interface FZAdvertisementViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) FZWaitingView *waitingView;

- (void)configureUI;
- (void)loadAdvertisementInfo;

@end

@implementation FZAdvertisementViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self configureUI];
    [self loadAdvertisementInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureUI
{
    [self addButtonWithImageName:@"fanhui_brn" target:self action:@selector(popViewController) position:POSLeft];
    [self.navigationController performSelector:@selector(setNavigationBarWithImage:)
                                    withObject:[UIImage imageNamed:@"daohang"]];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.minimumZoomScale = 1.0f;
    self.scrollView.maximumZoomScale = 1.5f;
    self.scrollView.zoomScale = 1.0f;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.scrollView addSubview:self.imageView];
    
    self.waitingView = [[FZWaitingView alloc] init];
    [self.view addSubview:self.waitingView];
    
    
}

- (void)loadAdvertisementInfo
{
    [[FZRequestManager manager] getAdInfoWithID:self.adID complete:^(BOOL success, NSArray *detailArray) {
        if (success) {
            
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:ImageURL([detailArray.firstObject objectForKey:@"pic_url"])] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [self.waitingView hide];
                
                self.scrollView.contentSize = image.size;
                self.imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, image.size.height + (kAdjustScale * 5));
            }];
        }
        
    }];
}

#pragma mark - Scroll view delegate -

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

#pragma mark - Response events -

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
