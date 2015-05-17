//
//  FRFeedController.h
//  FReader
//
//  Created by itedliu@qq.com on 15/3/14.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRPullRefreshBaseController.h"

@class FRRSSModel;

@interface FRFeedController : FRPullRefreshBaseController

@property (nonatomic, copy) NSString *feedURL;
@property (nonatomic) BOOL useInDrawer; //在抽屉中使用的时候要设置导航栏按钮

@end
