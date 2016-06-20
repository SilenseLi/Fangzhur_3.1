//
//  FZUpdateInfoCell.h
//  Fangzhur
//
//  Created by --Chao-- on 14-7-3.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZUpdateInfoCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *realNameField;
@property (weak, nonatomic) IBOutlet UITextField *nickField;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sexPickerControl;

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;

- (void)addTarget:(id)target action:(SEL)action;
- (IBAction)centerButtonClicked:(UIButton *)sender;
- (void)showSexControl;
- (void)hideSexControl;
- (void)resignKeyboard;

@end
