//
//  FROPMLManager.h
//  FReader
//
//  Created by itedliu@qq.com on 15/7/12.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^OPMLParseCompletionBlock)(NSArray *rssModelList);

@interface FROPMLManager : NSObject

+ (instancetype)defaultManager;
+ (NSArray *)parseOPMLFile:(NSString *)opmlFilePath;
+ (NSArray *)parseOpMLFilesInFolder:(NSString *)folderPath;

@end
