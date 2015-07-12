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
    
    NSString *content = self.feedModel.content;
    if (content.length == 0) {
        content = self.feedModel.summary;
    }
    
    fr_weakify(self);
    [[FRLayoutManager sharedInstance] layoutAsync:content
                                       completion:^(NSArray *nodeList) {
                                           fr_strongify(self);
                                           if (!self) {
                                               return;
                                           }
                                          
                                           NSAssert([NSThread isMainThread], @" must in main thread");
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
