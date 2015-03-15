//
//  FRFeedParser.h
//  FReader
//
//  Created by honey.vi on 15/3/15.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRFeedManager.h"

@class FRFeedInfoModel;
@class FRFeedParser;

@protocol FRFeedParserDelegate <NSObject>

@optional
- (void)feedParserFinish:(FRFeedInfoModel *)feedInfo;
- (void)feedParserFailed:(NSString *)URL error:(NSError *)error;

@end

@interface FRFeedParser : NSObject

@property (nonatomic, weak) id <FRFeedParserDelegate> delegate;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) BOOL onlyFeedInfo;

- (id)initWithURL:(NSString *)urlString;
- (void)startParser;
- (void)stopPaser;

@end
