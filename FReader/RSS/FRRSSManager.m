//
//  FRRSSManager.m
//  FReader
//
//  Created by itedliu@qq.com on 15/3/15.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "FRRSSManager.h"
#import "FRFeedParser.h"
#import "TMCache.h"

@interface FRRSSManager () <FRFeedParserDelegate>

@property (nonatomic, strong) NSMutableDictionary *feedRequestDic;
@property (nonatomic, strong) NSMutableDictionary *feedInfoRequestDic;
@property (nonatomic, strong) NSMutableArray *URLList;

@end

@implementation FRRSSManager

+ (FRRSSManager *)sharedInstance
{
    static FRRSSManager *feedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(void){
        feedManager = [[FRRSSManager alloc] init];
    });
    return feedManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        _feedRequestDic = [NSMutableDictionary dictionary];
        _feedInfoRequestDic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSArray *)feedURLList
{
    if (self.URLList) {
        return self.URLList;
    }
    
    NSString *feedList = [[NSBundle mainBundle] pathForResource:@"rss.txt" ofType:nil];
    if (feedList) {
        NSString *content = [NSString stringWithContentsOfFile:feedList encoding:NSUTF8StringEncoding error:nil];
        NSArray *array = [content componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.URLList = [NSMutableArray arrayWithArray:array];
    }
    return self.URLList;
}

- (void)updateFeedInfos
{
    for (NSString *url in self.feedURLList) {
        [self requestRSSList:url];
    }
}

- (FRRSSModel *)feedInfoWithURL:(NSString *)feedURL
{
    if (feedURL.length > 0) {
        return [[TMCache sharedCache] objectForKey:feedURL];
    }
    return nil;
}

- (void)requestRSSList:(NSString *)url
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
    FRFeedParser *parser = self.feedRequestDic[url];
    if (parser) {
        return;
    }
    
    parser = [[FRFeedParser alloc] initWithURL:url];
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

- (FRRSSModel *)mergeFeedInfo:(FRRSSModel *)oneModel with:(FRRSSModel *)anotherModel
{
    NSString *url = oneModel.url;
    if (url.length == 0) {
        url = anotherModel.url;
    }
    
    NSString *title = oneModel.title;
    if (title.length == 0) {
        title = anotherModel.title;
    }
    
    NSArray *feedList = oneModel.feedModelList;
    if (feedList.count == 0) {
        feedList = anotherModel.feedModelList;
    }
    
    FRRSSModel *newModel = [[FRRSSModel alloc] init];
    newModel.url = url;
    newModel.title = title;
    newModel.feedModelList = feedList;
    return newModel;
}

- (void)feedParserFinish:(FRRSSModel *)feedInfo parser:(FRFeedParser *)feedParser
{
    if (feedInfo) {
        TMCache *cache = [TMCache sharedCache];
        FRRSSModel *feedModel = [cache objectForKey:feedInfo.url];
        FRRSSModel *latestModel = [self mergeFeedInfo:feedModel with:feedInfo];
        [cache setObject:latestModel forKey:latestModel.url];
        feedInfo = latestModel;
    }
    
    if (feedParser.onlyFeedInfo) {
        [self.feedInfoRequestDic removeObjectForKey:feedInfo.url];
    }
    else {
        [self.feedRequestDic removeObjectForKey:feedInfo.url];
    }
    
    NSDictionary *dic = @{@"URL":feedInfo.url, @"FeedInfo":feedInfo, @"OnlyInfo": @(feedParser.onlyFeedInfo)};
    [[NSNotificationCenter defaultCenter] postNotificationName:kFeedRequestFinishNotification object:dic];
}

- (void)feedParserFailed:(FRFeedParser *)feedParser url:(NSString *)URL error:(NSError *)error
{
    if (feedParser.onlyFeedInfo) {
        [self.feedInfoRequestDic removeObjectForKey:URL];
    }
    else {
        [self.feedRequestDic removeObjectForKey:URL];
    }
    
    NSDictionary *dic = @{@"URL": URL, @"error": error, @"OnlyInfo": @(feedParser.onlyFeedInfo)};
    [[NSNotificationCenter defaultCenter] postNotificationName:kFeedRequestFinishNotification object:dic];
}

@end
