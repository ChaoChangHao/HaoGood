//
//  StatisticsChartViewController.m
//  Final_Work
//
//  Created by Chang Hao Chao on 2017/6/14.
//  Copyright © 2017年 Chang Hao Chao. All rights reserved.
//

#import "StatisticsChartViewController.h"

#import "Item.h"


#import <MagicalRecord/MagicalRecord.h>

@interface StatisticsChartViewController () <ChartViewDelegate>

@end

@implementation StatisticsChartViewController {
    NSArray *parties;
    
    NSArray *_items;
    NSMutableArray *_sumPrice;
    NSMutableArray *_categoryName;
    NSMutableArray* _food;
    NSMutableArray* _traffic;
    NSMutableArray* _entertainment;
    NSMutableArray* _else;

    
    NSDate *today;
    NSDateFormatter *formatter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _food = [NSMutableArray new];
    _traffic = [NSMutableArray new];
    _entertainment = [NSMutableArray new];
    _else = [NSMutableArray new];
    _items = @[_food, _traffic, _entertainment, _else];
    
    
    _chartView.legend.enabled = NO;
    _chartView.delegate = self;
    
    
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY/MM/dd"];
    today = [formatter dateFromString:[formatter stringFromDate:[NSDate date]]];
    
    NSArray *items = [Item MR_findByAttribute:@"date" withValue:today];
    for (Item *item in items) {
        NSLog(@"%@",item.date);
    }
    
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.rootViewController setTitle:@"Statistics"];
    [self updateItems];
    [self setupPieChartView:_chartView];
}

#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}

#pragma mark - privated method
- (void)updateItems {
    [_food removeAllObjects];
    [_traffic removeAllObjects];
    [_entertainment removeAllObjects];
    [_else removeAllObjects];
    
    NSInteger foodPrice = 0;
    NSInteger trafficPrice = 0;
    NSInteger entertainmentPrice = 0;
    NSInteger elsePrice = 0;
    
    NSArray *items = [Item MR_findByAttribute:@"date" withValue:today];
    for (Item* item in items) {
                if (!item.name || !item.price) continue;
        if ([item.category isEqualToString:@"food"]) {
            [_food addObject:item];
            foodPrice += [item.price integerValue];
        } else if ([item.category isEqualToString:@"traffic"]) {
            [_traffic addObject:item];
            trafficPrice += [item.price integerValue];
        } else if ([item.category isEqualToString:@"entertainment"]) {
            [_entertainment addObject:item];
            entertainmentPrice += [item.price integerValue];
        } else if ([item.category isEqualToString:@"else"]) {
            [_else addObject:item];
            elsePrice += [item.price integerValue];
        }
    }
    _sumPrice = [NSMutableArray new];
    _categoryName = [NSMutableArray new];
    if (_food.count) {
        [_sumPrice addObject:[NSNumber numberWithInteger:foodPrice]];
        [_categoryName addObject:[NSString stringWithFormat:@"food"]];
    }
    if (_traffic.count) {
        [_sumPrice addObject:[NSNumber numberWithInteger:trafficPrice]];
        [_categoryName addObject:[NSString stringWithFormat:@"traffic"]];
    }
    if (_entertainment.count) {
        [_sumPrice addObject:[NSNumber numberWithInteger:entertainmentPrice]];
        [_categoryName addObject:[NSString stringWithFormat:@"entertainment"]];
    }
    if (_else.count) {
        [_sumPrice addObject:[NSNumber numberWithInteger:elsePrice]];
        [_categoryName addObject:[NSString stringWithFormat:@"else"]];
    }

    NSLog(@"%@", _sumPrice);
    [self setDataCount:[_sumPrice count] range:100];
    
    
    //    [self.costsListView reloadData];
}

- (void)setDataCount:(NSUInteger)count range:(double)range
{
    
    NSMutableArray *entries = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        double value = [_sumPrice[i] doubleValue];
        NSString *name = _categoryName[i];
        [entries addObject:[[PieChartDataEntry alloc] initWithValue:value label:name]];
    }
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:entries label:@"Election Results"];
    dataSet.sliceSpace = 2.0;
    
    // add a lot of colors
    
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    [colors addObjectsFromArray:ChartColorTemplates.vordiplom];
    [colors addObjectsFromArray:ChartColorTemplates.joyful];
    [colors addObjectsFromArray:ChartColorTemplates.colorful];
    [colors addObjectsFromArray:ChartColorTemplates.liberty];
    [colors addObjectsFromArray:ChartColorTemplates.pastel];
    [colors addObject:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
    
    dataSet.colors = colors;
    
    dataSet.valueLinePart1OffsetPercentage = 0.8;
    dataSet.valueLinePart1Length = 0.2;
    dataSet.valueLinePart2Length = 0.4;
    //dataSet.xValuePosition = PieChartValuePositionOutsideSlice;
    dataSet.yValuePosition = PieChartValuePositionOutsideSlice;
    
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @" %";
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];
    [data setValueTextColor:UIColor.blackColor];
    
    _chartView.data = data;
    [_chartView highlightValues:nil];
}

- (void)setupPieChartView:(PieChartView *)chartView
{
    chartView.usePercentValuesEnabled = YES;
    chartView.drawSlicesUnderHoleEnabled = NO;
    chartView.holeRadiusPercent = 0.4;
    chartView.transparentCircleRadiusPercent = 0.4;
    chartView.chartDescription.enabled = NO;
    [chartView setExtraOffsetsWithLeft:5.f top:10.f right:5.f bottom:5.f];
    
    chartView.drawCenterTextEnabled = YES;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *centerText = [[NSMutableAttributedString alloc] initWithString:@"圓餅圖\n一日花費"];
    [centerText setAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:13.f],
                                NSParagraphStyleAttributeName: paragraphStyle
                                } range:NSMakeRange(0, centerText.length)];
//    [centerText addAttributes:@{
//                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f],
//                                NSForegroundColorAttributeName: UIColor.grayColor
//                                } range:NSMakeRange(10, centerText.length - 10)];
    [centerText addAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:11.f],
                                NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]
                                } range:NSMakeRange(centerText.length - 4, 4)];
    chartView.centerAttributedText = centerText;
    
    chartView.drawHoleEnabled = YES;
    chartView.rotationAngle = 0.0;
    chartView.rotationEnabled = YES;
    chartView.highlightPerTapEnabled = YES;
    
    ChartLegend *l = chartView.legend;
    l.horizontalAlignment = ChartLegendHorizontalAlignmentRight;
    l.verticalAlignment = ChartLegendVerticalAlignmentTop;
    l.orientation = ChartLegendOrientationVertical;
    l.drawInside = NO;
    l.xEntrySpace = 7.0;
    l.yEntrySpace = 0.0;
    l.yOffset = 0.0;
}


@end
