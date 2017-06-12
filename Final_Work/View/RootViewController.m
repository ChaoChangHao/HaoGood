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
    CostsListViewController* _test1ListViewController;
    IncomesListViewController* _test2ListViewController;
    
    
    NSArray* _titles;
    NSArray* _tabButtons;
    NSArray* _viewControllers;
    
    NSInteger _selectedIndex;
    UIViewController* _currentController;
    
    UIDatePicker *datePicker;
    NSDateFormatter *formatter;
    
    NSUInteger budgetValue;
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
    _test1ListViewController = [[CostsListViewController alloc] initWithNibName:@"CostsListView" bundle:nil];
    _test2ListViewController = [[IncomesListViewController alloc] initWithNibName:@"IncomesListView" bundle:nil];
    
    
    _viewControllers = @[ _costsListViewController, _incomesListViewController, _test1ListViewController, _test2ListViewController];
    
    _costsListViewController.rootViewController = self;
    _costsListViewController.itemManager = self.itemManager;
    
    _incomesListViewController.rootViewController = self;
    
    _test1ListViewController.rootViewController = self;
    
    _test2ListViewController.rootViewController = self;
    
    
    [self setSelectedIndex:0];
    [self setTitle:@"Cost"];
//    [[self navigationController] setNavigationBarHidden:YES animated:NO];

    //======================================================================//
    // Circle button
    self.imageArray = @[[UIImage imageNamed:@"entertainment"], [UIImage imageNamed:@"transport"], [UIImage imageNamed:@"food"], [UIImage imageNamed:@"other"], [UIImage imageNamed:@"incomeItem"]];
    self.subButtonCount = 5;
    self.angle = 120.0;
    self.delay = 0.1;
    self.shadow = 1;
    self.radius = 120;
    self.direction = CircleMenuDirectionLeftUp;
//    self.colorArray = @[[UIColor colorWithRed:0.827 green:0.639 blue:1 alpha:1],
//                        [UIColor colorWithRed:0.6 green:0.8 blue:1 alpha:1],
//                        [UIColor colorWithRed:1 green:0.761 blue:0.878 alpha:1],
//                        [UIColor colorWithRed:1 green:1 blue:0.439 alpha:1],
//                        [UIColor colorWithRed:0.584 green:1 blue:0.816 alpha:1],];

    //=================================================================//
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY/MM/dd"];
    datePicker = [[UIDatePicker alloc] init];
    
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
    datePicker.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.hidden = NO;
    
    datePicker.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    [datePicker addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventValueChanged];
    //space
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    //date
    UIToolbar *dateToolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 44)];
    [dateToolBar setTintColor:[UIColor whiteColor]];
    dateToolBar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *dateDoneBtn=[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonPressed)];
    
    
    [dateToolBar setItems:[NSArray arrayWithObjects:space,dateDoneBtn, nil]];
    [_dateSelectTextField setInputView:datePicker];
    [_dateSelectTextField setInputAccessoryView:dateToolBar];
    [[_dateSelectTextField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
    [self chooseDate:datePicker];
    //======================================================================//
    UISwipeGestureRecognizer *swipeR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognized:)];
    UISwipeGestureRecognizer *swipeL = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognized:)];
    swipeL.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeR.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeR];
    [self.view addGestureRecognizer:swipeL];
    //======================================================================//
    budgetValue = 10000;
    [self calculateBudget];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemsSynchronized) name:ItemsSynchronizedNotificationName object:nil];

}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    
    if (datePicker.superview) {
        [datePicker removeFromSuperview];
    } else {
        [self chooseDate:datePicker];
    }
    return YES;
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [_dateSelectTextField resignFirstResponder];
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
        [tOptions setValue:[NSDecimalNumber decimalNumberWithString:@"2.5"] forKey:CIRCLE_MENU_BUTTON_BORDER_WIDTH];
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
- (void)calculateBudget
{
//    [Item MR_trurncateAll];
    NSDate *todayDate = [NSDate date];
    
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 指定日历的算法 NSCalendarIdentifierGregorian,NSGregorianCalendar
    // NSDateComponent 可以获得日期的详细信息，即日期的组成
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:todayDate];
    
    NSString *dateStr;
    NSDate *date;
    NSArray *items;
    
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay
                                   inUnit: NSCalendarUnitMonth
                                  forDate:todayDate];
    NSUInteger sum = 0;
    
    for (int i = 1; i <= range.length; i++) {
        dateStr = [NSString stringWithFormat:@"%ld/%ld/%i",(long)comps.year, (long)comps.month, i];
        date = [formatter dateFromString:dateStr];
        
        items = [Item MR_findByAttribute:@"date" withValue:date];
        for (Item* item in items) {
            if ([item.category isEqualToString:@"income"]) break;
            sum += [item.price integerValue];
        }
    }
    self.budgetBarLabel.text = [NSString stringWithFormat:@"預算： %lu / %lu", (unsigned long)sum, (unsigned long)budgetValue];
    if (sum > budgetValue) {
        [self.budgetBarLabel setTextColor:[UIColor redColor]];
    } else if (sum > budgetValue/2) {
        [self.budgetBarLabel setTextColor:[UIColor orangeColor]];
    } else {
        [self.budgetBarLabel setTextColor:[UIColor greenColor]];
    }
}

-(void)swipeRecognized:(UISwipeGestureRecognizer*)swipeGesture
{
    self.currentSelectDate = [formatter dateFromString:_dateSelectTextField.text];
    if (swipeGesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        self.currentSelectDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:self.currentSelectDate];
    } else if (swipeGesture.direction == UISwipeGestureRecognizerDirectionRight) {
        self.currentSelectDate = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:self.currentSelectDate];
    }
    _dateSelectTextField.text = [formatter stringFromDate:self.currentSelectDate];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ItemsSynchronizedNotificationName object:nil];
    
}

- (void)circleMenuActivatedButtonWithIndex:(int)anIndex
{
    
    AddItemViewController *viewController = [[AddItemViewController alloc] initWithNibName:@"AddItemView" bundle:nil];
    
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromBottom;
    
    
    viewController.item = [Item MR_createEntity];
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
- (void)chooseDate:(UIDatePicker *)datePick
{
    NSDate *selectedDate = datePick.date;
    _dateSelectTextField.text = [formatter stringFromDate:selectedDate];
    self.currentSelectDate = [formatter dateFromString:_dateSelectTextField.text];
    [[NSNotificationCenter defaultCenter] postNotificationName:ItemsSynchronizedNotificationName object:nil];
}
- (void)doneButtonPressed
{
    [_dateSelectTextField resignFirstResponder];
}
- (void)itemsSynchronized {
    [self calculateBudget];
//    [self chooseDate:datePicker];
}
@end
