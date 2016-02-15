//
//  XXQuestionPhotoView.m
//  Lecture
//
//  Created by 陈旭 on 16/1/22.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXQuestionPhotoView.h"
#import "XXQuestionPhoto.h"
#import "UIImageView+WebCache.h"

@interface XXQuestionPhotoView ()
@property (nonatomic, weak) UIImageView *gifView;
@end
@implementation XXQuestionPhotoView


- (UIImageView *)gifView
{
    if (!_gifView) {
        UIImage *image = [UIImage imageNamed:@"timeline_image_gif"];
        UIImageView *gifView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:gifView];
        self.gifView = gifView;
    }
    return _gifView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 内容模式
        self.contentMode = UIViewContentModeScaleAspectFill;
        
        // 超出边框的内容都剪掉
        self.layer.masksToBounds = YES;
    }
    return self;
}

// 加载小图
- (void)setPhoto:(XXQuestionPhoto *)photo
{
    _photo = photo;
    
    // 从网络加载缩小图
    [self sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            XXLog(@"%@", error);
        }
    }];

    
    // 显示\隐藏gif控件
    // 判断是够以gif或者GIF结尾
    self.gifView.hidden = ![photo.thumbnail_pic.lowercaseString hasSuffix:@"gif"];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.gifView.x = self.width - self.gifView.width;
    self.gifView.y = self.height - self.gifView.height;
}

@end
