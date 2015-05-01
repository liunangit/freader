//
//  FRPullRefreshBaseController.h
//  FReader
//
//  Created by 刘楠 on 15/3/18.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRBaseViewController.h"

@interface FRPullRefreshBaseController : FRBaseViewController

@property (nonatomic, strong) UITableView *tableView;

- (void)onRefresh;
- (void)triggerPullToRefresh;
- (void)stopRefresh;

@end
