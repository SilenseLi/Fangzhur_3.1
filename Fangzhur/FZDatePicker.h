//
//  FZDatePicker.h
//  Fangzhur
//
//  Created by --超-- on 14-7-24.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZDatePicker : UIView
<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, readonly) NSString *resultString;
@property (nonatomic, retain) UITextField *ownerField;

@end
