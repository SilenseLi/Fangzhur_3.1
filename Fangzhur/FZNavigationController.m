//
//  FZNavigationController.m
//  Fangzhur
//
//  Created by --超-- on 14/10/30.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZNavigationController.h"

#define BAR_SIZE self.navigationBar.bounds.size
#define kBorderRadius 2

@interface FZNavigationController ()

@property (nonatomic, strong) UILabel *titleLabel;

- (void)setupOverlayer;

@end

@implementation FZNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationBar.opaque = NO;
    self.navigationBar.layer.shadowColor    = [UIColor blackColor].CGColor;
    self.navigationBar.layer.shadowOffset   = CGSizeMake(0.2f , 0.2f);
    self.navigationBar.layer.shadowOpacity  = 0.4f;
    self.navigationBar.layer.shadowRadius   = 0.3f;
    
    for (UIView *view in self.navigationBar.subviews) {
        
        // 隐藏系统自带得背景层
        if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
            view.hidden = YES;
            break;
        }
    }
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = self;
        self.delegate = self;
    }
    
    [self setupOverlayer];
}

- (void)setCustomView:(UIView *)customView
{
    _customView = customView;
    _customView.tag = NSIntegerMax;
    [self.navigationBar addSubview:customView];
}

//Forbid the gesture in order to prevent the chaos of navigation stack when push view controller
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//自定义背景层
- (void)setupOverlayer
{
    if (!_backgroundlayer) {
        _backgroundlayer = [[UIImageView alloc] initWithFrame:CGRectMake(0, -20, BAR_SIZE.width, BAR_SIZE.height + 20)];
        _backgroundlayer.alpha = 1;
        _backgroundlayer.backgroundColor = [UIColor clearColor];
        _backgroundlayer.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    
    [self.navigationBar insertSubview:_backgroundlayer atIndex:0];
}

- (void)setNavigationBarWithImage:(UIImage *)image
{
    _backgroundlayer.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(kBorderRadius, kBorderRadius, kBorderRadius, kBorderRadius) resizingMode:UIImageResizingModeStretch];
}

//必须加在这里？
- (void)addLogoAtFrame:(CGRect)frame
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    imageView.frame = frame;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [self.navigationBar addSubview:imageView];
}

- (void)addTitle:(NSString *)title
{
    if (!self.titleLabel) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 150, CGRectGetHeight(self.navigationBar.bounds) - 5)];
        if (kScreenScale == 3) {
            self.titleLabel.frame = CGRectMake(70, 5, 150, CGRectGetHeight(self.navigationBar.bounds) - 5);
        }
        
        self.titleLabel.text = title;
        self.titleLabel.textColor = [UIColor darkGrayColor];
        self.titleLabel.font = [UIFont fontWithName:kFontName size:17];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self.navigationBar addSubview:self.titleLabel];
    }
    else {
        self.titleLabel.text = title;
    }
}

#pragma mark - Navigation controller delegate -

// When shows view controller, we should enabled the gesture, prevented the gesture chaos when push the view controller
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
}

// If navigation stack already pop to root, disabled the gesture
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count == 1) {
        return NO;
    }
    else {
        return YES;
    }
}

@end
