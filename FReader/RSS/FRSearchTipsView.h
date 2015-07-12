//
//  FRSearchTipsView.h
//  FReader
//
//  Created by itedliu@qq.com on 15/7/11.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FRSearchTipsViewDelegate;

@interface FRSearchTipsView : UIView

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, weak) id<FRSearchTipsViewDelegate> delegate;

- (void)setText:(NSString *)text;
- (NSString *)text;

@end

@protocol FRSearchTipsViewDelegate <NSObject>

@optional
- (void)searchTipsViewDidClickCloseBtn:(FRSearchTipsView *)tipsView;
- (void)searchTipsViewDidTouched:(FRSearchTipsView *)tipsView;

@end
