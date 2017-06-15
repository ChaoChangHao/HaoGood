//
//  PreviewViewController.m
//  Final_Work
//
//  Created by Chang Hao Chao on 2017/6/15.
//  Copyright © 2017年 Chang Hao Chao. All rights reserved.
//

#import "PreviewViewController.h"
#import "PreviewCell.h"
#import "CostCell.h"

#import <MagicalRecord/MagicalRecord.h>

@interface PreviewViewController ()

@end

@implementation PreviewViewController {
    NSMutableArray *_items;
    NSCalendar *_calendar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _previewList.delegate = self;
    _previewList.dataSource = self;
    
    _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    UINib* nib = [UINib nibWithNibName:@"CostCell" bundle:nil];
    [self.previewList registerNib:nib forCellReuseIdentifier:CostCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self updateItems];
    
}
#pragma mark - UITableViewDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 100;
//}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [_items count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    Item *poster = [self itemAtIndexPath:indexPath];
    CostCell* cell = [tableView dequeueReusableCellWithIdentifier:CostCellIdentifier forIndexPath:indexPath];
    [cell setItem:poster];
    return cell;
}
#pragma mark - Private Method
- (Item*)itemAtIndexPath:(NSIndexPath*)indexPath {
    return [_items objectAtIndex:indexPath.row];
}
- (void)updateItems {
    
    _items = [NSMutableArray new];
    
    NSDateComponents *components = [_calendar components:NSCalendarUnitDay fromDate:_startDate];
    for (int i = 0; i <= _dayTimeInterval; i++) {
        [components setDay:i];
        NSDate *selectDate = [_calendar dateByAddingComponents:components toDate:_startDate options:0];
        
        NSArray *items = [Item MR_findByAttribute:@"date" withValue:selectDate];
        for (Item* item in items) {
            if (!item.name || !item.price) continue;
            if ([item.category isEqualToString:_keyword]) {
                [_items addObject:item];
            }
        }
    }
    [_previewList reloadData];
}
@end
