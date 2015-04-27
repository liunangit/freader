//
//  FRFeedModel.m
//  FReader
//
//  Created by itedliu@qq.com on 15/3/15.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "FRFeedModel.h"
#import "FRUtils.h"

@implementation FRFeedModel

- (void)parse
{
    if (self.content.length == 0) {
        return;
    }
    
    NSRegularExpression *expression = [FRUtils feedContentRegularExpression];
    NSArray* match = [expression matchesInString:self.content options:NSMatchingReportCompletion range:NSMakeRange(0, [self.content length])];
    
    NSTextCheckingResult *firstResult = match.firstObject;
    if (firstResult) {
        NSString *firstSubString = [self.content substringWithRange:firstResult.range];
        NSRegularExpression *imageExpression = [FRUtils feedImageURLRegularExpression];
        NSTextCheckingResult *imageURLResult = [imageExpression firstMatchInString:firstSubString options:NSMatchingReportCompletion range:NSMakeRange(0, firstSubString.length)];
        if (imageURLResult) {
            if (imageURLResult.numberOfRanges > 1) {
                NSRange urlRange = [imageURLResult rangeAtIndex:1];
                NSString *url = [firstSubString substringWithRange:urlRange];
                self.imageURL = url;
            }
        }
    }
    
    NSInteger i = 0;
    if (self.imageURL) {
        i += 1;
    }
    
    NSMutableArray *contentList = [[NSMutableArray alloc] initWithCapacity:match.count];
    for (; i < match.count; i++) {
        NSTextCheckingResult *result = match[i];
        if (result.numberOfRanges > 1) {
            NSRange textRange = [result rangeAtIndex:1];
            NSString *text = [self.content substringWithRange:textRange];
            if (text) {
                [contentList addObject:text];
            }
        }
    }
    
    self.textList = contentList;
}

@end
