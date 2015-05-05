//
//  FRImageNode.h
//  FReader
//
//  Created by itedliu@qq.com on 15/5/1.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "FRNode.h"
#import "FRImageAttachment.h"

@interface FRImageNode : FRNode

@property (nonatomic, copy) NSString *url;
@property (nonatomic) NSInteger width;
@property (nonatomic) NSInteger height;
@property (nonatomic, strong) FRImageAttachment *attachment;

@end
