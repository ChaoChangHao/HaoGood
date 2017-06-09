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

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
//    Item* poster = [self itemAtIndexPath:indexPath];
    CostCell* cell = [tableView dequeueReusableCellWithIdentifier:CostCellIdentifier forIndexPath:indexPath];
//    [cell setItem:poster];
    cell.ItemNameLabel.text = [NSString stringWithFormat:@"Nametest"];
    cell.ItemPriceLabel.text = [NSString stringWithFormat:@"20 $"];
    
    return cell;
}


#pragma mark - Private Methods

- (void)itemsSynchronized {
    [self updateItems];
    [self.costsListView reloadData];
}

- (void)updateItems {
    
}

- (Item*)itemAtIndexPath:(NSIndexPath*)indexPath {
    return [[_items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

@end



