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
    UIDatePicker *datePicker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _itemName.delegate = self;
    _itemPrice.delegate = self;
    _itemDate.delegate = self;
    
    datePicker = [[UIDatePicker alloc] init];
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
    [_itemDate setInputView:datePicker];
    datePicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventValueChanged];
    
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(ShowSelectedDate)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [_itemDate setInputAccessoryView:toolBar];
    
    UIBarButtonItem *doneBtn2 = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonPressed:)];
    [toolBar setItems:[NSArray arrayWithObjects:space, doneBtn2, nil]];
    [_itemPrice setInputAccessoryView:toolBar];
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

    
    if(textField.tag == 0) {
    }
    else if(textField.tag == 1) {
    }
    else if(textField.tag == 2) {
        if (datePicker.superview) {
            [datePicker removeFromSuperview];
        } else {
            [self chooseDate:datePicker];
        }
    }
    
    
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

//    _itemDate.inputView = datePicker;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"])
    {
        [textField resignFirstResponder];
        return NO;
    }
    
    return YES;
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
-(void)chooseDate:(UIDatePicker *)datePick
{
    NSDate *selectedDate = datePick.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY/MM/dd"];
    _itemDate.text = [formatter stringFromDate:selectedDate];
}
-(void)ShowSelectedDate
{   NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY/MM/dd"];
    _itemDate.text = [formatter stringFromDate:datePicker.date];
    [_itemDate resignFirstResponder];
}
-(void)doneButtonPressed:(UIDatePicker*)datePick
{
    [_itemPrice resignFirstResponder];
}

@end
