//
//  FZPersonalCenterCell.h
//  Fangzhur
//
//  Created by --超-- on 14/11/6.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZPersonalCenterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *cellTitleLabel;

- (void)configureCellAtIndexPath:(NSIndexPath *)indexPath;

@end
