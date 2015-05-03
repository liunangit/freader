//
//  FRBaseReadingController.m
//  FReader
//
//  Created by itedliu@qq.com on 15/5/1.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "FRBaseReadingController.h"
#import "FRTextNode.h"
#import "FRImageNode.h"
#import "FRPublicDefine.h"
#import "SDWebImageManager.h"

@interface FRBaseReadingController ()

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSAttributedString *contents;

@end

@implementation FRBaseReadingController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.textView.editable = NO;
    self.textView.textContainerInset = UIEdgeInsetsMake(10, 15, 20, 15);
    [self.view addSubview:self.textView];
    self.textView.attributedText = self.contents;
}

- (void)setContentNodeList:(NSArray *)contentNodeList
{
    if (_contentNodeList == contentNodeList) {
        return;
    }
    
    _contentNodeList = contentNodeList;
    self.contents = [self showContents];
    self.textView.attributedText = self.contents;
}

- (NSAttributedString *)showContents
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    NSUInteger offset = 0;
    for (FRNode *node in self.contentNodeList) {
        [attributedString appendAttributedString:node.attributedString];
        NSUInteger nodeLength = node.length;
        node.characterRange = NSMakeRange(offset, nodeLength);
        offset += nodeLength;
        
        if ([node isKindOfClass:[FRImageNode class]]) {
            [self showImageNode:(FRImageNode *)node];
        }
    }
    
    return attributedString;
}

- (void)showImageNode:(FRImageNode *)imageNode
{
    NSURL *imageURL = [NSURL URLWithString:imageNode.url];
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
                                                          imageNode.attachment.bounds = CGRectZero;
                                                          imageNode.attachment.image = resizedImage;
                                                          [self.textView.layoutManager invalidateDisplayForCharacterRange:imageNode.characterRange];
                                                      }
                                                  }];
}

@end
