//
//  FZTextFieldCell.h
//  Fangzhur
//
//  Created by --超-- on 14/11/30.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FZTextFieldCellDelegate;

@interface FZTextFieldCell : UITableViewCell
<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) NSMutableArray *cacheArray;

@property (nonatomic, assign) id<FZTextFieldCellDelegate> delegate;

- (void)showSideLabel;
- (void)hideSideLabel;

@end

@protocol FZTextFieldCellDelegate <NSObject>

- (void)textFieldCell:(FZTextFieldCell *)cell didEndEditing:(NSString *)text;

@end
