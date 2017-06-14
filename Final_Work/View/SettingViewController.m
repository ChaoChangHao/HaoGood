//
//  SettingViewController.m
//  Final_Work
//
//  Created by Chang Hao Chao on 2017/6/13.
//  Copyright © 2017年 Chang Hao Chao. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController {
    UIDatePicker *datePicker;
    NSDateFormatter *formatter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _budgetTextField.delegate = self;
    datePicker = [[UIDatePicker alloc] init];
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
//    [_startDateTextField setInputView:datePicker];
    datePicker.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventValueChanged];
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY/MM/dd"];
//    [self chooseDate:datePicker];

    
    //space
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    //budget
    UIToolbar *budgetToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [budgetToolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *nameDoneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(budgetTextFieldDoneButtonPressed)];
    
    [budgetToolBar setItems:[NSArray arrayWithObjects:space,nameDoneBtn, nil]];
    [_budgetTextField setInputAccessoryView:budgetToolBar];
    //date
    UIToolbar *dateToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [dateToolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *dateDoneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(startDateTextFieldDoneButtonPressed)];
    [dateToolBar setItems:[NSArray arrayWithObjects:space,dateDoneBtn, nil]];
    [_startDateTextField setInputAccessoryView:dateToolBar];
    
    ////////////////////////////////////////////////////////////////
    NSInteger budget = [[NSUserDefaults standardUserDefaults] integerForKey:@"budget"];

    NSInteger startDate = [[NSUserDefaults standardUserDefaults] integerForKey:@"startdate"];
    
    _budgetTextField.text = [NSString stringWithFormat:@"%ld",(long)budget];
    _startDateTextField.text = [NSString stringWithFormat:@"%ld",(long)startDate];
}

-(void)budgetTextFieldDoneButtonPressed
{
    NSInteger budget = [_budgetTextField.text integerValue];
    [[NSUserDefaults standardUserDefaults] setInteger:budget forKey:@"budget"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [_budgetTextField resignFirstResponder];
}

-(void)startDateTextFieldDoneButtonPressed
{
    NSInteger startDate = [_startDateTextField.text integerValue];
    [[NSUserDefaults standardUserDefaults] setInteger:startDate forKey:@"startdate"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [_startDateTextField resignFirstResponder];
}

-(void)chooseDate:(UIDatePicker *)datePick
{
    NSDate *selectedDate = datePick.date;
    _startDateTextField.text = [formatter stringFromDate:selectedDate];
}
@end
