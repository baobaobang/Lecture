//
//  UIImage+CZ.h
//  QQZone-HD
//
//  Created by Vincent_Guo on 14-6-16.
//  Copyright (c) 2014年 vgios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CZ)


/**
 *颜色值转换成图片
 */
+ (UIImage*) createImageWithColor: (UIColor*) color;

/**
 *  返回一张自由拉伸的图片
 */
+ (UIImage *)resizedImageWithName:(NSString *)name;

/**
 *  返回拉伸的图片
 */
+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;

/**
 *  返回圆形图片
 */
+ (instancetype)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

+ (instancetype)circleImageWithImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

+ (UIImage *)imageFromMainBundleWithName:(NSString *)name;

/**
 *  缩放图片大小
 *
 *  @param image 原图片
 *  @param size  目标尺寸
 *
 *  @return 缩放后的图片
 */
+ (UIImage *)originImage:(UIImage*)image scaleToSize:(CGSize)size;
@end
