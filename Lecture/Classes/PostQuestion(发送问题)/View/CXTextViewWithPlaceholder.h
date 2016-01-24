//
//  CXTextViewWithPlaceholder.h
//  Lecture
//
//  Created by 陈旭 on 16/1/24.
//  Copyright © 2016年 陈旭. All rights reserved.
//
//  增强：带有占位文字
#import <UIKit/UIKit.h>

@interface CXTextViewWithPlaceholder : UITextView

/** 占位文字的内容 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字的颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;
@end
