//
//  RootViewController.m
//  Final_Work
//
//  Created by Chang Hao Chao on 2017/6/6.
//  Copyright © 2017年 Chang Hao Chao. All rights reserved.
//

#import "RootViewController.h"
#import "AddItemViewController.h"

#import "CostsListViewController.h"
#import "IncomesListViewController.h"
#import "StatisticsChartViewController.h"
#import "SettingViewController.h"


#import "Item.h"
#import "ItemManager.h"

#import "UIView+Utils.h"

#import <CKCircleMenuView/CKCircleMenuView.h>
#import <MagicalRecord/MagicalRecord.h>

@interface RootViewController () <CKCircleMenuDelegate>

@property (nonatomic) int subButtonCount;
@property (nonatomic) NSArray* imageArray;
@property (nonatomic) CGFloat angle;
@property (nonatomic) CGFloat delay;
@property (nonatomic) int shadow;
@property (nonatomic) CGFloat radius;
@property (nonatomic) int direction;


@property (nonatomic) CKCircleMenuView* circleMenuView;

@end


@implementation RootViewController {
    CostsListViewController* _costsListViewController;
    IncomesListViewController* _incomesListViewController;
    StatisticsChartViewController* _statisticsChartViewController;
    SettingViewController* _settingViewController;
    
    
    NSArray* _titles;
    NSArray* _tabButtons;
    NSArray* _viewControllers;
    
    NSInteger _selectedIndex;
    UIViewController* _currentController;

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //tab bar button
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    _tabButtons = @[ _IncomeButton, _outcomButton, _statisticsButton, _settingButton ];
    
    _selectedIndex = 0;
    
    _costsListViewController = [[CostsListViewController alloc] initWithNibName:@"CostsListView" bundle:nil];
    _incomesListViewController = [[IncomesListViewController alloc] initWithNibName:@"IncomesListView" bundle:nil];
    _statisticsChartViewController = [[StatisticsChartViewController alloc] initWithNibName:@"StatisticsChartView" bundle:nil];
    _settingViewController = [[SettingViewController alloc] initWithNibName:@"SettingView" bundle:nil];
    
    
    _viewControllers = @[ _costsListViewController, _incomesListViewController, _statisticsChartViewController, _settingViewController];
    
    _costsListViewController.rootViewController = self;
    _costsListViewController.itemManager = self.itemManager;
    
    _incomesListViewController.rootViewController = self;
    
    _statisticsChartViewController.rootViewController = self;
    
    _settingViewController.rootViewController = self;
    
    
    [self setSelectedIndex:0];
    [self setTitle:@"Cost"];

    //======================================================================//
    // Circle button
    self.imageArray = @[[UIImage imageNamed:@"entertainment"], [UIImage imageNamed:@"transport"], [UIImage imageNamed:@"food"], [UIImage imageNamed:@"other"], [UIImage imageNamed:@"incomeItem"]];
    self.subButtonCount = 5;
    self.angle = 120.0;
    self.delay = 0.1;
    self.shadow = 1;
    self.radius = 120;
    self.direction = CircleMenuDirectionLeftUp;


}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - IBActions
- (IBAction)tabButtonPressed:(id)sender {
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton* button = (UIButton*)sender;
        [self setSelectedIndex:(button.tag - 1)];
    }
}

- (IBAction)addItemButton:(UIButton *)sender {
    
    if (self.circleMenuView) {
        
        [self.circleMenuView closeMenu];
        self.circleMenuView = nil;
        [self.addItemButton setTitle:@"" forState:UIControlStateNormal];
    } else {
        CGPoint tPoint = CGPointMake(CGRectGetMidX(sender.bounds), CGRectGetMidY(sender.bounds));
        tPoint = [self.view convertPoint:tPoint fromView:sender];
        
        NSMutableDictionary* tOptions = [NSMutableDictionary new];
        
        [tOptions setValue:[NSDecimalNumber numberWithFloat:self.delay] forKey:CIRCLE_MENU_OPENING_DELAY];
        [tOptions setValue:[NSDecimalNumber numberWithFloat:self.angle] forKey:CIRCLE_MENU_MAX_ANGLE];
        [tOptions setValue:[NSDecimalNumber numberWithFloat:self.radius] forKey:CIRCLE_MENU_RADIUS];
        [tOptions setValue:[NSNumber numberWithInt:self.direction] forKey:CIRCLE_MENU_DIRECTION];
        [tOptions setValue:[UIColor colorWithRed:0.0 green:0.25 blue:0.5 alpha:1.0] forKey:CIRCLE_MENU_BUTTON_BACKGROUND_NORMAL];
        [tOptions setValue:[UIColor colorWithRed:0.25 green:0.5 blue:0.75 alpha:1.0] forKey:CIRCLE_MENU_BUTTON_BACKGROUND_ACTIVE];
        [tOptions setValue:[UIColor colorWithRed:0.25 green:0.5 blue:0.75 alpha:1.0] forKey:CIRCLE_MENU_BUTTON_BORDER];
        [tOptions setValue:[NSNumber numberWithInt:shadow] forKey:CIRCLE_MENU_DEPTH];
        [tOptions setValue:[NSDecimalNumber decimalNumberWithString:@"30.0"] forKey:CIRCLE_MENU_BUTTON_RADIUS];
        [tOptions setValue:[NSDecimalNumber decimalNumberWithString:@"0"] forKey:CIRCLE_MENU_BUTTON_BORDER_WIDTH];
        [tOptions setValue:[NSNumber numberWithBool:YES] forKey:CIRCLE_MENU_TAP_MODE];
        [tOptions setValue:[NSNumber numberWithBool:NO] forKey:CIRCLE_MENU_LINE_MODE];
        [tOptions setValue:[NSNumber numberWithBool:NO] forKey:CIRCLE_MENU_BACKGROUND_BLUR];
        [tOptions setValue:[NSNumber numberWithBool:NO] forKey:CIRCLE_MENU_BUTTON_TINT];
        
        CKCircleMenuView* tMenu = [[CKCircleMenuView alloc] initAtOrigin:tPoint usingOptions:tOptions withImageArray:self.imageArray];
        tMenu.delegate = self;
        [self.view addSubview:tMenu];
        [tMenu openMenu];
        self.circleMenuView = tMenu;
    }
}


#pragma mark - Private Methods


- (void)circleMenuActivatedButtonWithIndex:(int)anIndex
{
    
    AddItemViewController *viewController = [[AddItemViewController alloc] initWithNibName:@"AddItemView" bundle:nil];
    
    
    
    
    viewController.item = [Item MR_createEntity];
    viewController.item.date = _costsListViewController.currentSelectDate;
    if (anIndex == 0) {
        viewController.item.category = [NSString stringWithFormat:@"entertainment"];
    } else if (anIndex == 1) {
        viewController.item.category = [NSString stringWithFormat:@"traffic"];
    } else if (anIndex == 2) {
        viewController.item.category = [NSString stringWithFormat:@"food"];
    } else if (anIndex == 3) {
        viewController.item.category = [NSString stringWithFormat:@"else"];
    } else if (anIndex == 4) {
        viewController.item.category = [NSString stringWithFormat:@"income"];
    }
    [self.navigationController pushViewController:viewController animated:NO];
    
//    CATransition* transition = [CATransition animation];
//    transition.type = kCATransitionFromBottom;
////    transition.subtype = kCATransitionFromBottom;
//    [self.navigationController.view.layer addAnimation:transition forKey:nil];
}

- (void)circleMenuClosed
{
    if (self.circleMenuView) {
        [self.circleMenuView closeMenu];
        self.circleMenuView = nil;
    }
    [self.addItemButton setTitle:@"" forState:UIControlStateNormal];
}

- (void)circleMenuOpened
{
    [self.addItemButton setTitle:@"" forState:UIControlStateNormal];
}

- (void)setSelectedIndex:(NSInteger)index {
    if (index < 0 || index > [_viewControllers count]) {
        return;
    }
    _selectedIndex = index;
    for (NSUInteger i = 0; i < _tabButtons.count; i++) {
        [[_tabButtons objectAtIndex:i] setSelected:(i == index)];
    }
    UIViewController* controller = [_viewControllers objectAtIndex:index];
    if (_currentController == controller) {
        return;
    }
    [_currentController.view removeFromSuperview];
    [self.viewContainer addSubview:controller.view fit:YES];
    _currentController = controller;
}

@end
