//
//  XXQuestionPhoto.h
//  Lecture
//
//  Created by 陈旭 on 16/1/22.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXQuestionPhoto : NSObject

// 使用SDPhotoBrowser(图片浏览器)，需要注意缩略图和大图的宽高比要相同，否则在点击放大之后，大图的高度会突变

/** 缩略图地址 */
@property (nonatomic, copy) NSString *thumbnail_pic;
/** 大图地址 */
@property (nonatomic, copy) NSString *highQuality_pic;

@end
