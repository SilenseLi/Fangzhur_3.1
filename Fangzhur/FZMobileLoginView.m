//
//  FZMobileLoginView.m
//  Fangzhur
//
//  Created by --超-- on 14/11/3.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZMobileLoginView.h"
#import "UIButton+ZCCustomButtons.h"
#import "JCheckPhoneNumber.h"
#import <JDStatusBarNotification.h>

#define TEXT_FIELD_HEIGHT 35

@interface FZMobileLoginView ()

@property (nonatomic, copy) NSString *title;

/** 进行界面布局 */
- (void)configureSubviews;

@end

@implementation FZMobileLoginView

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title
{
    self = [super initWithImage:image];
    
    if (self) {
        self.title = title;
        self.frame = [UIScreen mainScreen].bounds;
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        
        //视图逻辑模型
        self.loginViewModel = [[FZMobileLoginViewModel alloc] initWithOwner:self];
        self.loginViewModel.delegate = self;
        [self configureSubviews];
    }
    
    return self;
}

- (void)configureSubviews
{
    //返回按钮
    UIButton *backButton = [UIButton buttonWithFrame:CGRectMake(10, 35, 150, 30)
                                               title:self.title
                                           imageName:@"fanhui"
                                         bgImageName:nil];
    backButton.tag = 0;
    [backButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];
    
    //输入框
    self.telTextField = [[FZTextField alloc] initWithFrame:CGRectMake(0, 110, SCREEN_WIDTH - 60, TEXT_FIELD_HEIGHT)
                                               placeholder:@"请输入您的手机号"
                                           backGroundImage:[UIImage imageNamed:@"textField_bg"]];
    self.telTextField.center = CGPointMake(SCREEN_WIDTH / 2, (110 + _telTextField.bounds.size.height / 2));
    self.telTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.telTextField.delegate = self.loginViewModel;
    [self addSubview:self.telTextField];
    
    self.codeTextField = [[FZTextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(_telTextField.frame), 155, CGRectGetWidth(_telTextField.bounds) - 110, TEXT_FIELD_HEIGHT)
                                                placeholder:@"验证码为登录密码"
                                            backGroundImage:[UIImage imageNamed:@"textField_bg"]];
    self.codeTextField.secureTextEntry = YES;
    self.codeTextField.delegate = self.loginViewModel;
    [self addSubview:self.codeTextField];
    
    self.helpTextField = [[FZTextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(_telTextField.frame), 300, CGRectGetWidth(_telTextField.bounds), 35)
                                                placeholder:@"请输入互助码"
                                            backGroundImage:[UIImage imageNamed:@"textField_bg"]];
    self.helpTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.helpTextField.delegate = self.loginViewModel;
    //TODO:在获取验证码的时候动态的显示，如果是新用户就显示出来
    self.helpTextField.alpha = 0;
    [self addSubview:self.helpTextField];
    
    //验证码按钮
    self.codeButton = [UIButton buttonWithFrame:CGRectMake(CGRectGetMaxX(_codeTextField.frame) + 10, 155, 100, 35)
                                          title:@"获取验证码"
                                       fontSize:15
                                    bgImageName:@"code_bg"];
    [self.codeButton setTag:1];
    [self.codeButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.codeButton];
    
    //登录按钮
    self.loginButton = [UIButton buttonWithFrame:CGRectMake(CGRectGetMinX(_telTextField.frame), 250, CGRectGetWidth(_telTextField.bounds), 35)
                                           title:@"登   录"
                                        fontSize:17
                                     bgImageName:@"Button_bg"];
    [self.loginButton setTitle:@"登录中" forState:UIControlStateDisabled];
    [self.loginButton setTag:2];
    [self.loginButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.loginButton];
    
}

//注销键盘
- (void)resignKeyboard
{
    [self.telTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    [self.helpTextField resignFirstResponder];
}

#pragma mark - 响应事件 -

- (void)buttonClicked:(UIButton *)sender
{
    [self resignKeyboard];
    
    switch (sender.tag) {
        case 0: //点击返回按钮
            [self.loginViewModel.timer invalidate];
            [self.delegate MobileLoginViewButton:sender mode:FZMobileLoginButtonModeBack];
            break;
            
        case 1: //点击获取验证码按钮
            [self.delegate MobileLoginViewButton:sender mode:FZMobileLoginButtonModeCheck];
            
            //检测电话号码合法性
            if (![JCheckPhoneNumber isMobileNumber:self.telTextField.text]) {
                [JDStatusBarNotification showWithStatus:@"手机号码输入有误" dismissAfter:2 styleName:JDStatusBarStyleError];
            }
            else {
                [self.loginViewModel timerFired];
                sender.enabled = NO;
            }
            break;
            
        case 2: //点击登录按钮
            //检测电话号码合法性
            if (![JCheckPhoneNumber isMobileNumber:self.telTextField.text]) {
                [JDStatusBarNotification showWithStatus:@"手机号码输入有误" dismissAfter:2 styleName:JDStatusBarStyleError];
            }
            else {
                sender.enabled = NO;
                
                [self.loginViewModel startRequestForLoginComplete:^(BOOL success) {
                    sender.enabled = YES;
                }];
            }
            break;
            
        default:
            break;
    }
}

//倒计时
- (void)counterUpdating:(NSInteger)counter
{
    if (counter == 0) {
        self.codeButton.enabled = YES;
    }
    else {
        [self.codeButton setTitle:[NSString stringWithFormat:@"已发送, %lds", counter] forState:UIControlStateDisabled];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resignKeyboard];
}

@end
