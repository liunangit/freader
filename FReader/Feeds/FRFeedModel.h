//
//  FRFeedModel.h
//  FReader
//
//  Created by itedliu@qq.com on 15/3/15.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "FRBaseModel.h"

@interface FRFeedModel : FRBaseModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) NSString *dataStr;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *contentURL;
@property (nonatomic, copy) NSString *content;
@property (nonatomic) NSString *thumbImageURL;

@end
