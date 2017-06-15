//
//  PreviewViewController.h
//  Final_Work
//
//  Created by Chang Hao Chao on 2017/6/15.
//  Copyright © 2017年 Chang Hao Chao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

@interface PreviewViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *previewList;
@property (strong, nonatomic) IBOutlet UIView *Container;

@property (nonatomic) NSMutableArray *items;
@end
