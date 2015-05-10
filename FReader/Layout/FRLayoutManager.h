//
//  FRLayoutManager.h
//  FReader
//
//  Created by itedliu@qq.com on 15/5/1.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LayoutAsyncCompletion)(NSArray *nodeList);
typedef void(^PaserFirstImageCompletion)(NSString *firstImageUrl);

@interface FRLayoutManager : NSObject

+ (id)sharedInstance;
- (void)layoutAsync:(NSString *)content completion:(LayoutAsyncCompletion)completion;

+ (void)getFirstImageURLWithContent:(NSString *)content completion:(PaserFirstImageCompletion)completion;
+ (NSString *)getFirstImageURLWithContent:(NSString *)content;

@end
