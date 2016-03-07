//
//  UIView+Common.h
//  Lecture
//
//  Created by 陈旭 on 16/3/6.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Common)
+ (UIView *)maskView;// 蒙版
+ (UIView *)separationLine;// 分割线
- (void)setMaskColor;// 设置为蒙版颜色
- (void)setMaskColorWithAlpha:(CGFloat)alpha;
@end
