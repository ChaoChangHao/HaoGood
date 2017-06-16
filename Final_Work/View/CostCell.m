//
//  CostCellViewController.m
//  Final_Work
//
//  Created by Chang Hao Chao on 2017/6/8.
//  Copyright © 2017年 Chang Hao Chao. All rights reserved.
//

#import "CostCell.h"
#import "Item.h"


@interface CostCell ()

@end

NSString* const CostCellIdentifier = @"CostCell";

@implementation CostCell

- (void)setItem:(Item*)aItem {
    self.ItemNameLabel.text = aItem.name;
    self.ItemPriceLabel.text = [NSString stringWithFormat:@"%@  $",aItem.price];
    UIImage *image = [UIImage imageWithData:aItem.image];
    
    [_ItemPhotoImage setImage:image];

//    self.ItemPhotoImage.layer.masksToBounds = YES;
//    self.ItemPhotoImage.layer.borderColor = [UIColor main].CGColor;
//    self.ItemPhotoImage.layer.cornerRadius = self.aItem.frame.size.width / 2;
//    [self.ItemPhotoImage setImageWithPath:aItem.portraitPath andPlaceholder:nil];
}


@end
