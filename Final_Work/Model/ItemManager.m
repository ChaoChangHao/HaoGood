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

NSString* const ItemsSynchronizedNotificationName = @"ItemsSynchronized";

@implementation ItemManager {
    NSMutableDictionary* _items;
}

- (instancetype)initWithLocal {
    if ([super init]) {
        _items = [NSMutableDictionary new];
        NSArray* localItems = [Item MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
        for (Item* item in localItems) {
            [_items setObject:item forKey:item.name];
        }
    }
    return self;
}


- (Item*)getItem:(NSString*)Name {
    return _items[Name];
}

- (NSArray*)items {
    return _items.allValues;
}

@end
