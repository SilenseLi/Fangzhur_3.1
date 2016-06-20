//
//  FZChooseAgentView.h
//  Fangzhur
//
//  Created by --超-- on 14-7-22.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZAgentView.h"
#import "FZAgentModel.h"

@interface FZChooseAgentView : UIView

@property (nonatomic, retain) FZAgentView *agentView;
@property (nonatomic, retain) FZAgentModel *agentModel;
@property (nonatomic, retain) UIButton *nextButton;

@end
