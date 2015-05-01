//
//  FRWebViewController.m
//  FReader
//
//  Created by 刘楠 on 15/4/28.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "FRWebViewController.h"

@interface FRWebViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation FRWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupWebView];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)startLoad
{
    if (self.url) {
        [self setupWebView];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }
}

- (void)setupWebView
{
    if (!self.webView) {
        self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:self.webView];
    }
}

- (void)stopLoad
{
    [self.webView stopLoading];
}

- (void)dealloc
{
    [self stopLoad];
}

@end
