//
//  FZSideMenuHeader.m
//  Fangzhur
//
//  Created by --超-- on 14/11/1.
//  Copyright (c) 2014年 Zc. All rights reserved.
//
//头像通过网络缓存到本地，存储到bundle中，同时更新 user defaults 的数据

#import "FZSideMenuHeader.h"
#import <UIImageView+WebCache.h>

@interface FZSideMenuHeader ()

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) FZRequestManager *request;

@end

@implementation FZSideMenuHeader

- (instancetype)initWithTarget:(id)target action:(SEL)action
{
    self = [super init];
    
    if (self) {
        _target = target;
        _action = action;
        self.request = [FZRequestManager manager];
        
        //这里监听数据量较大的image URL地址，以防加载图片的时候，由于User defaults延迟缓存造成的地址为空
        [[NSUserDefaults standardUserDefaults] addObserver:self
                                                forKeyPath:Key_HeadImage
                                                   options:NSKeyValueObservingOptionNew
                                                   context:NULL];
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH - 90, 196);
        self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(75, 60, 80, 80)];
        CGPoint centerPoint = self.headerImageView.center;
        
        self.headerImageView.center = centerPoint;
        if ([FZUserInfoWithKey(Key_BindingTag) isEqualToString:@"Unbind"]) {
            [self setHeaderImage:FZUserInfoWithKey(Key_HeadImage)];
        }
        else {
            if (!FZUserInfoWithKey(Key_HeadImage)) {
                self.headerImageView.image = [UIImage imageNamed:@"moren_touxiang"];
            }
            else {
                [self setHeaderImage:URLStringByAppending(FZUserInfoWithKey(Key_HeadImage))];
            }
        }
        
        self.headerImageView.userInteractionEnabled = YES;
        self.headerImageView.clipsToBounds          = YES;
        self.headerImageView.layer.cornerRadius     = 40;
        self.headerImageView.layer.borderColor      = [UIColor whiteColor].CGColor;
        self.headerImageView.layer.borderWidth      = 2.5;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:_target action:_action];
        [self.headerImageView addGestureRecognizer:tapGesture];
        
        self.userNameLabel = [[UILabel alloc] initWithFrame:
                              CGRectMake(CGRectGetMidX(self.headerImageView.frame) - 75, 150, 150, 36)];
        self.userNameLabel.backgroundColor = [UIColor clearColor];
        self.userNameLabel.font = [UIFont fontWithName:kFontName size:19];
        self.userNameLabel.textAlignment = NSTextAlignmentCenter;
        self.userNameLabel.textColor = [UIColor whiteColor];
        self.userNameLabel.adjustsFontSizeToFitWidth = YES;
        self.userNameLabel.minimumScaleFactor = 12;
        self.userNameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:Key_UserName];
        
        [self addSubview:self.headerImageView];
        [self addSubview:self.userNameLabel];
        
    }
    
    return self;
}

- (void)dealloc
{
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:Key_HeadImage];
}

- (void)setHeaderImage:(NSString *)headerImage
{
    _headerImage = headerImage;
    if (!headerImage) {
        self.headerImageView.image = [UIImage imageNamed:@"moren_touxiang"];
        return;
    }
    
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:headerImage]
                            placeholderImage:[UIImage imageNamed:@"moren_touxiang"]];
}

- (void)setUserName:(NSString *)userName
{
    _userName = userName;
    self.userNameLabel.text = userName;
}

//用于监听头像的变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"=========>> 用户信息发生了变化");
    if (![change objectForKey:@"new"] || [[change objectForKey:@"new"] isKindOfClass:[NSNull class]]) {
        //TODO:退出用户，重置
        self.headerImageView.image = [UIImage imageNamed:@"moren_touxiang"];
        self.userNameLabel.text = kDefaultUserName;
    }
    else {
        #warning 防止在进入个人中心的时候，请求数据延迟时，退出登录导致的头像恢复默认头像失败
        if (!FZUserInfoWithKey(Key_LoginToken)) {
            return;
        }
        
        self.userNameLabel.text = FZUserInfoWithKey(Key_UserName);
        if ([FZUserInfoWithKey(Key_BindingTag) isEqualToString:@"Unbind"]) {
            [self setHeaderImage:FZUserInfoWithKey(Key_HeadImage)];
        }
        else {
            [self setHeaderImage:URLStringByAppending(FZUserInfoWithKey(Key_HeadImage))];
        }
    }
}

@end
