//
//  FRFeedDetailController.h
//  FReader
//
//  Created by 刘楠 on 15/3/18.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRBaseReadingController.h"

@class FRFeedModel;

@interface FRFeedDetailController : FRBaseReadingController

@property (nonatomic, strong) FRFeedModel *feedModel;

@end
