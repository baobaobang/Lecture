//
//  UIView+Common.m
//  Lecture
//
//  Created by 陈旭 on 16/3/6.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "UIView+Common.h"

@implementation UIView (Common)
+ (UIView *)maskView{
    UIView *view = [[UIView alloc] init];
    [view setMaskColor];
    return view;
}

+ (UIView *)separationLine{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    return view;
}

- (void)setMaskColor{
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.3;
}

- (void)setMaskColorWithAlpha:(CGFloat)alpha{
    self.backgroundColor = [UIColor blackColor];
    self.alpha = alpha;
}


@end
