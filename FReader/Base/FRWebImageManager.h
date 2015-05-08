//
//  FRWebImageManager.h
//  FReader
//
//  Created by 刘楠 on 15/5/8.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FRWebImageCompletionBlock)(UIImage *image, NSError *error, NSString *imageURL);

@interface FRWebImageManager : NSObject

+ (id)sharedInstance;
- (void)requestImageFor:(NSString *)url completion:(FRWebImageCompletionBlock)completion;
- (void)requestImageFor:(NSString *)url size:(NSInteger)size completion:(FRWebImageCompletionBlock)completion;

@end
