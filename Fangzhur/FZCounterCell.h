//
//  FZCounterCell.h
//  Fangzhur
//
//  Created by --超-- on 14/11/28.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZCounterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *displayLabel;
@property (weak, nonatomic) IBOutlet UIButton *subtructButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (nonatomic, strong) NSMutableArray *cacheArray;

- (void)updateCell;
- (IBAction)adjustCounter:(UIButton *)sender;

@end
