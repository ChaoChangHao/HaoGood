//
//  AddItemViewController.m
//  Final_Work
//
//  Created by Chang Hao Chao on 2017/6/10.
//  Copyright © 2017年 Chang Hao Chao. All rights reserved.
//

#import "AddItemViewController.h"
#import "RootViewController.h"

#import "Item.h"
#import "ItemManager.h"

#import <MagicalRecord/MagicalRecord.h>


@interface AddItemViewController ()

@end

@implementation AddItemViewController {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _itemName.delegate = self;
    _itemPrice.delegate = self;
    _itemDate.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.rootViewController setTitle:@"Add Item"];
    //    [self.addItemView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    
    //設定動畫開始時的狀態為目前畫面上的樣子
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    _addItemView.frame = CGRectMake(_addItemView.frame.origin.x,
                                 _addItemView.frame.origin.y - 210,
                                 _addItemView.frame.size.width,
                                 _addItemView.frame.size.height);
    
    [UIView commitAnimations];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    
    //設定動畫開始時的狀態為目前畫面上的樣子
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    _addItemView.frame = CGRectMake(_addItemView.frame.origin.x,
                                    _addItemView.frame.origin.y + 210,
                                    _addItemView.frame.size.width,
                                    _addItemView.frame.size.height);
    
    [UIView commitAnimations];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _itemDate.placeholder = @"YYYY / MM / DD";
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    NSLocale *datelocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
    datePicker.locale = datelocale;
    datePicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventValueChanged];
    _itemDate.inputView = datePicker;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

#pragma mark - IBAction
- (IBAction)photoButtonPressed:(id)sender {
}

- (IBAction)confirmButtonPressed:(id)sender {
    
    if (_itemPrice.text.length > 0 & _itemName.text.length > 0) {
        
        Item *item = [Item MR_createEntity];
        item.name = _itemName.text;
        item.priceValue = [_itemPrice.text floatValue];
        item.category = [NSString stringWithFormat:@"navigation"];
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        
        //Inform app
        [[NSNotificationCenter defaultCenter] postNotificationName:ItemsSynchronizedNotificationName object:nil];
        
        //dismiss view
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning!" message:@"名字、價錢或日期未填" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:^{}];
    }
    
    
}

#pragma mark - private method
-(void)chooseDate:(UIDatePicker *)datePicker
{
    NSDate *date = datePicker.date;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"YYYY/MM/dd"];
    _itemDate.text = [df stringFromDate:date];
}


@end
