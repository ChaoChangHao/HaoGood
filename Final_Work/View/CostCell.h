//
//  CostCellViewController.h
//  Final_Work
//
//  Created by Chang Hao Chao on 2017/6/8.
//  Copyright © 2017年 Chang Hao Chao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Item;

FOUNDATION_EXPORT NSString* const CostCellIdentifier;

@interface CostCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *ItemNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *ItemPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ItemPhotoImage;

- (void)setItem:(Item*)aItem;
    
@end
