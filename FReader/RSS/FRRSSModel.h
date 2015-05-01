//
//  FRRSSModel.h
//  FReader
//
//  Created by itedliu@qq.com on 15/3/15.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "FRBaseModel.h"

@interface FRRSSModel : FRBaseModel

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray *feedModelList;

@end
