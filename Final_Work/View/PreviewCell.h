//
//  previewCellTableViewCell.h
//  Final_Work
//
//  Created by Chang Hao Chao on 2017/6/15.
//  Copyright © 2017年 Chang Hao Chao. All rights reserved.
//

#import <UIKit/UIKit.h>



@class Item;

FOUNDATION_EXPORT NSString* const PreviewCellIdentifier;

@interface previewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
- (void)setItem:(Item*)aItem;
@end
