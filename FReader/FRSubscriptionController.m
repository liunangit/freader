//
//  FRSubscriptionController.m
//  FReader
//
//  Created by itedliu@qq.com on 15/3/14.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "FRSubscriptionController.h"
#import "FRPublicDefine.h"
#import "FRFeedManager.h"
#import "FRSubscriptionCell.h"
#import "AppDelegate.h"
#import "MMDrawerController.h"
#import "FRFeedController.h"

@interface FRSubscriptionController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray *feedURLList;

@end

@implementation FRSubscriptionController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    self.feedURLList = [[FRFeedManager sharedInstance] feedURLList];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.feedURLList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kSubscriptionCellIdentifer = @"kSubscriptionCellIdentifer";
    FRSubscriptionCell *cell = (FRSubscriptionCell *)[tableView dequeueReusableCellWithIdentifier:kSubscriptionCellIdentifer];
    if (!cell) {
        cell = [[FRSubscriptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSubscriptionCellIdentifer];
    }
    
    cell.feedURL = self.feedURLList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *url = self.feedURLList[indexPath.row];
    FRFeedController *feedController = [AppDelegate appDelegate].feedController;
    feedController.feedURL = url;
    [[AppDelegate appDelegate].drawerController closeDrawerAnimated:YES completion:nil];
}

@end
