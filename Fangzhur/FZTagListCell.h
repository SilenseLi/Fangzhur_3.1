//
//  FZTagListCell.h
//  Fangzhur
//
//  Created by --超-- on 14/11/18.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZTagListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tagBgImageView;

/**
 * @brief 配置cell
 * @param tagInfoDict (id, name, url) 
 */
- (void)configureCellWithTagID:(NSString *)tagID tagName:(NSString *)tagName;

@end
