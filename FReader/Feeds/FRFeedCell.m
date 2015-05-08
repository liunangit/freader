//
//  FRFeedCell.m
//  FReader
//
//  Created by 刘楠 on 15/3/16.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "FRFeedCell.h"
#import "FRFeedModel.h"

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
    self.imageView.image = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
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
}

@end
