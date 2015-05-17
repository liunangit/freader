//
//  FRFeedController.m
//  FReader
//
//  Created by itedliu@qq.com on 15/3/14.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "FRFeedController.h"
#import "FRRSSModel.h"
#import "FRRSSManager.h"
#import "FRFeedCell.h"
#import "FRFeedModel.h"
#import "MMDrawerBarButtonItem.h"
#import "AppDelegate.h"
#import "MMDrawerController.h"
#import "FRFeedDetailController.h"

@interface FRFeedController ()

@property (nonatomic, strong) FRRSSModel *feedInfoModel;

@end

@implementation FRFeedController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.useInDrawer) {
        [self setupLeftMenuButton];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveFeeds:) name:kFeedRequestFinishNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.useInDrawer) {
        [AppDelegate appDelegate].drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    }
    if (self.feedURL.length == 0) {
        NSString *firstURL = [[FRRSSManager sharedInstance] feedURLList].firstObject ;
        self.feedURL = firstURL;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.useInDrawer) {
        [AppDelegate appDelegate].drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
    }
}

- (void)setupLeftMenuButton
{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

- (void)leftDrawerButtonPress:(id)sender
{
    [[AppDelegate appDelegate].drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)setFeedURL:(NSString *)feedURL
{
    if ([_feedURL isEqualToString:feedURL]) {
        return;
    }
    
    _feedURL = feedURL;
    
    FRRSSModel *infoModel = [[FRRSSManager sharedInstance] feedInfoWithURL:feedURL];
    if (infoModel) {
        self.feedInfoModel = infoModel;
        self.title = infoModel.title;
    }
    
    if (infoModel.feedModelList.count == 0) {
        [self triggerPullToRefresh];
    }
}

- (void)onRefresh
{
    if (self.feedURL.length > 0) {
        [[FRRSSManager sharedInstance] requestFeedList:self.feedURL];
    }
    else {
        [self stopRefresh];
    }
}

- (void)setFeedInfoModel:(FRRSSModel *)feedInfoModel
{
    _feedInfoModel = feedInfoModel;
    [self.tableView reloadData];
}

- (void)onReceiveFeeds:(NSNotification *)notification
{
    NSDictionary *dic = notification.object;
    FRRSSModel *infoModel = dic[@"FeedInfo"];
    BOOL onlyFeedInfo = [dic[@"OnlyInfo"] boolValue];
    
    if ([self.feedURL isEqualToString:infoModel.url]) {
        self.title = infoModel.title;
        if (onlyFeedInfo) {
            return;
        }
        self.feedInfoModel = infoModel;
        [self.tableView reloadData];
        [self stopRefresh];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.feedInfoModel.feedModelList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *feedCellIdentifier = @"feedCellIdentifier";
    FRFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:feedCellIdentifier];
    if (!cell) {
        cell = [[FRFeedCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:feedCellIdentifier];
    }
    
    FRFeedModel *feedModel = self.feedInfoModel.feedModelList[indexPath.row];
    cell.feedModel = feedModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRFeedModel *feedModel = self.feedInfoModel.feedModelList[indexPath.row];
    FRFeedDetailController *detailController = [[FRFeedDetailController alloc] init];
    detailController.feedModel = feedModel;
    [self.navigationController pushViewController:detailController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
