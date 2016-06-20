//
//  FZMobileLoginView.h
//  Fangzhur
//
//  Created by --超-- on 14/11/3.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZMobileLoginViewModel.h"
#import "FZTextField.h"

@protocol FZMobileLoginViewDelegate;

typedef NS_ENUM(NSInteger, FZMobileLoginButtonMode) {
    FZMobileLoginButtonModeBack,
    FZMobileLoginButtonModeCheck,
    FZMobileLoginButtonModeLogin
};

@interface FZMobileLoginView : UIImageView
<UITextFieldDelegate, FZMobileLoginViewModelDelegate>

@property (nonatomic, strong) FZMobileLoginViewModel *loginViewModel;
@property (nonatomic, strong) FZTextField *telTextField;
@property (nonatomic, strong) FZTextField *codeTextField;
@property (nonatomic, strong) FZTextField *helpTextField;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *codeButton;
@property (nonatomic, assign) id<FZMobileLoginViewDelegate> delegate;

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title;

@end

@protocol FZMobileLoginViewDelegate <NSObject>

- (void)MobileLoginViewButton:(UIButton *)sender mode:(FZMobileLoginButtonMode)mode;

@end
