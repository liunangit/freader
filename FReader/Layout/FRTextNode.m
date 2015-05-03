//
//  FRTextNode.m
//  FReader
//
//  Created by itedliu@qq.com on 15/5/1.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "FRTextNode.h"

@implementation FRTextNode

- (NSUInteger)length
{
    return self.text.length;
}

- (NSAttributedString *)attributedString
{
    UIFont *font = [UIFont systemFontOfSize:17];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                forKey:NSFontAttributeName];
    NSAttributedString *textAttributedStr = [[NSAttributedString alloc] initWithString:self.text attributes:attrsDictionary];
    return textAttributedStr;
}

@end
