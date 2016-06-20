//
//  FZRPaymentCell.h
//  SelfBusiness
//
//  Created by --Chao-- on 14-6-12.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZRPaymentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *paymentLabel;
@property (weak, nonatomic) IBOutlet UIButton *methodButton;
@property (weak, nonatomic) IBOutlet UIButton *paymentButton;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end
