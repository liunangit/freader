//
//  FRFeedParser.m
//  FReader
//
//  Created by itedliu@qq.com on 15/3/15.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "FRFeedParser.h"
#import "FRRSSModel.h"
#import "MWFeedParser.h"
#import "FRFeedModel.h"

@interface FRFeedParser () <MWFeedParserDelegate>

@property (nonatomic, strong) MWFeedParser *feedParser;
@property (nonatomic, strong) NSMutableArray *feedArray;
@property (nonatomic, strong) FRRSSModel *feedModel;

@end

@implementation FRFeedParser

- (id)initWithURL:(NSString *)urlString
{
    self = [super init];
    if (self) {
        _url = [urlString copy];
    }
    return self;
}

- (void)startParser
{
   	NSURL *feedURL = [NSURL URLWithString:self.url];
    self.feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
    self.feedParser.delegate = self;
    
    if (self.onlyFeedInfo) {
         self.feedParser.feedParseType = ParseTypeInfoOnly;
    }
    else {
        self.feedParser.feedParseType = ParseTypeFull;
        self.feedArray = [NSMutableArray array];
    }
   
    self.feedParser.connectionType = ConnectionTypeAsynchronously;
    [self.feedParser parse];
}

- (void)stopPaser
{
    [self.feedParser stopParsing];
    self.feedParser = nil;
}

- (void)feedParserDidStart:(MWFeedParser *)parser {
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
    FRRSSModel *feedInfoModel = [[FRRSSModel alloc] init];
    feedInfoModel.url = self.url;
    feedInfoModel.title = info.title;
    self.feedModel = feedInfoModel;
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
    FRFeedModel *feedModel = [[FRFeedModel alloc] init];
    feedModel.title = item.title;
    feedModel.summary = item.summary;
    feedModel.date = item.date;
    feedModel.content = item.content;
    feedModel.contentURL = item.link;
    [self.feedArray addObject:feedModel];
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
    self.feedModel.feedModelList = self.feedArray;
    if ([self.delegate respondsToSelector:@selector(feedParserFinish:parser:)]) {
        [self.delegate feedParserFinish:self.feedModel parser:self];
    }
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
    NSLog(@"Finished Parsing With Error: %@", error);
    if ([self.delegate respondsToSelector:@selector(feedParserFailed:url:error:)]) {
        [self.delegate feedParserFailed:self url:self.url error:error];
    }
}


@end
