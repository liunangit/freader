//
//  FRImageAttachment.m
//  FReader
//
//  Created by 刘楠 on 15/5/5.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "FRImageAttachment.h"

@implementation FRImageAttachment

- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex
{
    CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width - 60;
    if (self.image) {
        self.imageWidth = self.image.size.width;
        self.imageHeight = self.image.size.height;
    }
    
    if (self.imageWidth > maxWidth) {
        CGFloat scale = maxWidth / self.imageWidth;
        return CGRectMake(0, 0, maxWidth, self.imageHeight * scale);
    }
    
    return CGRectMake(0, 0, self.imageWidth, self.imageHeight);
}

@end
