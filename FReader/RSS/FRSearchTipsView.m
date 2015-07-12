//
//  FRSearchTipsView.m
//  FReader
//
//  Created by itedliu@qq.com on 15/7/11.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "FRSearchTipsView.h"

@implementation FRSearchTipsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        static CGFloat closeBtnWidth = 20;
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - closeBtnWidth, frame.size.height)];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_textLabel];
        
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - closeBtnWidth, 0, closeBtnWidth, frame.size.height)];
        _closeBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_closeBtn addTarget:self action:@selector(onCloseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_closeBtn setTitle:@"X" forState:UIControlStateNormal];
        _closeBtn.backgroundColor = [UIColor redColor];
        [self addSubview:_closeBtn];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTouchTextView:)];
        [self addGestureRecognizer:recognizer];
    }
    
    return self;
}

- (void)setText:(NSString *)text
{
    self.textLabel.text = text;
    [self.textLabel sizeToFit];
    CGRect frame = self.closeBtn.frame;
    frame.origin.x = self.textLabel.frame.size.width + 10;
    self.closeBtn.frame = frame;
}

- (NSString *)text
{
    return self.textLabel.text;
}

- (void)onCloseBtnClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(searchTipsViewDidClickCloseBtn:)]) {
        [self.delegate searchTipsViewDidClickCloseBtn:self];
    }
}

- (void)onTouchTextView:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(searchTipsViewDidTouched:)]) {
        [self.delegate searchTipsViewDidTouched:self];
    }
}

@end