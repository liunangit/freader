//
//  FRRSSController.m
//  FReader
//
//  Created by itedliu@qq.com on 15/3/14.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "FRRSSController.h"
#import "FRPublicDefine.h"
#import "FRRSSManager.h"
#import "FRRSSCell.h"
#import "AppDelegate.h"
#import "MMDrawerController.h"
#import "FRFeedController.h"
#import "FRSearchViewController.h"

@interface FRRSSController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray *feedURLList;

@end

@implementation FRRSSController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.feedURLList = [[FRRSSManager sharedInstance] feedURLList];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    headerView.backgroundColor = [UIColor redColor];
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(0, 0, 60, 50);
    [addBtn addTarget:self action:@selector(addContentAct:) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setTitle:@"add" forState:UIControlStateNormal];
    [headerView addSubview:addBtn];
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.frame = CGRectMake(190, 0, 60, 50);
    [editBtn setTitle:@"edit" forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:editBtn];
    
    self.tableView.tableHeaderView = headerView;
    self.tableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRefresh:) name:kSetNeedReloadRSSListNotification object:nil];
}

- (void)addContentAct:(id)sender
{
    FRSearchViewController *searchViewController = [[FRSearchViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [[AppDelegate appDelegate].drawerController presentViewController:nav animated:YES completion:nil];
}

- (void)editAction:(id)sender
{
    
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
    FRRSSCell *cell = (FRRSSCell *)[tableView dequeueReusableCellWithIdentifier:kSubscriptionCellIdentifer];
    if (!cell) {
        cell = [[FRRSSCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSubscriptionCellIdentifer];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)onRefresh:(NSNotification *)notification
{
    self.feedURLList = [[FRRSSManager sharedInstance] feedURLList];
    [self.tableView reloadData];
}

@end
