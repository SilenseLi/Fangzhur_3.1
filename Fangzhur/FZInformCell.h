//
//  FZInformCell.h
//  Fangzhur
//
//  Created by --超-- on 14-7-18.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZInformCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *agentLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UITextField *causeField;
@property (weak, nonatomic) IBOutlet UITextField *typeField;
@property (weak, nonatomic) IBOutlet UITextView *describeTextView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

- (void)fillDataWithAgentInfo:(NSString *)info orderNum:(NSString *)orderNum;

@end
