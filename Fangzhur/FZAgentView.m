//
//  FZAgentView.m
//  Fangzhur
//
//  Created by --超-- on 14-7-22.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZAgentView.h"
#import "UIImageView+WebCache.h"

@implementation FZAgentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 15;
}

- (void)fillDataWithModel:(FZAgentModel *)model
{
    [_photoImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]
                    placeholderImage:[UIImage imageNamed:@"moren_touxiang.png"]];
    NSArray *levelArray = [NSArray arrayWithObjects:
                           @"无级别", @"初级交易顾问", @"中级交易顾问", @"高级交易顾问", nil];
    _nameLabel.text     = [NSString stringWithFormat:@"%@ (%@)", model.realname, [levelArray objectAtIndex:model.level.intValue]];
    _creditLabel.text       = model.xinyong;
    _reputationLabel.text   = model.fw_pl_zonglvt;
    _timesLabel.text        = model.fw_servicecount;
    if (!model.fw_accep || model.fw_accep.length == 0) {
        _descLabel.text = @"暂无相关承诺!";
    }
    else {
        _descLabel.text = model.fw_accep;
    }
    
}

@end
