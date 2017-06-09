//
//  ItemManager.m
//  Final_Work
//
//  Created by Chang Hao Chao on 2017/6/8.
//  Copyright © 2017年 Chang Hao Chao. All rights reserved.
//

#import "ItemManager.h"

#import <MagicalRecord/MagicalRecord.h>

#import "Item.h"

NSString* const ItmesSynchronizedNotificationName = @"ItmesSynchronized";

@implementation ItemManager {
    NSMutableDictionary* _items;
}

- (Item*)getItem:(NSString*)itemName {
    return _items[itemName];
}

- (NSArray*)items {
    return _items.allValues;
}



#pragma mark - Private Methods


@end
