//
//  ItemManager.h
//  Final_Work
//
//  Created by Chang Hao Chao on 2017/6/8.
//  Copyright © 2017年 Chang Hao Chao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

FOUNDATION_EXPORT NSString* const ItmesSynchronizedNotificationName;


@interface ItemManager : NSObject

- (Item*)getItem:(NSString*)itemName;

@property (readonly) NSArray* items;


@end
