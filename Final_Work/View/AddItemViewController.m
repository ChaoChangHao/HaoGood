//
//  AddItemViewController.m
//  Final_Work
//
//  Created by Chang Hao Chao on 2017/6/10.
//  Copyright © 2017年 Chang Hao Chao. All rights reserved.
//

#import "AddItemViewController.h"
#import "RootViewController.h"

#import "Item.h"
#import "ItemManager.h"

#import <MagicalRecord/MagicalRecord.h>


@interface AddItemViewController ()

@end

@implementation AddItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.rootViewController setTitle:@"Add Item"];
//    [self.addItemView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)photoButtonPressed:(id)sender {
}

- (IBAction)confirmButtonPressed:(id)sender {
    Item *item = [Item MR_createEntity];
    item.name = _itemName.text;
    item.priceValue = [_itemPrice.text floatValue];
    item.category = [NSString stringWithFormat:@"navigation"];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    //Inform app
    [[NSNotificationCenter defaultCenter] postNotificationName:ItemsSynchronizedNotificationName object:nil];
    
    //dismiss view
    [self.navigationController popViewControllerAnimated:YES];

}


@end
