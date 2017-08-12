//
//  AddItemViewController.h
//  Final_Work
//
//  Created by Chang Hao Chao on 2017/6/10.
//  Copyright © 2017年 Chang Hao Chao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import <TZImagePickerController/TZImagePickerController-umbrella.h>

@interface AddItemViewController : UIViewController<UITextFieldDelegate, TZImagePickerControllerDelegate>


@property (nonatomic, weak) RootViewController* rootViewController;

@property (strong, nonatomic) IBOutlet UIView *addItemView;

@property (weak, nonatomic) IBOutlet UITextField *itemName;
@property (weak, nonatomic) IBOutlet UITextField *itemPrice;
@property (weak, nonatomic) IBOutlet UITextField *itemDate;
@property (weak, nonatomic) IBOutlet UIButton *itemImage;

@property(nonatomic) Item *item;

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@end
