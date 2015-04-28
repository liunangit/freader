//
//  FRFeedModel.m
//  FReader
//
//  Created by itedliu@qq.com on 15/3/15.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "FRFeedModel.h"
#import "FRUtils.h"
#import "HTMLReader.h"

@implementation FRFeedModel

- (void)parse
{
    if (self.content.length == 0) {
        return;
    }
    
    HTMLDocument *document = [HTMLDocument documentWithString:self.content];
    HTMLElement *firstElement = [document firstNodeMatchingSelector:@"a"];
    if (firstElement) {
        self.imageURL = firstElement.attributes[@"href"];
    }
    
    self.textList = [document textContentList];
}

@end
