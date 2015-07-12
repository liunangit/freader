//
//  FRSearchViewController.m
//  FReader
//
//  Created by liunan on 15/5/16.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "FRSearchViewController.h"
#import "FRRSSManager.h"
#import "FRRSSCell.h"
#import "FRFeedController.h"
#import "FRUtils.h"
#import "FRSearchTipsView.h"
#import "TMCache.h"

@interface FRSearchViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, FRSearchTipsViewDelegate>

@property (nonatomic, strong) UITextField *searchBar;
@property (nonatomic, copy) NSString *requestURL;
@property (nonatomic, strong) NSArray *rssModelList;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) FRSearchTipsView *tipsView;

@end

@implementation FRSearchViewController

- (void)dealloc
{
    _tipsView.delegate = nil;
    [_tipsView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onExitAct:)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveRSSContent:) name:kFeedRequestFinishNotification object:nil];
    
    [self.searchBar becomeFirstResponder];
    
    [self showTipsViewIfNeeded];
}

- (void)showTipsViewIfNeeded
{
    [self removeTipsView];
    
    NSString *urlString = [self getPasteboardUrl];
    if (urlString.length == 0) {
        return;
    }
    
    static NSString *tipsStringCachedKey = @"tipsStringCachedKey";
    TMCache *cache = [TMCache sharedCache];
    NSString *lastTipText = [cache objectForKey:tipsStringCachedKey];
    if (lastTipText.length > 0) {
        if ([lastTipText isEqualToString:urlString]) {
            return;
        }
    }
    
    self.tipsView = [[FRSearchTipsView alloc] initWithFrame:CGRectMake(10, 45, self.view.bounds.size.width - 20, 30)];
    [self.view addSubview:self.tipsView];
    self.tipsView.delegate = self;
    self.tipsView.text = urlString;
//    [cache setObject:urlString forKey:tipsStringCachedKey];
}

- (void)removeTipsView
{
    self.tipsView.delegate = nil;
    [self.tipsView removeFromSuperview];
    self.tipsView = nil;
}

- (NSString *)getPasteboardUrl
{
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    NSString *content = pastboard.string;
    NSLog(@"%@", content);
    if (content.length == 0) {
        return nil;
    }
    
    return [FRUtils getFirstUrlStringInString:content];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
}

- (void)onExitAct:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (UITextField *)searchBar
{
    if (!_searchBar) {
        UITextField *searchBar = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
        searchBar.backgroundColor = [UIColor grayColor];
        searchBar.returnKeyType = UIReturnKeySearch;
        _searchBar = searchBar;
        _searchBar.delegate = self;
    }
    
    return _searchBar;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchBar.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.searchBar.bounds.size.height)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView = tableView;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rssModelList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kSubscriptionCellIdentifer = @"kSubscriptionCellIdentifer";
    FRRSSCell *cell = (FRRSSCell *)[tableView dequeueReusableCellWithIdentifier:kSubscriptionCellIdentifer];
    if (!cell) {
        cell = [[FRRSSCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSubscriptionCellIdentifer];
        cell.showAddBtn = YES;
    }
    
    cell.infoModel = self.rssModelList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRRSSModel *rssModel = self.rssModelList[indexPath.row];
    FRFeedController *feedController = [[FRFeedController alloc] init];
    feedController.feedURL = rssModel.url;
    [self.navigationController pushViewController:feedController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.searchBar isFirstResponder]) {
        [self.searchBar resignFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *urlStr = textField.text;
    if (urlStr.length > 0) {
        
        self.tableView.tableHeaderView = nil;
        if (![urlStr hasPrefix:@"http"]) {
            urlStr = [NSString stringWithFormat:@"http://%@", urlStr];
        }
        
        self.requestURL = urlStr;
        self.rssModelList = nil;
        [self.tableView reloadData];
        [[FRRSSManager sharedInstance] requestRSSList:urlStr];
        [self.searchBar resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self removeTipsView];
    return YES;
}

- (void)onReceiveRSSContent:(NSNotification *)notification
{
    NSDictionary *dic = notification.object;
    FRRSSModel *infoModel = dic[@"FeedInfo"];
    NSString *url = dic[@"URL"];
    
    if (![url isEqualToString:self.requestURL]) {
        return;
    }
    
    if (infoModel) {
        self.rssModelList = @[infoModel];
        self.tableView.tableHeaderView = nil;
        [self.tableView reloadData];
    }
    else {
        NSString *msg = nil;
        NSError *error = dic[@"error"];
        if (error.code == -2) {
            msg = @"请求超时，请重试";
        }
        else {
            msg = @"未找到文章列表";
        }
        [self showErrorTips:msg];
        self.requestURL = nil;
        self.rssModelList = nil;
    }
}

- (void)showErrorTips:(NSString *)msg
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    label.text = @"未找到文章列表";
    label.textAlignment = NSTextAlignmentCenter;
    self.tableView.tableHeaderView = label;
    [self.tableView reloadData];
}

- (void)searchTipsViewDidTouched:(FRSearchTipsView *)tipsView
{
    self.searchBar.text = tipsView.text;
    [self removeTipsView];
}

- (void)searchTipsViewDidClickCloseBtn:(FRSearchTipsView *)tipsView
{
    [self removeTipsView];
}

@end
