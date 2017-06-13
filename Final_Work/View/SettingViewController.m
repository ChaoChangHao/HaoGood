//
//  SettingViewController.m
//  Final_Work
//
//  Created by Chang Hao Chao on 2017/6/13.
//  Copyright © 2017年 Chang Hao Chao. All rights reserved.
//

#import "SettingViewController.h"
#import "CostsListViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController {
    CostsListViewController *_costListsViewController;
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
    _costListsViewController = [[CostsListViewController alloc] initWithNibName:@"CostsListView" bundle:nil];
    self.budgetTextField.text = [NSString stringWithFormat:@"%lu",(unsigned long)_costListsViewController.budgetValue];
}

-(void)budgetTextFieldDoneButtonPressed
{
    [_budgetTextField resignFirstResponder];
}


@end
