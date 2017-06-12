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
    return nil;
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



