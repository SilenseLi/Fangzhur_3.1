//
//  FieldPickerView.h
//  test
//
//  Created by L Suk on 14-3-25.
//  Copyright (c) 2014年 L Suk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FieldPickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIView *_bgv;
    NSMutableArray *_pickerArray;
    UITextField *_theField;
    NSInteger _indexNum;
    NSMutableArray *_rightArray;
    NSMutableDictionary *_dic;
    
}
@property (nonatomic, strong) UIPickerView *pickerView;   //身份选择器

- (id)initWithField:(UITextField *)field andNumberOfComponents:(NSInteger)indexNum andLeftArray:(NSMutableArray *)leftArray andRightDic:(NSMutableDictionary *)rightDic;

@end
