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
        
    }
}

@end
