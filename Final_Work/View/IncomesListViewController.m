//
//  IncomesListViewController.m
//  Final_Work
//
//  Created by Chang Hao Chao on 2017/6/8.
//  Copyright © 2017年 Chang Hao Chao. All rights reserved.
//

#import "IncomesListViewController.h"

#import "CostCell.h"
#import "RootViewController.h"

#import "ItemManager.h"
#import "Item.h"

#import <MagicalRecord/MagicalRecord.h>

@interface IncomesListViewController ()

@end

@implementation IncomesListViewController {
    NSArray* _items;
    NSMutableArray* _income;
}

#pragma mark - ViewController Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.incomeListView.emptyDataSetSource = self;
    self.incomeListView.emptyDataSetDelegate = self;
    // A little trick for removing the cell separators
    self.incomeListView.tableFooterView = [UIView new];

    
    _income = [NSMutableArray new];
    _items = @[_income];
    
    
    [self updateItems];
    
    UINib* nib = [UINib nibWithNibName:@"CostCell" bundle:nil];
    [self.incomeListView registerNib:nib forCellReuseIdentifier:CostCellIdentifier];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemsSynchronized) name:ItemsSynchronizedNotificationName object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.rootViewController setTitle:@"Income"];
    [self.incomeListView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"picture"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"尚未新增項目";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"點擊下方➕按鈕，進行項目新增";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
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

-(void) tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([view isKindOfClass: [UITableViewHeaderFooterView class]]) {
        UITableViewHeaderFooterView* castView = (UITableViewHeaderFooterView*) view;
        UIView* content = castView.contentView;
        content.backgroundColor  = [UIColor colorWithRed:0.584 green:1 blue:0.816 alpha:1];
    }
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
    return @"income";
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
    [self.incomeListView reloadData];
}

- (void)updateItems {
    [_income removeAllObjects];
    
    //    NSArray *items = [Item MR_findAll];
    
    NSArray *items = [Item MR_findByAttribute:@"date" withValue:_rootViewController.currentSelectDate];
    for (Item* item in items) {
        if ([item.category isEqualToString:@"income"]) {
            [_income addObject:item];
        }
    }
    [self.incomeListView reloadData];
    
}

- (Item*)itemAtIndexPath:(NSIndexPath*)indexPath {
    return [[_items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

@end



