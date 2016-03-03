//
//  UIView+Mask.m
//  Lecture
//
//  Created by 陈旭 on 16/3/3.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "UIView+Mask.h"

@implementation UIView (Mask)
+ (UIView *)maskView{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];
    view.frame = CGRectMake(0, 0, XXScreenWidth, XXScreenHeight);
    return view;
}
@end
