//
//  RootViewController.h
//  Final_Work
//
//  Created by Chang Hao Chao on 2017/6/6.
//  Copyright © 2017年 Chang Hao Chao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemManager;

@interface RootViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UIButton *IncomeButton;
@property (weak, nonatomic) IBOutlet UIButton *outcomButton;
@property (weak, nonatomic) IBOutlet UIButton *statisticsButton;
@property (weak, nonatomic) IBOutlet UIButton *settingButton;
@property (weak, nonatomic) IBOutlet UIButton *addItemButton;

@property ItemManager* itemManager;

@end
