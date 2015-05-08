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
