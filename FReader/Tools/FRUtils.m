//
//  FRUtils.m
//  FReader
//
//  Created by itedliu@qq.com on 15/4/26.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "FRUtils.h"
#import <time.h>
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

+ (NSString*)getTimeStr:(NSTimeInterval)timeStamp 
{
    if (timeStamp == 0)
    {
        return @"";
    }
    
    time_t pupdate = timeStamp;
    struct tm* pubDate = localtime((const time_t*)&pupdate);
    
    int yearOfPubDate = pubDate->tm_year + 1900;
    int monOfPubDate = pubDate->tm_mon + 1;
    int dayOfPubDate = pubDate->tm_mday;
    int hourOfPubDate = pubDate->tm_hour;
    int minOfPubDate = pubDate->tm_min;
    
    time_t now = time(0);
    
    struct tm* now_tm = localtime((const time_t*)&now);
    int yearOfToday = now_tm->tm_year + 1900;
    
    //转换成今天0点的时间戳
    now_tm->tm_hour = 0;
    now_tm->tm_min = 0;
    now_tm->tm_sec = 0;
    time_t today_timeStamp = timelocal(now_tm);
    long time_interval = today_timeStamp - pupdate;//相对今天0点的时间间隔
    
    if (time_interval > -60 * 60 * 24 && time_interval <= 0)
    {
        return [NSString stringWithFormat:@"今天%02d:%02d", hourOfPubDate, minOfPubDate];
    }
    else if (time_interval > 0 && time_interval <= 60 * 60 * 24)
    {
        return [NSString stringWithFormat:@"昨天%02d:%02d", hourOfPubDate, minOfPubDate];
    }
    else if (time_interval > 60 * 60 * 24 && time_interval <= 60 * 60 * 24 * 2)
    {
        return [NSString stringWithFormat:@"前天%02d:%02d", hourOfPubDate, minOfPubDate];
    }
    else if (yearOfToday == yearOfPubDate)
    {
        return [NSString stringWithFormat:@"%d月%d日%02d:%02d", monOfPubDate, dayOfPubDate, hourOfPubDate, minOfPubDate];
    }
    else
    {
        return [NSString stringWithFormat:@"%d年%d月%d日", yearOfPubDate, monOfPubDate, dayOfPubDate];
    }
}

+ (UIImage *)scaleImage:(UIImage *)image withSize:(CGFloat)size
{
    CGImageRef imgRef = image.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGFloat scaleRatio = 0;
    
    if (width <= size && height <= size)
        return image;
    
    if (width > size) {
        scaleRatio = size / width;
        width = size;
        height = height * scaleRatio;
    }
    
    if (height > size)
    {
        scaleRatio = size / height;
        height = size;
        width = width * scaleRatio;
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    UIImage *tmpImage = [[UIImage alloc] initWithCGImage:imgRef];
    
    [tmpImage drawInRect:CGRectMake(0, 0, width, height)];
    
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

@end
