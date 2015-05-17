//
//  FRRSSCell.h
//  FReader
//
//  Created by itedliu@qq.com on 15/3/15.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FRRSSModel;

@interface FRRSSCell : UITableViewCell

@property (nonatomic, copy) NSString *feedURL;
@property (nonatomic, strong) FRRSSModel *infoModel;
@property (nonatomic) BOOL showAddBtn;

@end
