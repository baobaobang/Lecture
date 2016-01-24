//
//  UIImage+CX.h
//  Lecture
//
//  Created by 陈旭 on 16/1/11.
//  Copyright © 2016年 陈旭. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIImage (CX)

/**
 *  将图片保存到本地沙盒中，返回保存的路径，文件为当前时间加编号
 */
- (NSString *)saveInSandBoxWithIndex:(NSInteger)index;

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
- (UIImage *)imageScaleToSize:(CGSize)size;

/**
 *  不渲染图片
 */
- (UIImage *)imageRenderingModeAlwaysOriginal;

@end
