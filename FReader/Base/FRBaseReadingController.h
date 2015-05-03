//
//  FRBaseReadingController.h
//  FReader
//
//  Created by itedliu@qq.com on 15/5/1.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "FRBaseViewController.h"

@protocol FRBaseReadingProtocol <NSObject>

- (UIImage *)requestImage:(NSString *)imageURL;

@end

@interface FRBaseReadingController : FRBaseViewController

// FRNode
@property (nonatomic, strong) NSArray *contentNodeList;

@end
