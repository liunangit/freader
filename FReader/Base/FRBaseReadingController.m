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
#import "FRWebImageManager.h"

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
    fr_weakify(self);
    [[FRWebImageManager sharedInstance] requestImageFor:imageNode.url
                                            completion:^(UIImage *image, NSError *error, NSString *url) {
                                                fr_strongify(self);
                                                if (!self) {
                                                    return;
                                                }
                                                
                                                if (image) {
                                                    UIImage *resizedImage = [UIImage imageWithCGImage:image.CGImage scale:2 orientation:UIImageOrientationUp];
                                                    imageNode.attachment.bounds = CGRectZero;
                                                    imageNode.attachment.image = resizedImage;
                                                    [self.textView.layoutManager invalidateDisplayForCharacterRange:imageNode.characterRange];
                                                    
                                                    //不知道宽高的图片，下载完成后需要刷一下。
                                                    //但是这里setNeedsLayout不起作用，所以重设置了一下内容
                                                    //不知道是否有更好的办法？
                                                    if (imageNode.height == 0) {
                                                        NSAttributedString *s = self.textView.attributedText;
                                                        self.textView.attributedText = nil;
                                                        self.textView.attributedText = s;
                                                    }
                                                }
                                            }];
    
}

@end
