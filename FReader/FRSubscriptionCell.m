//
//  FRSubscriptionCell.m
//  FReader
//
//  Created by honey.vi on 15/3/15.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "FRSubscriptionCell.h"
#import "FRFeedManager.h"
#import "FRFeedInfoModel.h"

@implementation FRSubscriptionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onFeedRequestFinish:) name:kFeedRequestFinishNotification object:nil];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.feedURL = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    FRFeedInfoModel *infoModel = [[FRFeedManager sharedInstance] feedInfoWithURL:self.feedURL];
    if (infoModel) {
        self.textLabel.text = infoModel.title;
    }
    else {
        self.textLabel.text = self.feedURL;
        [[FRFeedManager sharedInstance] requestFeedInfoList:self.feedURL];
    }
}

- (void)onFeedRequestFinish:(NSNotification *)notification
{
    NSDictionary *dic = notification.object;
    FRFeedInfoModel *infoModel = dic[@"FeedInfo"];
    
    if ([infoModel.url isEqualToString:self.feedURL]) {
        self.textLabel.text = infoModel.title;
    }
}

@end
