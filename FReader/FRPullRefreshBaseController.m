//
//  FRPullRefreshBaseController.m
//  FReader
//
//  Created by 刘楠 on 15/3/18.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "FRPullRefreshBaseController.h"
#import "UIScrollView+UzysAnimatedGifPullToRefresh.h"
#import "FRPublicDefine.h"

@interface FRPullRefreshBaseController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation FRPullRefreshBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    __weak typeof(self) weakSelf =self;
    [self.tableView addPullToRefreshActionHandler:^{
        [weakSelf onRefresh];
    } ProgressImagesGifName:@"spinner_dropbox@2x.gif"
                             LoadingImagesGifName:@"run@2x.gif"
                          ProgressScrollThreshold:70
                            LoadingImageFrameRate:30];
//    if(IS_IOS7)
//        [self.tableView addTopInsetInPortrait:64 TopInsetInLandscape:52];
//    else if(IS_IOS8)
//    {
//        CGFloat landscapeTopInset = 32.0;
//        if(IS_IPHONE6PLUS)
//            landscapeTopInset = 44.0;
//        [self.tableView addTopInsetInPortrait:64 TopInsetInLandscape:landscapeTopInset];
//    }
}

- (void)onRefresh
{
}

- (void)triggerPullToRefresh
{
    [self.tableView triggerPullToRefresh];
}

- (void)stopRefresh
{
    [self.tableView stopPullToRefreshAnimation];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
