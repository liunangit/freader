//
//  FRLayoutManager.m
//  FReader
//
//  Created by itedliu@qq.com on 15/5/1.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "FRLayoutManager.h"
#import "HTMLReader.h"
#import "FRImageNode.h"
#import "FRTextNode.h"
#import "HTMLTextNode.h"

@interface FRLayoutManager ()

@end

@implementation FRLayoutManager

+ (id)sharedInstance
{
    static FRLayoutManager *g_layoutManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(void) {
        g_layoutManager = [[FRLayoutManager alloc] init];
    });
    
    return g_layoutManager;
}

- (void)layoutAsync:(NSString *)content completion:(LayoutAsyncCompletion)completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        NSMutableArray *nodeList = [[NSMutableArray alloc] init];
        if (content.length > 0) {
            HTMLDocument *document = [HTMLDocument documentWithString:content];
            HTMLElement *firstElement = [document firstNodeMatchingSelector:@"img"];
            NSString *titleURL = nil;
            NSEnumerator *enumerator = [document treeEnumerator];
            HTMLNode *object = nil;
            
            while ((object = enumerator.nextObject) != nil) {
                if ([object isKindOfClass:[HTMLElement class]]) {
                    HTMLElement *element = (HTMLElement *)object;
                    if ([element.tagName isEqualToString:@"img"]) {
                        FRImageNode *imageNode = [self crateImageNode:element];
                        if (imageNode) {
                            [nodeList addObject:imageNode];
                            
                            if (!titleURL) {
                                if (firstElement == element) {
                                    titleURL = imageNode.url;
                                }
                            }
                        }
                    }
                }
                else if ([object isKindOfClass:[HTMLTextNode class]]){
                    HTMLTextNode *text = (HTMLTextNode *)object;
                    FRTextNode *textNode = [self createTextNode:text];
                    if (textNode) {
                        [nodeList addObject:textNode];
                    }
                }
            }
        }
        
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                    completion(nodeList);
            });
        }
    });
}

- (FRImageNode *)crateImageNode:(HTMLElement *)element
{
    NSDictionary *attributes = element.attributes;
    FRImageNode *imageNode = [[FRImageNode alloc] init];
    imageNode.url = attributes[@"src"];
    imageNode.width = [attributes[@"width"] integerValue];
    imageNode.height = [attributes[@"height"] integerValue];
    return imageNode;
}

- (FRTextNode *)createTextNode:(HTMLTextNode *)textNode
{
    FRTextNode *text = [[FRTextNode alloc] init];
    NSString *textStr = textNode.textContent;
    
    HTMLElement *parentElement = textNode.parentElement;
    text.link = parentElement.attributes[@"href"];

    if (text.link.length == 0) {
        textStr = [textStr stringByAppendingString:@"\n"];
    }
    text.text = textStr;
    return text;
}

+ (void)getFirstImageURLWithContent:(NSString *)content
                         completion:(PaserFirstImageCompletion)completion
{
    if (content.length == 0) {
        if (completion) {
            completion(nil);
        }
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        NSString *url = [self getFirstImageURLWithContent:content];
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                completion(url);
            });
        }
    });
}

+ (NSString *)getFirstImageURLWithContent:(NSString *)content
{
    if (content.length == 0) {
        return nil;
    }
    
    HTMLDocument *document = [HTMLDocument documentWithString:content];
    HTMLElement *firstElement = [document firstNodeMatchingSelector:@"img"];
    return firstElement.attributes[@"src"];
}

@end
