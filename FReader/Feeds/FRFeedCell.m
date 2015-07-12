//
//  FRFeedCell.m
//  FReader
//
//  Created by 刘楠 on 15/3/16.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "FRFeedCell.h"
#import "FRFeedModel.h"
#import "FRWebImageManager.h"
#import "FRPublicDefine.h"

@implementation FRFeedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.textLabel.text = nil;
    self.detailTextLabel.text = nil;
    self.feedModel = nil;
    self.imageView.image = nil;
}

- (void)setFeedModel:(FRFeedModel *)feedModel
{
    if (_feedModel == feedModel) {
        return;
    }
    
    _feedModel = feedModel;
    self.textLabel.text = self.feedModel.title;
    
    NSMutableString *detailText = [NSMutableString string];
    if (self.feedModel.author.length > 0) {
        [detailText appendString:self.feedModel.author];
    }
    
    if (self.feedModel.dataStr.length > 0) {
        if (detailText.length > 0) {
            [detailText appendString:@"/"];
        }
        [detailText appendString:self.feedModel.dataStr];
    }
    
    self.detailTextLabel.text = detailText;
    
    NSString *imageUrl = self.feedModel.thumbImageURL;
    if (imageUrl.length > 0) {
        fr_weakify(self);
        [[FRWebImageManager sharedInstance] requestImageFor:imageUrl
                                                       size:100
                                                 completion:^(UIImage *image, NSError *error, NSString *url) {
                                                     fr_strongify(self);
                                                     if (!self) {
                                                         return ;
                                                     }
                                                     if (image && [url isEqualToString:self.feedModel.thumbImageURL]) {
                                                         self.imageView.image = image;
                                                         [self setNeedsLayout];
                                                     }
                                                 }];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    static CGFloat offsetX = 73;
    CGRect frame = self.textLabel.frame;
    frame.origin.x = offsetX;
    self.textLabel.frame = frame;
    
    frame = self.detailTextLabel.frame;
    frame.origin.x = offsetX;
    self.detailTextLabel.frame = frame;
}

@end
