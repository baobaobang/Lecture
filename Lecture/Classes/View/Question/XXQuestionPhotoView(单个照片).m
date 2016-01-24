//
//  XXQuestionPhotoView.m
//  Lecture
//
//  Created by 陈旭 on 16/1/22.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXQuestionPhotoView.h"
#import "XXQuestionPhoto.h"
#import <UIImageView+WebCache.h>

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
    
    // 先从本地加载，如果没有再从网络加载 //TODO: 这一部分为测试用，开始从服务器加载就删除
    self.image = [UIImage imageWithContentsOfFile:photo.thumbnail_pic];
    
    
    if (!self.image){
        // 本地没有再从网络加载
        [self sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (error) {
                NSLog(@"%@", error);
            }
        }];
    }
    
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
