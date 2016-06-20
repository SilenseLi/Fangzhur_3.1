//
//  FZTextViewCell.h
//  Fangzhur
//
//  Created by --超-- on 14/11/30.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZTextViewCell : UITableViewCell
<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (nonatomic, strong) NSMutableArray *cacheArray;

@end
