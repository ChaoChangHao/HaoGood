//
//  AppDelegate.h
//  Final_Work
//
//  Created by Chang Hao Chao on 2017/5/25.
//  Copyright © 2017年 Chang Hao Chao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "ItemManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;




@property (strong, nonatomic) ItemManager* itemManager;

@end

