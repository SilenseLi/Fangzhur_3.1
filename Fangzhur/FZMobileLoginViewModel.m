//
//  FZMobileLoginViewModel.m
//  Fangzhur
//
//  Created by --超-- on 14/11/3.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZMobileLoginViewModel.h"
#import "FZTextField.h"
#import <AFNetworking.h>
#import "FZMobileLoginView.h"
#import "JCheckPhoneNumber.h"

@interface FZMobileLoginViewModel ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *requestManager;

@end

@implementation FZMobileLoginViewModel

- (instancetype)initWithOwner:(FZMobileLoginView *)owner
{
    self = [super init];
    
    if (self) {
        self.owner = owner;
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
        [self.timer setFireDate:[NSDate distantFuture]];
    }
    
    return self;
}

- (void)timerFired
{
    //请求登录密码
    [[FZRequestManager manager] getCheckCodeOfUser:self.userName complete:^(BOOL success, id responseObject) {
        if (success) {
            _counter = 60;
            [self.timer setFireDate:[NSDate date]];
            
            //TODO:判断用户的状态，新用户显示出互助码的框
            _status = [responseObject objectForKey:@"status"];
            if ([_status isEqualToString:@"2"]) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.owner.helpTextField.alpha = 1;
                    
                    CGRect frame = self.owner.loginButton.frame;
                    frame.origin.y = 200;
                    self.owner.loginButton.frame = frame;
                } completion:^(BOOL finished) {
                    [JDStatusBarNotification showWithStatus:@"输入互助码可以获取相应奖励!"
                                               dismissAfter:3
                                                  styleName:JDStatusBarStyleDark];
                }];
            }
            else {
                [JDStatusBarNotification showWithStatus:[responseObject objectForKey:@"fanhui"]
                                           dismissAfter:2
                                              styleName:JDStatusBarStyleDark];
            }
        }
    }];
}


#pragma mark - Text field delegate -

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    ((FZTextField *)textField).selected = YES;
    
    //TODO:更改手机号时，先隐藏互助码输入框
    if (textField == self.owner.telTextField) {
        self.owner.helpTextField.alpha = 0;
        
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = self.owner.loginButton.frame;
            frame.origin.y = 250;
            self.owner.loginButton.frame = frame;
        }];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //TODO:重新输入手机号码，清空密码框
    if (textField == self.owner.telTextField) {
        self.owner.codeTextField.text = @"";
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    ((FZTextField *)textField).selected = NO;
    
    if (textField == self.owner.telTextField) {
        _userName = self.owner.telTextField.text;
    }
    else if (textField == self.owner.codeTextField) {
        _password = self.owner.codeTextField.text;
    }
    else {
        
        _helpCode = self.owner.helpTextField.text;
    }
    
}

#pragma mark - 响应事件 -

- (void)updateCounter:(NSTimer *)timer
{
    _counter--;
    
    if (_counter == 0) {
        [self.timer setFireDate:[NSDate distantFuture]];
    }
    
    [self.delegate counterUpdating:_counter];
}

- (void)startRequestForLoginComplete:(void (^)(BOOL))responseBlock
{
    //TODO:信息不完整的判断
    if (self.owner.telTextField.text.length == 0 ||
        self.owner.codeTextField.text.length == 0) {
        [JDStatusBarNotification showWithStatus:@"您填入的信息不完整" dismissAfter:2 styleName:JDStatusBarStyleError];
        self.owner.loginButton.enabled = YES;
        
        return;
    }
    
    [JDStatusBarNotification showWithStatus:@"登录中"];
    [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    self.requestManager = [AFHTTPRequestOperationManager manager];
    //完善信息
//    if ([FZUserInfoWithKey(Key_BindingTag) isEqualToString:@"Unbind"]) {
//        NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
//                                   self.userName, @"username",
//                                   self.password, @"passwd",
//                                   FZUserInfoWithKey(Key_MemberID), @"member_id",
//                                   FZUserInfoWithKey(Key_LoginToken), @"token",
//                                   @"third_complete_info", @"action", nil];
//        [self.requestManager POST:URLStringByAppending(kLogin)
//                       parameters:paramDict
//                          success:^(AFHTTPRequestOperation *operation, id responseObject)
//         {
//             NSLog(@"Login info: \n%@", responseObject);
//             NSString *resultString = [[responseObject objectForKey:@"data"] firstObject];
//             
//             if (resultString.length == 1) {//登录成功
//                 [JDStatusBarNotification showWithStatus:@"恭喜您，绑定成功" dismissAfter:2 styleName:JDStatusBarStyleDark];
//                 [self.owner.delegate MobileLoginViewButton:self.owner.loginButton mode:FZMobileLoginButtonModeLogin];
//                 
//                 [[NSUserDefaults standardUserDefaults] setObject:self.userName forKey:Key_UserName];
//                 [[NSUserDefaults standardUserDefaults] setObject:resultString forKey:Key_RoleType];
//                 [[NSUserDefaults standardUserDefaults] setObject:@"Bind" forKey:Key_BindingTag];
//                 //TODO:首次绑定之后，头像使用默认头像，直到用户上传头像之后
//                 [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:Key_HeadImage];
//                 [[FZRequestManager manager] getUserInfoComplete:NULL];
//                 
//                 [self.timer invalidate];
//             }
//             else {
//                 [JDStatusBarNotification showWithStatus:resultString dismissAfter:2 styleName:JDStatusBarStyleError];
//                 return ;
//             }
//         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//             FZNetworkingError(@"Login Error");
//         }];
//        
//        return;
//    }
    
    //手机登录
    [[FZRequestManager manager] loginWithUserName:self.userName password:self.password status:self.status helpCode:self.helpCode complete:^(BOOL success, id userInfo) {
        self.owner.loginButton.enabled = YES;
        
        if (success) {
            [self.owner.delegate MobileLoginViewButton:self.owner.loginButton mode:FZMobileLoginButtonModeLogin];
            [self.timer invalidate];
            
            [[NSUserDefaults standardUserDefaults] setObject:self.userName forKey:Key_UserName];
            [[NSUserDefaults standardUserDefaults] setObject:[userInfo objectForKey:@"token"] forKey:Key_LoginToken];
            [[NSUserDefaults standardUserDefaults] setObject:[userInfo objectForKey:@"memberid"] forKey:Key_MemberID];
            [[NSUserDefaults standardUserDefaults] setObject:[userInfo objectForKey:@"role_type"] forKey:Key_RoleType];
            //TODO:这里由于在监听 Key_HeadImage，所以这个值的设置一定要放在其他值之后
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:Key_HeadImage];
            
            [[FZRequestManager manager] getUserInfoComplete:NULL];
        }
    }];
}

@end
