//
//  FRRSSCell.m
//  FReader
//
//  Created by itedliu@qq.com on 15/3/15.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "FRRSSCell.h"
#import "FRRSSManager.h"
#import "FRRSSModel.h"

@implementation FRRSSCell

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
    FRRSSModel *infoModel = [[FRRSSManager sharedInstance] feedInfoWithURL:self.feedURL];
    if (infoModel) {
        self.textLabel.text = infoModel.title;
    }
    else {
        self.textLabel.text = self.feedURL;
        [[FRRSSManager sharedInstance] requestRSSList:self.feedURL];
    }
}

- (void)onFeedRequestFinish:(NSNotification *)notification
{
    NSDictionary *dic = notification.object;
    FRRSSModel *infoModel = dic[@"FeedInfo"];
    
    if ([infoModel.url isEqualToString:self.feedURL]) {
        self.textLabel.text = infoModel.title;
    }
}

@end
