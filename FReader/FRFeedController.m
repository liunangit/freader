//
//  FRFeedController.m
//  FReader
//
//  Created by honey.vi on 15/3/14.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "FRFeedController.h"
#import "FRFeedInfoModel.h"
#import "FRFeedManager.h"
#import "FRFeedCell.h"
#import "FRFeedModel.h"
#import "MMDrawerBarButtonItem.h"
#import "AppDelegate.h"
#import "MMDrawerController.h"

@interface FRFeedController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) FRFeedInfoModel *feedInfoModel;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation FRFeedController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self setupLeftMenuButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveFeeds:) name:kFeedRequestFinishNotification object:nil];
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
    
    FRFeedInfoModel *infoModel = [[FRFeedManager sharedInstance] feedInfoWithURL:feedURL];
    if (infoModel) {
        self.feedInfoModel = infoModel;
    }
    [[FRFeedManager sharedInstance] requestFeedList:feedURL];
}

- (void)setFeedInfoModel:(FRFeedInfoModel *)feedInfoModel
{
    _feedInfoModel = feedInfoModel;
    [self.tableView reloadData];
}

- (void)onReceiveFeeds:(NSNotification *)notification
{
    NSDictionary *dic = notification.object;
    FRFeedInfoModel *infoModel = dic[@"FeedInfo"];
    if ([self.feedInfoModel.url isEqualToString:infoModel.url]) {
        self.feedInfoModel = infoModel;
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
        cell = [[FRFeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:feedCellIdentifier];
    }
    
    FRFeedModel *feedModel = self.feedInfoModel.feedModelList[indexPath.row];
    cell.feedModel = feedModel;
    return cell;
}

@end
