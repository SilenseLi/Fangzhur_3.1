//
//  FZPersonalCenterCell.m
//  Fangzhur
//
//  Created by --超-- on 14/11/6.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZPersonalCenterCell.h"

@implementation FZPersonalCenterCell

- (void)awakeFromNib {
    UIView *selectedView = [[UIView alloc] initWithFrame:self.bounds];
    selectedView.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = selectedView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)configureCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *titleDict = [ZCReadFileMethods dataFromPlist:@"PeronalCenterData" ofType:Dictionary];
    NSString *nameString = [NSString stringWithFormat:@"%d%d", (int)indexPath.section, (int)indexPath.row];
    self.cellTitleLabel.text = [titleDict objectForKey:nameString];
    self.cellImageView.image = [UIImage imageNamed:nameString];
}

@end
