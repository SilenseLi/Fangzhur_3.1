//
//  ZCPickerView.m
//  SelfBusiness
//
//  Created by --Chao-- on 14-6-10.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "ZCPickerView.h"

@interface ZCPickerView ()
{
    NSDictionary *_rightDict;
    NSArray *_leftArray;
    NSArray *_rightArray;
}

@property (nonatomic, retain) UITextField *selectedField;
@property (nonatomic, assign) NSInteger components;

- (void)createPickerView;

@end

@implementation ZCPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithField:(UITextField *)field numberOfComponents:(NSInteger)components
          leftArray:(NSArray *)leftArray rightDict:(NSDictionary *)rightDict
{
    self = [super init];
    if (self) {
        self.selectedField = field;
        _leftArray = [NSArray arrayWithArray:leftArray];
        _rightDict = [[NSDictionary alloc] initWithDictionary:rightDict];
        _components = components;
        
        if (_components == 2) {
            NSString *leftSelectedString = [_leftArray objectAtIndex:0];
            _rightArray = [rightDict objectForKey:leftSelectedString];
        }
        [self createPickerView];
    }
    return self;
}

- (void)addTarget:(id)target action:(SEL)action
{
    self.target = target;
    self.action = action;
}

- (void)createPickerView
{
    _pickerView= [[UIPickerView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, 320, 216)];
    _pickerView.showsSelectionIndicator = YES;
    _pickerView.backgroundColor = RGBAColor(241, 241, 241, 0.8);
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [self addSubview:_pickerView];
    
    //==============================================
    UIToolbar *toolsBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT, 320, 44)];
    toolsBar.barTintColor = RGBColor(2, 96, 172);
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn addTarget:self action:@selector(cancelToolBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.frame = CGRectMake(0, 0, 52, 26);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(0, 0, 52, 26);
    [selectBtn addTarget:self action:@selector(selectToolBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [selectBtn setTitle:@"确定" forState:UIControlStateNormal];
    [selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    
    UIBarButtonItem *selectButton = [[UIBarButtonItem alloc]initWithCustomView:selectBtn];
    
    
    /* space button */
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSMutableArray *toolBarItems = [[NSMutableArray alloc]init];
    
    [toolBarItems addObject:cancelButton];
    [toolBarItems addObject:flexibleSpace];
    [toolBarItems addObject:selectButton];
    [toolsBar setItems:toolBarItems animated:NO];
    [self addSubview:toolsBar];
    
}

#pragma mark - Button Action -

-(void)cancelToolBarButtonClick:(id)sender
{
    [_selectedField resignFirstResponder];
}

-(void)selectToolBarButtonClick:(id)sender
{
    if (_components == 1) {
        NSInteger index = [_pickerView selectedRowInComponent:0];
        if (_leftArray.count == 0) {
            _selectedField.text = @"";
        }
        else {
            _selectedField.text = [_leftArray objectAtIndex:index];
        }
        
        [_selectedField resignFirstResponder];
    }else
    {
        NSInteger leftIndex = [_pickerView selectedRowInComponent:0];
        NSInteger rightIndex = [_pickerView selectedRowInComponent:1];
        
        NSString *leftStr = [_leftArray objectAtIndex:leftIndex];
        NSString *rightStr = [_rightArray objectAtIndex:rightIndex];
        _selectedField.text = [NSString stringWithFormat:@"%@ %@",leftStr, rightStr];
        [_selectedField resignFirstResponder];
    }
}

#pragma mark - Picker view delegate -

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (_components == 1) {
        return 1;
    }
    else {
        return 2;
    }
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_components == 1) {
        return _leftArray.count;
    }
    else {
        if (component == 0) {
            return _leftArray.count;
        }
        else {
            return _rightArray.count;
        }
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (_components == 1) {
        return self.frame.size.width;
    }
    else {
        return self.frame.size.width / 2;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [_leftArray objectAtIndex:row];
            break;
        case 1:
            return [_rightArray objectAtIndex:row];
            break;
        default:
            return nil;
            break;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0f;
}

//监听轮子的移动
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        NSString *leftSelectedString = [_leftArray objectAtIndex:row];
        _rightArray = [_rightDict objectForKey:leftSelectedString];
        self.selectedIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
        
        if ([_target respondsToSelector:_action]) {
            [_target performSelector:_action withObject:self];
        }
        //更新第二个轮子的数据
        if (_components != 1) {
            [self.pickerView reloadComponent:1];
        }
    }
}

@end
