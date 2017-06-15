//
//  StatisticsCell.h
//  Final_Work
//
//  Created by Chang Hao Chao on 2017/6/15.
//  Copyright © 2017年 Chang Hao Chao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Item;

FOUNDATION_EXPORT NSString* const StatisticsCellIdentifier;

@interface StatisticsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;




- (void)setItem:(Item*)aItem itemRank:(NSInteger)rank;

@end
