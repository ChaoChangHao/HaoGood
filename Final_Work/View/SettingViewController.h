//
//  SettingViewController.h
//  Final_Work
//
//  Created by Chang Hao Chao on 2017/6/13.
//  Copyright © 2017年 Chang Hao Chao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface SettingViewController : UIViewController<UITextFieldDelegate>


@property (nonatomic) RootViewController* rootViewController;
@property (weak, nonatomic) IBOutlet UITextField *budgetTextField;
@property (weak, nonatomic) IBOutlet UITextField *startDateTextField;
@end
