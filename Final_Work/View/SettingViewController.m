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
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _budgetTextField.delegate = self;
    
    //space
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIToolbar *nameToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [nameToolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *nameDoneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(budgetTextFieldDoneButtonPressed)];
    
    [nameToolBar setItems:[NSArray arrayWithObjects:space,nameDoneBtn, nil]];
    [_budgetTextField setInputAccessoryView:nameToolBar];
    ////////////////////////////////////////////////////////////////
    NSInteger budget = [[NSUserDefaults standardUserDefaults] integerForKey:@"budget"];
    _budgetTextField.text = [NSString stringWithFormat:@"%ld",(long)budget];
}

-(void)budgetTextFieldDoneButtonPressed
{
    NSInteger budget = [_budgetTextField.text integerValue];
    [[NSUserDefaults standardUserDefaults] setInteger:budget forKey:@"budget"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [_budgetTextField resignFirstResponder];
}

@end
