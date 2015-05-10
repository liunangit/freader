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
+ (NSRegularExpression *)base64ImageRegularExpression;
+ (NSString*)getTimeStr:(NSTimeInterval)timeStamp;

//等比缩放，长边为size
+ (UIImage *)scaleImage:(UIImage *)image withSize:(CGFloat)size;

//裁剪缩放
+ (UIImage *)image:(UIImage *)image fitInSize:(CGSize)viewsize;

@end
