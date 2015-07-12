//
//  FROPMLManager.m
//  FReader
//
//  Created by itedliu@qq.com on 15/7/12.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "FROPMLManager.h"
#import "XMLDictionary.h"

@implementation FROPMLManager

+ (instancetype)defaultManager
{
    static FROPMLManager *g_manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^ {
        g_manager = [[FROPMLManager alloc] init];
    });
    
    return g_manager;
}

+ (NSArray *)parseOPMLFile:(NSString *)opmlFilePath
{
    if (opmlFilePath.length == 0) {
        return nil;
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithXMLFile:opmlFilePath];
    NSDictionary *body = dic[@"body"];
    
    NSArray *outlines = body[@"outline"];
    NSMutableArray *urlList = [NSMutableArray array];
    
    for (NSDictionary *outlineDic in outlines) {
        
        if (outlineDic[@"_xmlUrl"]) {
            [urlList addObject:outlineDic[@"_xmlUrl"]];
            continue;
        }
        
        NSArray *innerList = outlineDic[@"outline"];
        for (NSDictionary *rssModel in innerList) {
            NSString *url = rssModel[@"_xmlUrl"];
            if (url) {
                [urlList addObject:url];
            }
        }
    }
    
    return urlList;
}

+ (NSArray *)parseOpMLFilesInFolder:(NSString *)folderPath
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *fileList = [fm contentsOfDirectoryAtPath:folderPath error:nil];
    NSMutableArray *urlList = [NSMutableArray array];
    
    for (NSString *fileName in fileList) {
        if (![fileName hasSuffix:@"opml"]) {
            continue;
        }
        
        NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
        NSArray *list = [self parseOPMLFile:filePath];
        [urlList addObjectsFromArray:list];
    }
    
    NSSet *set = [NSSet setWithArray:urlList];
    return [set allObjects];
    
}

@end
