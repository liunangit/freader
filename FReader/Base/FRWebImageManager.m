//
//  FRWebImageManager.m
//  FReader
//
//  Created by 刘楠 on 15/5/8.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "FRWebImageManager.h"
#import "SDWebImageManager.h"
#import "FRUtils.h"

@interface FRWebImageManager ()

@property (nonatomic, strong) SDImageCache *imageCache;

@end

@implementation FRWebImageManager

+ (id)sharedInstance
{
    static FRWebImageManager *g_imageManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(void) {
        g_imageManager = [[FRWebImageManager alloc] init];
    });
    
    return g_imageManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        _imageCache = [[SDImageCache alloc] initWithNamespace:@"FRWebImageManager"];
    }
    return self;
}

- (void)requestImageFor:(NSString *)url completion:(FRWebImageCompletionBlock)completion
{
    if (url.length == 0) {
        return;
    }
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:url]
                                                    options:0
                                                   progress:nil
                                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                      
                                                      if (completion) {
                                                          completion(image, error, [imageURL absoluteString]);
                                                      }
                                                  }];
}

- (void)requestImageFor:(NSString *)url size:(NSInteger)size completion:(FRWebImageCompletionBlock)completion
{
    if (url.length == 0) {
        return;
    }
    
    
    NSString *composedUrl = [self composeUrl:url withSize:size];
    
    UIImage *image = [_imageCache imageFromMemoryCacheForKey:composedUrl];
    if (image) {
        if (completion) {
            completion(image, nil, url);
        }
        return;
    }
    
    [_imageCache queryDiskCacheForKey:composedUrl done:^(UIImage *image, SDImageCacheType type)
     {
         if (image) {
             if (completion) {
                 completion(image, nil, composedUrl);
             }
             return;
         }
         [self requestImageFor:url
                    completion:^(UIImage *image, NSError *error, NSString *url) {
                        UIImage *scaledImage = nil;
                        if (image) {
                            scaledImage = [FRUtils scaleImage:image withSize:size];
                            [_imageCache storeImage:scaledImage forKey:composedUrl];
                        }
                        if (completion) {
                            completion(scaledImage, error,url);
                        }
                        return;
                    }];
     }];
}

- (NSString *)composeUrl:(NSString *)url withSize:(NSInteger)size
{
    if (size <= 0) {
        return url;
    }
    
    if (url.length == 0) {
        return url;
    }
    
    return [url stringByAppendingFormat:@"-%zd", size];
}

@end
