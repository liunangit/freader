//
//  FRFeedManager.m
//  FReader
//
//  Created by honey.vi on 15/3/15.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "FRFeedManager.h"
#import "FRFeedParser.h"

@interface FRFeedManager () <FRFeedParserDelegate>

@property (nonatomic, strong) NSMutableDictionary *feedRequestDic;
@property (nonatomic, strong) NSMutableDictionary *feedInfoRequestDic;
@property (nonatomic, strong) NSMutableDictionary *feedInfoDic;

@end

@implementation FRFeedManager

+ (FRFeedManager *)sharedInstance
{
    static FRFeedManager *feedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(void){
        feedManager = [[FRFeedManager alloc] init];
    });
    return feedManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        _feedRequestDic = [NSMutableDictionary dictionary];
        _feedInfoDic = [NSMutableDictionary dictionary];
        _feedInfoRequestDic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSArray *)feedURLList
{
    return [NSMutableArray arrayWithObjects:@"http://macshuo.com/?feed=rss2", nil];
}

- (void)updateFeedInfos
{
    for (NSString *url in self.feedURLList) {
        [self requestFeedInfoList:url];
    }
}

- (FRFeedInfoModel *)feedInfoWithURL:(NSString *)feedURL
{
    if (feedURL.length > 0) {
        return self.feedInfoDic[feedURL];
    }
    return nil;
}

- (void)requestFeedInfoList:(NSString *)url
{
    FRFeedParser *parser = self.feedInfoRequestDic[url];
    if (parser) {
        return;
    }
    parser = [[FRFeedParser alloc] initWithURL:url];
    parser.onlyFeedInfo = YES;
    parser.delegate = self;
    self.feedInfoRequestDic[url] = parser;
    [parser startParser];
}

- (void)requestFeedList:(NSString *)url
{
    FRFeedParser *parser = [[FRFeedParser alloc] initWithURL:url];
    parser.delegate = self;
    self.feedRequestDic[url] = parser;
    [parser startParser];
}

- (void)cancelRequestWithURL:(NSString *)url
{
    FRFeedParser *parser = self.feedRequestDic[url];
    if (parser) {
        [parser stopPaser];
        [self.feedRequestDic removeObjectForKey:url];
    }
}

- (void)feedParserFinish:(FRFeedInfoModel *)feedInfo
{
    if (feedInfo) {
        self.feedInfoDic[feedInfo.url] = feedInfo;
    }
    
    [self.feedRequestDic removeObjectForKey:feedInfo.url];
    [self.feedInfoRequestDic removeObjectForKey:feedInfo.url];
    
    NSDictionary *dic = @{@"URL":feedInfo.url, @"FeedInfo":feedInfo};
    [[NSNotificationCenter defaultCenter] postNotificationName:kFeedRequestFinishNotification object:dic];
}

- (void)feedParserFailed:(NSString *)URL error:(NSError *)error
{
    [self.feedRequestDic removeObjectForKey:URL];
    [self.feedInfoRequestDic removeObjectForKey:URL];
    NSDictionary *dic = @{@"URL": URL, @"error": error};
    [[NSNotificationCenter defaultCenter] postNotificationName:kFeedRequestFinishNotification object:dic];
}

@end
