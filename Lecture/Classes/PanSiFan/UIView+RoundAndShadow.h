//
//  UIView+RoundAndShadow.h
//  Upload
//
//  Created by mortal on 16/1/20.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (RoundAndShadow)

- (instancetype)roundCorner:(CGFloat)cornerRadius;

- (instancetype)shadow;

- (instancetype)shadowWithColor:(UIColor *)color size:(CGSize)size opacity:(CGFloat)opacity;

@end
