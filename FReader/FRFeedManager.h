//
//  FRFeedManager.h
//  FReader
//
//  Created by honey.vi on 15/3/15.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRFeedInfoModel.h"

#define kFeedRequestFinishNotification @"kFeedRequestFinishNotification"

@interface FRFeedManager : NSObject

+ (FRFeedManager *)sharedInstance;

- (NSArray *)feedURLList;
- (void)updateFeedInfos;

- (FRFeedInfoModel *)feedInfoWithURL:(NSString *)feedURL;
- (void)requestFeedInfoList:(NSString *)url;
- (void)requestFeedList:(NSString *)url;
- (void)cancelRequestWithURL:(NSString *)url;

@end
