//
//  FZScrolledNavigationBarController.m
//  Fangzhur
//
//  Created by --超-- on 14/10/22.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZScrolledNavigationBarController.h"

#define NavigationBarFrame self.navigationController.navigationBar.frame
#define SHOW_THRESHOLD 10.0f
#define HIDE_THRESHOLD -10.0f
#define HIGHLIGHTED_TAG @"_h"

@interface FZScrolledNavigationBarController ()

@property (nonatomic, weak) UIScrollView *scrollView;
/** 用于遮盖上移后的导航栏 */
//@property (nonatomic, strong) UIImageView *overlayer;
/** 根据手势判断显示和隐藏 */
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
/** 避免重复操作 */
@property (nonatomic, assign) BOOL isHidden;

@end

@implementation FZScrolledNavigationBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController performSelector:@selector(setNavigationBarWithImage:)
                                    withObject:[UIImage imageNamed:@"daohang_bg"]];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = RGBColor(240, 240, 240);
}

- (void)addBackgroundView
{
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.jpg"]];
    bgImageView.frame = [UIScreen mainScreen].bounds;
    [self.view insertSubview:bgImageView atIndex:0];
}


#pragma mark - 定制导航栏 -

- (void)addButtonWithImage:(UIImage *)image target:(id)target action:(SEL)action position:(FZButtonPosition)pos
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    if (pos == POSLeft) {
        self.navigationItem.leftBarButtonItem = buttonItem;
    }
    else {
        self.navigationItem.rightBarButtonItem = buttonItem;
    }
}

- (UIButton *)addButtonWithImageName:(NSString *)imageName target:(id)target action:(SEL)action position:(FZButtonPosition)pos
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (kScreenScale == 3) {
        button.frame = CGRectMake(0, 0, 50, 44);
    }
    else {
        button.frame = CGRectMake(0, 0, 44, 44);
    }
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@", imageName, HIGHLIGHTED_TAG]]
            forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.contentMode = UIViewContentModeCenter;
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    if (pos == POSLeft) {
        self.navigationItem.leftBarButtonItem = buttonItem;
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    }
    else {
        self.navigationItem.rightBarButtonItem = buttonItem;
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    }
    
    return button;
}

- (void)addButtonsWithImageNames:(NSArray *)names target:(id)target action:(SEL)action position:(FZButtonPosition)pos
{
    NSMutableArray *buttonItems = [NSMutableArray array];
    
    for (NSString *imageName in names) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame     = CGRectMake(0, 0, 30, 30);
        button.tag       = buttonItems.count;
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@", imageName, @"_h"]]
                forState:UIControlStateSelected];
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        [buttonItems addObject:buttonItem];
    }
    
    self.navigationItem.rightBarButtonItems = buttonItems;
}

//激活导航栏动画
- (void)rollingBarWithScrollView:(UIScrollView *)scrollView finished:(FinishedRolling)block
{
    self.rollingBlock = block;
    
    self.scrollView = scrollView;
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    self.panGesture.delegate = self;
    [scrollView addGestureRecognizer:self.panGesture];
    
//    self.overlayer = [[UIImageView alloc] initWithFrame:self.navigationController.navigationBar.bounds];
//    self.overlayer.alpha = 0;
//    self.overlayer.backgroundColor = self.navigationController.navigationBar.barTintColor;
//    [self.navigationController.navigationBar addSubview:self.overlayer];
//    [self.navigationController.navigationBar bringSubviewToFront:self.overlayer];
}

- (void)showNavigationBar
{
    self.isHidden          = NO;
    CGRect barFrame        = NavigationBarFrame;
    CGRect scrollViewFrame = self.scrollView.frame;
    barFrame.origin.y           = 20;
    scrollViewFrame.origin.y    = 64;
    scrollViewFrame.size.height = SCREEN_HEIGHT - 64;
    NavigationBarFrame    = barFrame;
    self.scrollView.frame = scrollViewFrame;
}

#pragma mark - 手势相关 -

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:recognizer.view];
    
    // 显示导航栏
    if (translation.y > SHOW_THRESHOLD && self.isHidden) {
        if (self.rollingBlock) {
            self.rollingBlock(NO);
        }
        self.isHidden        = NO;
//        self.overlayer.alpha = 0;
        
        CGRect barFrame        = NavigationBarFrame;
        CGRect scrollViewFrame = self.scrollView.frame;
        barFrame.origin.y           = 20;
        scrollViewFrame.origin.y    += 64;
        scrollViewFrame.size.height -= 64;
        
        [UIView animateWithDuration:0.2 animations:^{
            NavigationBarFrame    = barFrame;
            self.scrollView.frame = scrollViewFrame;
        }];
    }
    // 隐藏导航栏
    else if (translation.y < HIDE_THRESHOLD && !self.isHidden) {
        if (self.rollingBlock) {
            self.rollingBlock(YES);
        }
        self.isHidden          = YES;
        
        CGRect barFrame        = NavigationBarFrame;
        CGRect scrollViewFrame = self.scrollView.frame;
        barFrame.origin.y           = -64;
        scrollViewFrame.origin.y    -= 64;
        scrollViewFrame.size.height += 64;
        
        [UIView animateWithDuration:0.2 animations:^{
            NavigationBarFrame    = barFrame;
            self.scrollView.frame = scrollViewFrame;
        } completion:^(BOOL finished) {
//            self.overlayer.alpha = 1;
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
