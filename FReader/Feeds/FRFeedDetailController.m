//
//  FRFeedDetailController.m
//  FReader
//
//  Created by 刘楠 on 15/3/18.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "FRFeedDetailController.h"
#import "FRFeedModel.h"
#import "FRWebViewController.h"
#import "FRPublicDefine.h"
#import "FRLayoutManager.h"

@interface FRFeedDetailController ()

@end

@implementation FRFeedDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(onOpenSourceURL:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.title = self.feedModel.title;
    
    fr_weakify(self);
    [[FRLayoutManager sharedInstance] layoutAsync:self.feedModel.content
                                       completion:^(NSArray *nodeList) {
                                           if (!self) {
                                               return;
                                           }
                                          
                                           NSAssert([NSThread isMainThread], @" must in main thread");
                                           fr_strongify(self);
                                           self.contentNodeList = nodeList;
                                       }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)onOpenSourceURL:(id)sender
{
    FRWebViewController *webViewController = [[FRWebViewController alloc] init];
    webViewController.url = self.feedModel.contentURL;
    [webViewController startLoad];
    [self.navigationController pushViewController:webViewController animated:YES];
}

@end
