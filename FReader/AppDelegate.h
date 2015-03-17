//
//  AppDelegate.h
//  FReader
//
//  Created by honey.vi on 15/3/14.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMDrawerController;
@class FRFeedController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) MMDrawerController *drawerController;
@property (nonatomic, strong) FRFeedController *feedController;

+ (AppDelegate *)appDelegate;

@end

