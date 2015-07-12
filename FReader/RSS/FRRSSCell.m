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

@interface FRRSSCell ()

@property (nonatomic, strong) UIButton *addButton;

@end

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
    self.infoModel = nil;
    [self.addButton removeFromSuperview];
    self.addButton = nil;
    self.textLabel.text = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.infoModel) {
        self.infoModel = [[FRRSSManager sharedInstance] feedInfoWithURL:self.feedURL];
    }
    
    if (self.infoModel) {
        self.textLabel.text = self.infoModel.title;
    }
    else {
        self.textLabel.text = self.feedURL;
        [[FRRSSManager sharedInstance] requestRSSList:self.feedURL];
    }
    
    if (self.showAddBtn) {
        if (!self.addButton) {
            self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
            if ([[FRRSSManager sharedInstance] hasSubscription:self.infoModel.url]) {
                [self.addButton setTitle:@"已订阅" forState:UIControlStateNormal];
            }
            else {
                [self.addButton setTitle:@"+" forState:UIControlStateNormal];
            }
            self.addButton.frame = CGRectMake(self.bounds.size.width - 70, (self.bounds.size.height - 30) / 2, 60, 30);
            self.addButton.backgroundColor = [UIColor redColor];
            [self.addButton addTarget:self action:@selector(onAddAct:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:self.addButton];
        }
    }
}

- (void)onAddAct:(id)sender
{
    FRRSSManager *manager = [FRRSSManager sharedInstance];
    if ([manager hasSubscription:self.infoModel.url]) {
        [manager removeSubscription:self.infoModel.url];
        [self.addButton setTitle:@"+" forState:UIControlStateNormal];
    }
    else {
        [manager addSubscription:self.infoModel.url];
        [self.addButton setTitle:@"已订阅" forState:UIControlStateNormal];
    }
}

- (void)onFeedRequestFinish:(NSNotification *)notification
{
    NSDictionary *dic = notification.object;
    FRRSSModel *infoModel = dic[@"FeedInfo"];
    
    if ([infoModel.url isEqualToString:self.feedURL]) {
        self.textLabel.text = infoModel.title;
        self.infoModel = infoModel;
    }
}

@end
