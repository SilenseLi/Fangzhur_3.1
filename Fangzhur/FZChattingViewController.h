//
//  FZChattingViewController.h
//  Fangzhur
//
//  Created by --超-- on 14/12/19.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "SOMessagingViewController.h"

@interface FZChattingViewController : SOMessagingViewController

@property (nonatomic, copy) NSString *sender_id;
@property (nonatomic, copy) NSString *house_id;
@property (nonatomic, copy) NSString *house_type;

@property (strong, nonatomic) UIImage *myImage;
@property (strong, nonatomic) UIImage *partnerImage;

@end
