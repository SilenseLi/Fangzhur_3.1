//
//  FZDatePicker.m
//  Fangzhur
//
//  Created by --超-- on 14-7-24.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZDatePicker.h"

@interface FZDatePicker ()
{
    NSString *_currentMonthString;
    NSMutableArray *_yearArray;
    NSArray *_monthArray;
    NSMutableArray *_dayArray;
    UIToolbar *_toolBar;
}

- (void)addPickerView;
- (void)addToolBar;
- (void)installComponents;

@end

#define currentMonth [_currentMonthString integerValue]

int selectedYearRow;
int selectedMonthRow;
int selectedDayRow;

@implementation FZDatePicker

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 162 + 44);
        [self addPickerView];
        [self addToolBar];
        [self installComponents];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)addPickerView
{
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 162)];
    _pickerView.showsSelectionIndicator = YES;
    _pickerView.delegate                = self;
    _pickerView.dataSource              = self;
    [self addSubview:_pickerView];
}

- (void)addToolBar
{
    _toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    _toolBar.userInteractionEnabled = YES;
    
    NSMutableArray *myToolBarItems = [[NSMutableArray alloc]init];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn addTarget:self action:@selector(actionCancel:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.frame = CGRectMake(0, 0, 52, 26);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(0, 0, 52, 26);
    [selectBtn addTarget:self action:@selector(actionDone:) forControlEvents:UIControlEventTouchUpInside];
    [selectBtn setTitle:@"确定" forState:UIControlStateNormal];
    [selectBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    
    UIBarButtonItem *selectButton = [[UIBarButtonItem alloc]initWithCustomView:selectBtn];
    
    
    /* space button */
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] ;
    
    [myToolBarItems addObject:cancelButton];
    [myToolBarItems addObject:flexibleSpace];
    [myToolBarItems addObject:selectButton];
    [_toolBar setItems:myToolBarItems animated:NO];
    [self addSubview:_toolBar];
}

- (void)installComponents
{
    NSDate *date                = [NSDate date];
    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy"];
    NSString *currentYearString = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
    
    [formatter setDateFormat:@"MM"];
    _currentMonthString = [NSString stringWithFormat:@"%d", [[formatter stringFromDate:date] integerValue]];
    
    [formatter setDateFormat:@"dd"];
    NSString *currentDateString = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
    
    // PickerView -  Years data
    _yearArray = [[NSMutableArray alloc] init];
    for (int i = 1970; i <= 2050 ; i++)
    {
        [_yearArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    // PickerView -  Months data
    _monthArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    
    // PickerView -  days data
    _dayArray = [[NSMutableArray alloc] init];
    
    for (int i = 1; i <= 31; i++)
    {
        [_dayArray addObject:[NSString stringWithFormat:@"%d", i]];
        
    }
    
    // PickerView - Default Selection as per current Date
    [self.pickerView selectRow:[_yearArray indexOfObject:currentYearString] inComponent:0 animated:YES];
    [self.pickerView selectRow:[_monthArray indexOfObject:_currentMonthString] inComponent:1 animated:YES];
    [self.pickerView selectRow:[_dayArray indexOfObject:currentDateString] inComponent:2 animated:YES];
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        selectedYearRow = row;
        [self.pickerView reloadAllComponents];
    }
    else if (component == 1)
    {
        selectedMonthRow = row;
        [self.pickerView reloadAllComponents];
    }
    else if (component == 2)
    {
        selectedDayRow = row;
        [self.pickerView reloadAllComponents];
    }
}


#pragma mark - UIPickerViewDatasource

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    
    // Custom View created for each component
    UILabel *pickerLabel = (UILabel *)view;
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 50, 60);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:15.0f]];
    }
    
    if (component == 0) {
        pickerLabel.text =  [_yearArray objectAtIndex:row]; // Year
    }
    else if (component == 1) {
        pickerLabel.text =  [_monthArray objectAtIndex:row];  // Month
    }
    else {
        pickerLabel.text =  [_dayArray objectAtIndex:row]; // Date
    }
    
    return pickerLabel;
    
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (component == 0) {
        return [_yearArray count];
    }
    else if (component == 1) {
        return [_monthArray count];
    }
    else { // day
        if (currentMonth == 1 || currentMonth == 3 || currentMonth == 5 || currentMonth == 7 || currentMonth == 8 || currentMonth == 10 || currentMonth == 12)
        {
            return 31;
        }
        else if (currentMonth == 2)
        {
            int yearint = [[_yearArray objectAtIndex:selectedYearRow] intValue];
            
            if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
                
                return 29;
            }
            else
            {
                return 28; // or return 29
            }
            
        }
        else
        {
            return 30;
        }
    }
}


- (void)actionCancel:(id)sender {
    [_ownerField resignFirstResponder];
}

- (void)actionDone:(id)sender
{
    [_ownerField resignFirstResponder];
    _resultString = [NSString stringWithFormat:@"%@-%@-%@",
                     [_yearArray objectAtIndex:[self.pickerView selectedRowInComponent:0]],
                     [_monthArray objectAtIndex:[self.pickerView selectedRowInComponent:1]],
                     [_dayArray objectAtIndex:[self.pickerView selectedRowInComponent:2]]];
    
    _ownerField.text = _resultString;
}

@end
