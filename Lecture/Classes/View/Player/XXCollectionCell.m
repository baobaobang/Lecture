//
//  XXCollectionCell.m
//  08-无限滚动
//
//  Created by apple on 14-5-31.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "XXCollectionCell.h"

@interface XXCollectionCell()
@property (weak, nonatomic) UIImageView *imageView;
@end

@implementation XXCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"placeholder_lecture_cover"]; // 占位图
        [self addSubview:imageView];
        self.imageView = imageView;
    }
    return self;
}

- (void)setPage:(XXXLecturePageModel *)page
{
    _page = page;

    if (page) { // 没有page的时候不下载
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:page.picture] placeholderImage:[UIImage imageNamed:@"placeholder_lecture_cover"]];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
}

@end
