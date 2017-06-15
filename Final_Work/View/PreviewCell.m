//
//  PreviewCell.m
//  Final_Work
//
//  Created by Chang Hao Chao on 2017/6/15.
//  Copyright © 2017年 Chang Hao Chao. All rights reserved.
//

#import "PreviewCell.h"
#import "Item.h"


@interface PreviewCell ()

@end

NSString* const PreviewCellIdentifier = @"PreviewCell";

@implementation PreviewCell

- (void)setItem:(Item*)aItem {
    self.nameLabel.text = aItem.name;
    self.priceLabel.text = [NSString stringWithFormat:@"%@  $",aItem.price];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY/MM/dd"];
    self.dateLabel.text = [formatter stringFromDate:aItem.date];
    if (aItem.image) {
        UIImage *image = [UIImage imageWithData:aItem.image];
        
        [self.photoView setImage:image];
    }
    
    //    self.ItemPhotoImage.layer.masksToBounds = YES;
    //    self.ItemPhotoImage.layer.borderColor = [UIColor main].CGColor;
    //    self.ItemPhotoImage.layer.cornerRadius = self.aItem.frame.size.width / 2;
    //    [self.ItemPhotoImage setImageWithPath:aItem.portraitPath andPlaceholder:nil];
}

@end
