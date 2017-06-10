//
//  IncomesListViewController.h
//  Final_Work
//
//  Created by Chang Hao Chao on 2017/6/8.
//  Copyright © 2017年 Chang Hao Chao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemManager;

@interface IncomesListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>


@property (weak) ItemManager* itemManager;

@property (nonatomic, weak) UIViewController* rootViewController;
@property (weak, nonatomic) IBOutlet UITableView *incomeListView;



@end
