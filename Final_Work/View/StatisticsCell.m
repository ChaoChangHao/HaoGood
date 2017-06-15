//
//  StatisticsCell.m
//  Final_Work
//
//  Created by Chang Hao Chao on 2017/6/15.
//  Copyright © 2017年 Chang Hao Chao. All rights reserved.
//

#import "StatisticsCell.h"
#import "Item.h"

@interface StatisticsCell ()

@end

NSString* const StatisticsCellIdentifier = @"StatisticsCell";

@implementation StatisticsCell

- (void)setItem:(Item*)aItem itemRank:(NSInteger)rank {
    self.rankLabel.text = [NSString stringWithFormat:@"%li",(long)rank+1];
    self.categoryLabel.text = aItem.name;
    self.priceLabel.text = [NSString stringWithFormat:@"%@  $",aItem.price];
}

@end
