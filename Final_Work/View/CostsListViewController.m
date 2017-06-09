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
    NSMutableArray* _items;
    
    
}

#pragma mark - ViewController Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _items = [NSMutableArray new];
    
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

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [_items count];
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
    [_items removeAllObjects];
    NSArray *items = [Item MR_findAllSortedBy:@"name" ascending:YES];
    [_items addObjectsFromArray:items];
    [self.costsListView reloadData];

}

- (Item*)itemAtIndexPath:(NSIndexPath*)indexPath {
    return [_items objectAtIndex:indexPath.row];
}

@end



