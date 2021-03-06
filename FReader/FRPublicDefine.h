//
//  FRPublicDefine.h
//  FReader
//
//  Created by itedliu@qq.com on 15/3/15.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#ifndef FReader_FRPublicDefine_h
#define FReader_FRPublicDefine_h

#define kFRSubscriptionListWidth    280

#define IS_IOS7 (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1 && floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1)
#define IS_IOS8  ([[[UIDevice currentDevice] systemVersion] compare:@"8" options:NSNumericSearch] != NSOrderedAscending)
#define IS_IPHONE6PLUS ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && [[UIScreen mainScreen] nativeScale] == 3.0f)

#define fr_string_concat(A, B)  A ## B

#define fr_weakify(VAR) \
__weak __typeof__(VAR) fr_string_concat(VAR, _weak_) = (VAR)

#define fr_strongify(VAR) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__strong __typeof__(VAR) VAR = fr_string_concat(VAR, _weak_) \
_Pragma("clang diagnostic pop")

#endif
