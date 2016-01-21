//
//  HMCollectionCell.m
//  08-无限滚动
//
//  Created by apple on 14-5-31.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "HMCollectionCell.h"
#import "HMMusic.h"

@interface HMCollectionCell()
@property (weak, nonatomic) UIImageView *imageView;
@end

@implementation HMCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        self.imageView = imageView;
    }
    return self;
}
- (void)setMusic:(HMMusic *)music
{
    _music = music;
    
    self.imageView.image = [UIImage imageNamed:music.icon];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
}

@end
