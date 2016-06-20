//
//  FZLoginView.m
//  Fangzhur
//
//  Created by --超-- on 14/11/2.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZLoginView.h"
#import "UIButton+ZCCustomButtons.h"
#import "WXApi.h"

@interface FZLoginView ()

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIImageView *chineseImageView;
@property (nonatomic, strong) UIImageView *englishImageView;

/** 进行界面布局 */
- (void)configureSubviews;

@end

@implementation FZLoginView

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        [self configureSubviews];
    }
    
    return self;
}

- (void)configureSubviews
{
    UIButton *backButton = [UIButton buttonWithFrame:CGRectMake(10, 35, 150, 30)
                                               title:@"登录账号"
                                           imageName:@"fanhui"
                                         bgImageName:nil];
    backButton.tag = 0;
    [backButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];
    
    self.logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Login_logo"]];
    self.logoImageView.frame = CGRectMake(0, 85, 105, 103);
    self.logoImageView.center = CGPointMake(SCREEN_WIDTH / 2, 85);
    self.logoImageView.alpha = 0;
    [self addSubview:self.logoImageView];
    
    self.chineseImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fangzhur_ch"]];
    self.chineseImageView.frame = CGRectMake(0, 198, 103, 32);
    self.chineseImageView.center = CGPointMake(SCREEN_WIDTH / 2, 198 + 16);
    self.chineseImageView.alpha = 0;
    [self addSubview:self.chineseImageView];
    
    self.englishImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fangzhur_en"]];
    self.englishImageView.frame = CGRectMake(0, 230, 150, 44);
    self.englishImageView.center = CGPointMake(SCREEN_WIDTH / 2, 230 + 22);
    self.englishImageView.alpha = 0;
    [self addSubview:self.englishImageView];
    
    NSArray *titles = @[@"手机免注册登录", @"微博", @"微信"];
    NSArray *images = @[@"", @"weibo", @"weixin"];
    NSArray *bgImages = @[@"textField_bg", @"Button_bg", @"Button_bg"];
    for (int i = 0; i < 3; i++) {
        UIButton *loginButton = [UIButton buttonWithFrame:CGRectMake(0, 315 + (45 * i), SCREEN_WIDTH - 100, 35)
                                                    title:[titles objectAtIndex:i]
                                                imageName:[images objectAtIndex:i]
                                              bgImageName:[bgImages objectAtIndex:i]];
        loginButton.tag = i + 1;
        CGPoint buttonCenter = loginButton.center;
        buttonCenter.x = SCREEN_WIDTH / 2.0f;
        loginButton.center = buttonCenter;
        [loginButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:loginButton];
        
        if ((i == 2) && ![WXApi isWXAppInstalled]) {
            loginButton.hidden = YES;
        }
    }
    
    UIButton *declarationButton = [UIButton buttonWithFrame:CGRectMake(0, 445, SCREEN_WIDTH - 100, 35) title:@"发布声明" fontSize:16 bgImageName:nil];
    declarationButton.center = CGPointMake(SCREEN_WIDTH / 2, 445 + 17.5f);
    [declarationButton setTag:4];
    [declarationButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [declarationButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:declarationButton];
}

- (void)addLogoAnimation
{
    [UIView animateWithDuration:0.6 animations:^{
        self.logoImageView.alpha = 1;
        self.logoImageView.center = CGPointMake(SCREEN_WIDTH / 2, 85 + 51.5f);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            self.chineseImageView.alpha = 1;
            self.englishImageView.alpha = 1;
        } completion:NULL];
    }];
}


#pragma mark - 响应事件 -

- (void)buttonClicked:(UIButton *)sender
{   
    switch (sender.tag) {
        case 0://返回按钮
            [self.delegate loginView:self backButtonClicked:sender];
            break;
        case 1://免注册按钮
            [self.delegate loginView:self loginButtonClicked:sender loginMode:FZLoginModeDefault];
            break;
        case 2://新浪按钮
            [self.delegate loginView:self loginButtonClicked:sender loginMode:FZLoginModeWeibo];
            break;
        case 3://微信按钮
            [self.delegate loginView:self loginButtonClicked:sender loginMode:FZLoginModeWeixin];
            break;
        case 4://声明按钮
            [self.delegate loginView:self declarationButtonClicked:sender];
            break;
            
        default:
            break;
    }
}


@end
