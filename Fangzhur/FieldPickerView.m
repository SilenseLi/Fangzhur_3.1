//
//  FieldPickerView.m
//  test
//
//  Created by L Suk on 14-3-25.
//  Copyright (c) 2014年 L Suk. All rights reserved.
//

#import "FieldPickerView.h"

@implementation FieldPickerView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
- (id)initWithField:(UITextField *)field andNumberOfComponents:(NSInteger)indexNum andLeftArray:(NSMutableArray *)leftArray andRightDic:(NSMutableDictionary *)rightDic
{
    self = [super init];
    if (self) {
        _theField = field;
        _pickerArray = [NSMutableArray arrayWithArray:leftArray];
        _indexNum = indexNum;
        _dic = [NSMutableDictionary dictionaryWithDictionary:rightDic];
        if (_indexNum == 2) {
            NSInteger selectedProvinceIndex = [self.pickerView selectedRowInComponent:0];
            NSString *seletedProvince = [_pickerArray  objectAtIndex:selectedProvinceIndex];
            _rightArray = [rightDic objectForKey:seletedProvince];
        }
        [self createPickerView];
    }
    return self;
}
- (void)createPickerView
{
    _pickerView= [[UIPickerView alloc]initWithFrame:CGRectMake(0,44, 320, 200)];
    _pickerView.showsSelectionIndicator = YES;
    _pickerView.backgroundColor = RGBAColor(241, 241, 241, 0.8);
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [self addSubview:_pickerView];
    
    //toolbar确定选择地址
    UIToolbar *toolsBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,0, 320, 44)];
    toolsBar.userInteractionEnabled = YES;

    NSMutableArray *myToolBarItems = [[NSMutableArray alloc]init];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn addTarget:self action:@selector(cancelToolsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.frame = CGRectMake(0, 0, 52, 26);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(0, 0, 52, 26);
    [selectBtn addTarget:self action:@selector(selectToolsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [selectBtn setTitle:@"确定" forState:UIControlStateNormal];
    [selectBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
                                    
    UIBarButtonItem *selectButton = [[UIBarButtonItem alloc]initWithCustomView:selectBtn];
                                    
    
    /* space button */
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] ;
    
    [myToolBarItems addObject:cancelButton];
    [myToolBarItems addObject:flexibleSpace];
    [myToolBarItems addObject:selectButton];
    [toolsBar setItems:myToolBarItems animated:YES];
    [self addSubview:toolsBar];

}
#pragma mark =====================================      身份选择器代理
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (_indexNum == 1) {
        return 1;
    }else
        return 2;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_indexNum == 1) {
        return  _pickerArray.count;
    }else
    {
        switch (component) {
            case 0:
                return _pickerArray.count;
            case 1:
                return _rightArray.count;
        }
    }
    return 0;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (_indexNum ==1) {
        return self.frame.size.width;
    }else
        return self.frame.size.width/2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [_pickerArray objectAtIndex:row];
            break;
        case 1:
            return [_rightArray objectAtIndex:row];
            break;
        default:
            break;
    }
    return nil;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0;
}
//监听轮子的移动
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        NSString *seletedProvince = [_pickerArray objectAtIndex:row];
        _rightArray = [_dic objectForKey:seletedProvince];
        
        //重点！更新第二个轮子的数据
        if (_indexNum !=1) {
            [self.pickerView reloadComponent:1];
        }
    }
}
#pragma mark ==========================================  身份选择的取消和确定按钮
-(void)cancelToolsButtonClick:(id)sender
{
    [_theField resignFirstResponder];
}
-(void)selectToolsButtonClick:(id)sender
{
    if (_indexNum == 1) {
        NSInteger index = [_pickerView selectedRowInComponent:0];
        NSString *status = [_pickerArray objectAtIndex:index];
        _theField.text = status;
        [_theField resignFirstResponder];
    }else
    {
        NSInteger index = [_pickerView selectedRowInComponent:0];
        NSInteger index1 = [_pickerView selectedRowInComponent:1];

        NSString *status = [_pickerArray objectAtIndex:index];
        NSString *ss = [_rightArray objectAtIndex:index1];
        _theField.text = [NSString stringWithFormat:@"%@ %@",status,ss];
        [_theField resignFirstResponder];
    }
}

@end
