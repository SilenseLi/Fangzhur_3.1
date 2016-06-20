//
//  FZInformCell.m
//  Fangzhur
//
//  Created by --超-- on 14-7-18.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZInformCell.h"
#import "FieldPickerView.h"
#import "Macro.h"

@implementation FZInformCell

- (void)awakeFromNib
{
    NSMutableArray *causeArray = [NSMutableArray arrayWithObjects:
                                  @"顾问违规", nil];
    NSMutableArray *typeArray  = [NSMutableArray arrayWithObjects:
                                  @"举报顾问", @"举报并更换顾问", nil];
    PickerView(causePicker, _causeField, 1, causeArray, nil);
    PickerView(typePicker, _typeField, 1, typeArray, nil);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillDataWithAgentInfo:(NSString *)info orderNum:(NSString *)orderNum
{
    _agentLabel.text    = info;
    _orderNumLabel.text = orderNum;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_describeTextView resignFirstResponder];
}

@end
