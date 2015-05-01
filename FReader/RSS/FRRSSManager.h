//
//  FRRSSManager.h
//  FReader
//
//  Created by itedliu@qq.com on 15/3/15.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRRSSModel.h"

#define kFeedRequestFinishNotification @"kFeedRequestFinishNotification"

@interface FRRSSManager : NSObject

+ (FRRSSManager *)sharedInstance;

- (NSArray *)feedURLList;
- (void)updateFeedInfos;

- (FRRSSModel *)feedInfoWithURL:(NSString *)feedURL;
- (void)requestRSSList:(NSString *)url;
- (void)requestFeedList:(NSString *)url;
- (void)cancelRequestWithURL:(NSString *)url;

@end
