//
//  FRUtils.h
//  FReader
//
//  Created by honey.vi on 15/4/26.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRUtils : NSObject

+ (NSString *)feedContentPattern;
+ (NSRegularExpression *)feedContentRegularExpression;
+ (NSRegularExpression *)feedImageURLRegularExpression;

@end
