//
//  FRWebViewController.h
//  FReader
//
//  Created by 刘楠 on 15/4/28.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRWebViewController : UIViewController

@property (nonatomic, copy) NSString *url;

- (void)startLoad;
- (void)stopLoad;

@end
