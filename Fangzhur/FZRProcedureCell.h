//
//  FZRServiceProcedureCell.h
//  SelfBusiness
//
//  Created by --Chao-- on 14-6-9.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _Position {
    POSLeft,
    POSRight
} Position;

@interface FZRProcedureCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

- (void)fillDataWithTitle:(NSString *)title position:(Position)pos;

@end
