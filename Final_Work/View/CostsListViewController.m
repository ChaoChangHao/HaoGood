//
//  CostsListViewController.m
//  Final_Work
//
//  Created by Chang Hao Chao on 2017/6/8.
//  Copyright © 2017年 Chang Hao Chao. All rights reserved.
//

#import "CostsListViewController.h"

#import "CostCell.h"
#import "RootViewController.h"

#import "ItemManager.h"
#import "Item.h"

#import <MagicalRecord/MagicalRecord.h>

@interface CostsListViewController ()

@end

@implementation CostsListViewController {
    NSArray* _items;
    NSMutableArray* _food;
    NSMutableArray* _traffic;
    NSMutableArray* _entertainment;
    NSMutableArray* _else;
    
}

#pragma mark - ViewController Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.costsListView.emptyDataSetSource = self;
    self.costsListView.emptyDataSetDelegate = self;
    // A little trick for removing the cell separators
    self.costsListView.tableFooterView = [UIView new];
    
    _food = [NSMutableArray new];
    _traffic = [NSMutableArray new];
    _entertainment = [NSMutableArray new];
    _else = [NSMutableArray new];
    _items = @[_food, _traffic, _entertainment, _else];
    
    
    [self updateItems];
    
    UINib* nib = [UINib nibWithNibName:@"CostCell" bundle:nil];
    [self.costsListView registerNib:nib forCellReuseIdentifier:CostCellIdentifier];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemsSynchronized) name:ItemsSynchronizedNotificationName object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.rootViewController setTitle:@"Cost"];
    [self.costsListView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"AddItem"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"尚未新增項目哦";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"可以點擊下方➕按鈕，進行項目的新增";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor whiteColor];
}

#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath {
    return YES;
}

- (NSArray<UITableViewRowAction*> *)tableView:(UITableView*)tableView editActionsForRowAtIndexPath:(NSIndexPath*)indexPath {
    NSString* title = @"delete";
    UITableViewRowAction* action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:title handler:^(UITableViewRowAction* _Nonnull action, NSIndexPath* _Nonnull path) {
        Item *deleteItem = [self itemAtIndexPath:indexPath];
        [deleteItem MR_deleteEntity];
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        [[NSNotificationCenter defaultCenter] postNotificationName:ItemsSynchronizedNotificationName object:nil];
    }];
    return @[ action ];
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            if (_food.count == 0) return nil;
            else return @"food";
            break;
        case 1:
            if (_traffic.count == 0) return nil;
            else return @"traffic";
            break;
        case 2:
            if (_entertainment.count == 0) return nil;
            else return @"entertainment";
            break;
        case 3:
            if (_else.count == 0) return nil;
            else return @"else";
            break;
        default:
            return nil;
            break;
    }
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return [_items count];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_items objectAtIndex:section] count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    Item* poster = [self itemAtIndexPath:indexPath];
    CostCell* cell = [tableView dequeueReusableCellWithIdentifier:CostCellIdentifier forIndexPath:indexPath];
    [cell setItem:poster];
    
    return cell;
}


#pragma mark - Private Methods

- (void)itemsSynchronized {
    [self updateItems];
    [self.costsListView reloadData];
}

- (void)updateItems {
    [_food removeAllObjects];
    [_traffic removeAllObjects];
    [_entertainment removeAllObjects];
    [_else removeAllObjects];
    
    
//    NSArray *items = [Item MR_findAll];

    NSArray *items = [Item MR_findByAttribute:@"date" withValue:_rootViewController.currentSelectDate];
    for (Item* item in items) {
        if ([item.category isEqualToString:@"food"]) {
            [_food addObject:item];
        } else if ([item.category isEqualToString:@"traffic"]) {
            [_traffic addObject:item];
        } else if ([item.category isEqualToString:@"entertainment"]) {
            [_entertainment addObject:item];
        } else if ([item.category isEqualToString:@"else"]) {
            [_else addObject:item];
        }
    }
    [self.costsListView reloadData];

}

- (Item*)itemAtIndexPath:(NSIndexPath*)indexPath {
    return [[_items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

@end



