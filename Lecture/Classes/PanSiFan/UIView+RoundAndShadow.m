//
//  UIView+RoundAndShadow.m
//  Upload
//
//  Created by mortal on 16/1/20.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#import "UIView+RoundAndShadow.h"

@implementation UIView (RoundAndShadow)

- (instancetype)roundCorner:(CGFloat)cornerRadius{
    self.layer.cornerRadius = cornerRadius;
    self.clipsToBounds = YES;
    return  self;
}

- (instancetype)shadow{
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0.5);
    self.layer.shadowOpacity = 1;
    return self;
}
- (instancetype)shadowWithColor:(UIColor *)color size:(CGSize)size opacity:(CGFloat)opacity{
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = size;
    self.layer.shadowOpacity = opacity;
    return self;
}
@end
