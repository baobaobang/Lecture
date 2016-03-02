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
 *  不渲染图片
 */
- (UIImage *)imageRenderingModeAlwaysOriginal;


/**
 *  渲染图片颜色
 */
- (UIImage *) imageWithTintColor:(UIColor *)tintColor;

/**
 *  缩放图片尺寸
 *
 *  @param image 原图片
 *  @param size  目标尺寸
 *
 *  @return 缩放后的图片
 */
- (UIImage *)imageScaleToSize:(CGSize)size;

//压缩图片质量
- (UIImage *)reduceImageToTargetPercent:(float)percent ;

//等比例压缩，限制最大宽高
- (UIImage *)imageCompressToTargetSize:(CGSize)size;

//等比例压缩，限制最大宽度
- (UIImage *)imageCompressToTargetWidth:(CGFloat)defineWidth;

//将图片等比例压缩到指定的最大宽高和最大kb数
- (UIImage *)imageCompressToWidth:(CGFloat)defineWidth kb:(NSUInteger)kb;
@end
