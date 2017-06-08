//
//  IncomesListViewController.m
//  Final_Work
//
//  Created by Chang Hao Chao on 2017/6/8.
//  Copyright © 2017年 Chang Hao Chao. All rights reserved.
//

#import "IncomesListViewController.h"

#import "ItemManager.h"

#import "CostCell.h"
#import "RootViewController.h"


@interface IncomesListViewController ()

@end

@implementation IncomesListViewController {
    NSArray* _items;
    NSMutableArray* _others;
    NSMutableArray* _prices;
}

#pragma mark - ViewController Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    _prices = [NSMutableArray new];
    _others = [NSMutableArray new];
    _items = @[ _prices, _others ];
    
    [self updateFriends];
    UINib* nib = [UINib nibWithNibName:@"CostCell" bundle:nil];
    [self.incomeListView registerNib:nib forCellReuseIdentifier:CostCellIdentifier];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemsSynchronized) name:itemsSynchronizedNotificationName object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.rootViewController setTitle:@"Income"];
//    [self.incomeListView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath {
    return YES;
}

- (NSArray<UITableViewRowAction*> *)tableView:(UITableView*)tableView editActionsForRowAtIndexPath:(NSIndexPath*)indexPath {
    NSString* title = indexPath.section == 0 ? @"Unlike" : @"Like";
    UITableViewRowAction* action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:title handler:^(UITableViewRowAction* _Nonnull action, NSIndexPath* _Nonnull path) {
        [self updateFavoriteStateAtIndexPath:path];
    }];
    return @[ action ];
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    Item* item = [self itemAtIndexPath:indexPath];
    //    [self.rootViewController showPhotosOfItem:item.name];
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
    return (section == 0)? @"Favorites" : @"Others";
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel* label = [UILabel new];
    UIFont* font = [UIFont boldSystemFontOfSize:12];
    label.text = (section == 0)? @"  Favorites" : @"  Others";
    label.font = font;
    label.textColor = [UIColor redColor];
    label.backgroundColor = [UIColor blackColor];
    return label;
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
    [self updateFriends];
    [self.incomeListView reloadData];
}

- (void)updateFriends {
    [_others removeAllObjects];
    [_prices removeAllObjects];
    for (Item* item in self.itemManager.items) {
        if (item.priceValue) {
            [_prices addObject:item];
        }
        else {
            [_others addObject:item];
        }
    }
}
- (void)updateFavoriteStateAtIndexPath:(NSIndexPath*)indexPath {
    Item* item = [self itemAtIndexPath:indexPath];
    
    [self updateFriends];
    NSIndexPath* pathToInsert = [self indexPathOfPoster:item];
    [self.incomeListView beginUpdates];
    [self.incomeListView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationLeft];
    [self.incomeListView insertRowsAtIndexPaths:@[ pathToInsert ] withRowAnimation:UITableViewRowAnimationRight];
    [self.incomeListView endUpdates];
}

- (Item*)itemAtIndexPath:(NSIndexPath*)indexPath {
    return [[_items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

- (NSIndexPath*)indexPathOfPoster:(Item*)poster {
    NSUInteger row = [_prices indexOfObject:poster];
    if (row != NSNotFound) {
        return [NSIndexPath indexPathForRow:row inSection:0];
    }
    else {
        return [NSIndexPath indexPathForRow:[_others indexOfObject:poster] inSection:1];
    }
}

@end
