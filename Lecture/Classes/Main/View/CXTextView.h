//
//  CXTextView.h
//  Lecture
//
//  Created by 陈旭 on 16/1/27.
//  Copyright © 2016年 陈旭. All rights reserved.
//

// 自适应文本的输入框，且有占位文字（继续CXTextView就行）
#import <UIKit/UIKit.h>

@interface CXTextView : UITextView
#pragma mark - 占位文字
/** 占位文字的内容 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字的颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;

#pragma mark - 自适应高度
/** 是否自适应内容调整高度，默认不自适应 */
@property (nonatomic, assign, getter=isAutoAdjust) BOOL autoAdjust;
/** 是否向上调整，默认为向下 */
@property (nonatomic, assign, getter=isAjustTop) BOOL adjustTop;
/** 自适应情况下，限制最大高度 */
@property (nonatomic, assign) CGFloat maxHeight;

@end
