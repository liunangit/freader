//
//  FRFeedDetailController.m
//  FReader
//
//  Created by 刘楠 on 15/3/18.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "FRFeedDetailController.h"
#import "FRFeedModel.h"

@interface FRFeedDetailController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation FRFeedDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSURL *url = [NSURL URLWithString:self.feedModel.contentURL];
    [self.webView loadHTMLString:self.feedModel.content baseURL:url];
    self.title = self.feedModel.title;
}

//- (void)setFeedModel:(FRFeedModel *)feedModel
//{
//    _feedModel = feedModel;
//}

@end
