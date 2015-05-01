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
#import "SDWebImageManager.h"
#import "FRPublicDefine.h"

@interface FRFeedDetailController ()

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSTextAttachment *textAttachment;

@end

@implementation FRFeedDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(onOpenSourceURL:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.textView.editable = NO;
    self.textView.textContainerInset = UIEdgeInsetsMake(10, 15, 20, 15);
    NSString *text = [self.feedModel.textList componentsJoinedByString:@"\n"];
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] init];
    
    if (self.feedModel.imageURL) {
        self.textAttachment = [[NSTextAttachment alloc] init];
        
        CGFloat imageWidth = self.feedModel.imageWidth / 2;
        CGFloat imageHeight = self.feedModel.imageHeight / 2;
        
        if (imageWidth > self.textView.bounds.size.width - 30) {
            CGFloat imageWidthFix = self.textView.bounds.size.width - 10;
            imageHeight *= imageWidth / imageWidthFix;
            imageWidth = imageWidthFix;
        }
        self.textAttachment.bounds = CGRectMake((self.textView.bounds.size.width - imageWidth) / 2, 0, imageWidth, imageHeight);
        
        NSURL *imageURL = [NSURL URLWithString:self.feedModel.imageURL];
        fr_weakify(self);
        [[SDWebImageManager sharedManager] downloadImageWithURL:imageURL
                                                        options:0
                                                       progress:nil
                                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                          if (!self) {
                                                              return;
                                                          }
                                                          
                                                          fr_strongify(self);
                                                          if (image) {
                                                               UIImage *resizedImage = [UIImage imageWithCGImage:image.CGImage scale:2 orientation:UIImageOrientationUp];
                                                              self.textAttachment.bounds = CGRectZero;
                                                              self.textAttachment.image = resizedImage;
                                                              [self.textView.layoutManager invalidateDisplayForCharacterRange:NSMakeRange(0, 1)];
                                                          }
                                                      }];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        NSAttributedString *attrStringWithImageTmp = [NSAttributedString attributedStringWithAttachment:self.textAttachment];
        NSMutableAttributedString *attrStringWithImage = [[NSMutableAttributedString alloc] initWithAttributedString:attrStringWithImageTmp];
        [attrStringWithImage addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, attrStringWithImage.length)];
        [attributeStr insertAttributedString:attrStringWithImage atIndex:0];
    }
    
    UIFont *font = [UIFont systemFontOfSize:17];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                forKey:NSFontAttributeName];
    NSAttributedString *textAttributedStr = [[NSAttributedString alloc] initWithString:text attributes:attrsDictionary];
    
    NSInteger index = 0;
    if (self.textAttachment) {
        //加一个空行
        NSAttributedString *wrap = [[NSAttributedString alloc] initWithString:@"\n"];
       [attributeStr insertAttributedString:wrap atIndex:1];
        index = 2;
    }
    
    [attributeStr insertAttributedString:textAttributedStr atIndex:index];
    self.textView.attributedText = attributeStr;
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
