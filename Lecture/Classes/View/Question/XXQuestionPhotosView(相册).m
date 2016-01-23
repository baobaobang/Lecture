//
//  XXQuestionPhotosView.m
//  Lecture
//
//  Created by 陈旭 on 16/1/22.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXQuestionPhotosView.h"
#import "XXQuestionPhoto.h"
#import "XXQuestionPhotoView.h"
#import "SDPhotoBrowser.h"

#define XXQuestionPhotoWH 70
#define XXQuestionPhotoMargin 10
#define XXQuestionPhotoMaxCol(count) ((count==4)?2:3)

@interface XXQuestionPhotosView () <SDPhotoBrowserDelegate>

@end
@implementation XXQuestionPhotosView

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    NSUInteger photosCount = photos.count;
    
    // 创建足够数量的图片控件
    // 这里的self.subviews.count不要单独赋值给其他变量
    while (self.subviews.count < photosCount) {
        XXQuestionPhotoView *photoView = [[XXQuestionPhotoView alloc] init];
        [self addSubview:photoView];
    }
    
    // 遍历所有的图片控件，设置图片
    for (int i = 0; i<self.subviews.count; i++) {
        XXQuestionPhotoView *photoView = self.subviews[i];
        
        if (i < photosCount) { // 显示
            photoView.photo = photos[i];
            photoView.hidden = NO;
        } else { // 隐藏
            photoView.hidden = YES;
        }

        // 图片可以点击
        photoView.userInteractionEnabled = YES;
        photoView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPhotoView:)];
        [photoView addGestureRecognizer:tap];
    }
}

/**
 *  点击小图打开图片浏览器
 */
- (void)tapPhotoView:(UITapGestureRecognizer *)tap
{
    UIView *imageView = tap.view;
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.currentImageIndex = imageView.tag;
    browser.sourceImagesContainerView = self;
    browser.imageCount = self.photos.count;
    browser.delegate = self;
    [browser show];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置图片的尺寸和位置
    NSUInteger photosCount = self.photos.count;
    int maxCol = XXQuestionPhotoMaxCol(photosCount);
    for (int i = 0; i<photosCount; i++) {
        XXQuestionPhotoView *photoView = self.subviews[i];
        
        int col = i % maxCol;
        photoView.x = col * (XXQuestionPhotoWH + XXQuestionPhotoMargin);
        
        int row = i / maxCol;
        photoView.y = row * (XXQuestionPhotoWH + XXQuestionPhotoMargin);
        photoView.width = XXQuestionPhotoWH;
        photoView.height = XXQuestionPhotoWH;
    }
}

+ (CGSize)sizeWithCount:(NSUInteger)count
{
    // 最大列数（一行最多有多少列）
    int maxCols = XXQuestionPhotoMaxCol(count);
    
    NSUInteger cols = (count >= maxCols)? maxCols : count;
    CGFloat photosW = cols * XXQuestionPhotoWH + (cols - 1) * XXQuestionPhotoMargin;
    
    // 行数
    NSUInteger rows = (count + maxCols - 1) / maxCols;
    CGFloat photosH = rows * XXQuestionPhotoWH + (rows - 1) * XXQuestionPhotoMargin;
    
    return CGSizeMake(photosW, photosH);
}

#pragma mark - SDPhotoBrowserDelegate

// 大图的url地址
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    XXQuestionPhoto *photo = self.photos[index];
    NSString *imageName = photo.highQuality_pic;
    NSURL *url = [NSURL URLWithString:imageName];
    return url;
}

// 小图作为占位图
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView *imageView = self.subviews[index];
    return imageView.image;
}
@end
