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

@interface FRFeedDetailController ()

@property (nonatomic, strong) UITextView *textView;

@end

@implementation FRFeedDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(onOpenSourceURL:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.textView.editable = NO;
    self.textView.font = [UIFont systemFontOfSize:17];
    self.textView.textContainerInset = UIEdgeInsetsMake(10, 15, 20, 15);
    NSString *text = [self.feedModel.textList componentsJoinedByString:@"\n"];
    self.textView.text = text;
    [self.view addSubview:self.textView];
    
    self.title = self.feedModel.title;
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
