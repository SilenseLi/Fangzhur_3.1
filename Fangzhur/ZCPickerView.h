//
//  ZCPickerView.h
//  SelfBusiness
//
//  Created by --Chao-- on 14-6-10.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCPickerView : UIView
<UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIPickerView *_pickerView;
    UIView *_backgroundView;
    
}

@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;

- (id)initWithField:(UITextField *)field numberOfComponents:(NSInteger)components
          leftArray:(NSArray *)leftArray rightDict:(NSDictionary *)rightDict;
- (void)addTarget:(id)target action:(SEL)action;

@end
