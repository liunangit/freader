//
//  FRNode.h
//  FReader
//
//  Created by itedliu@qq.com on 15/5/1.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRNode : NSObject

@property (nonatomic) NSRange characterRange;
@property (nonatomic, readonly) NSUInteger length;

- (NSAttributedString *)attributedString;

@end
