//
//  FRUtils.h
//  FReader
//
//  Created by itedliu@qq.com on 15/4/26.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRUtils : NSObject

+ (NSString *)feedContentPattern;
+ (NSRegularExpression *)feedContentRegularExpression;
+ (NSRegularExpression *)feedImageURLRegularExpression;
+ (NSString*)getTimeStr:(NSTimeInterval)timeStamp;
+ (UIImage *)scaleImage:(UIImage *)image withSize:(CGFloat)size;

@end
