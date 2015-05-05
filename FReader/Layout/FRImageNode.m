//
//  FRImageNode.m
//  FReader
//
//  Created by itedliu@qq.com on 15/5/1.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "FRImageNode.h"

@implementation FRImageNode

- (NSUInteger)length
{
    return 1;
}

- (NSAttributedString *)attributedString
{
    self.attachment = [[FRImageAttachment alloc] init];
    self.attachment.imageWidth = self.width;
    self.attachment.imageHeight = self.height;
   
    NSAttributedString *attributedStrTmp = [NSMutableAttributedString attributedStringWithAttachment:self.attachment];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithAttributedString:attributedStrTmp];
    [str addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, str.length)];
    return str;
}


@end
