//
//  FRUtils.m
//  FReader
//
//  Created by honey.vi on 15/4/26.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "FRUtils.h"

@implementation FRUtils

+ (NSString *)feedContentPattern
{
    return @"<p>(.*?)</p>";
}

+ (NSString *)feedImageURLPattern
{
    return @"(\\b(https?):\\/\\/[-A-Z0-9+&@#\\/%?=~_|!:,.;]*[-A-Z0-9+&@#\\/%=~_|])";
}

+ (NSRegularExpression *)feedContentRegularExpression
{
    static dispatch_once_t onceToken;
    static NSRegularExpression *reg = nil;
    
    dispatch_once(&onceToken, ^(void) {
        NSError *error = nil;
        reg = [NSRegularExpression
               regularExpressionWithPattern:[self feedContentPattern]
               options:NSRegularExpressionCaseInsensitive
               error:&error];
        
        if (error) {
            NSLog(@"%@", error);
        }
    });
    return reg;
}

+ (NSRegularExpression *)feedImageURLRegularExpression
{
    static dispatch_once_t onceToken;
    static NSRegularExpression *reg = nil;
    
    dispatch_once(&onceToken, ^(void) {
        NSError *error = nil;
        reg = [NSRegularExpression
               regularExpressionWithPattern:[self feedImageURLPattern]
               options:NSRegularExpressionCaseInsensitive
               error:&error];
        
        if (error) {
            NSLog(@"%@", error);
        }
    });
    return reg;
}

@end
