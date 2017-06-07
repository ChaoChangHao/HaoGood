//
//  UIView+Utils.m
//  Final_Work
//
//  Created by Chang Hao Chao on 2017/6/7.
//  Copyright © 2017年 Chang Hao Chao. All rights reserved.
//

#import "UIView+Utils.h"

@implementation UIView (Utils)

- (void)addSubview:(UIView*)subView fit:(BOOL)fit {
    [self addSubview:subView];
    if (fit) {
        [subView setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSDictionary* dictionary = NSDictionaryOfVariableBindings(subView);
        NSArray* constraintsArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[subView]-0-|" options:0 metrics:nil views:dictionary];
        [self addConstraints:constraintsArray];
        constraintsArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[subView]-0-|" options:0 metrics:nil views:dictionary];
        [self addConstraints:constraintsArray];
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
