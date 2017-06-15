//
//  CostsListViewController.h
//  Final_Work
//
//  Created by Chang Hao Chao on 2017/6/8.
//  Copyright © 2017年 Chang Hao Chao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@class ItemManager;
@class RootViewController;


@interface CostsListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UIViewControllerPreviewingDelegate>


@property (weak) ItemManager* itemManager;

@property (weak) RootViewController* rootViewController;
@property (weak, nonatomic) IBOutlet UITableView *costsListView;

@property (weak, nonatomic) IBOutlet UILabel *budgetBarLabel;
@property (weak, nonatomic) IBOutlet UITextField *dateSelectTextField;

@property (nonatomic) NSDate *currentSelectDate;



@end
