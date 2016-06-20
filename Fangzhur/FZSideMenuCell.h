//
//  FZSideMenuCell.h
//  Fangzhur
//
//  Created by --超-- on 14/10/31.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZSideMenuCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UIButton *cellBadge;
@property (weak, nonatomic) IBOutlet UILabel *cellNameLabel;

- (void)configureRow:(NSInteger)row WithData:(NSDictionary *)dict;

@end
