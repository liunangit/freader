//
//  FRLayoutManager.h
//  FReader
//
//  Created by itedliu@qq.com on 15/5/1.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LayoutAsyncCompletion)(NSArray *nodeList);

@interface FRLayoutManager : NSObject

- (void)layoutAsync:(NSString *)content completion:(LayoutAsyncCompletion)completion;

@end
