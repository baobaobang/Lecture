//
//  CXTextView.m
//  Lecture
//
//  Created by 陈旭 on 16/1/27.
//  Copyright © 2016年 陈旭. All rights reserved.
//

// 自适应文本的输入框
#import "CXTextView.h"

@implementation CXTextView

// 代码创建的情况
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 通知
        // 当UITextView的文字发生改变时，UITextView自己会发出一个UITextViewTextDidChangeNotification通知
        [XXNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}


// xib或者sb创建的情况
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        // 通知
        // 当UITextView的文字发生改变时，UITextView自己会发出一个UITextViewTextDidChangeNotification通知
        [XXNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

/**
 * 监听文字改变
 */
- (void)textDidChange
{
    // 重绘（重新调用）
    [self setNeedsDisplay];
    
    if (!self.autoAdjust) return; // 下面为自适应的情况
    
    // 自适应
    
    if (self.height != self.contentSize.height) { // 如果高度改变

        if (self.isAjustTop) {
            self.y -= self.contentSize.height - self.height;
        }
        self.height = self.contentSize.height;
    }
}

- (void)drawRect:(CGRect)rect
{
    // 如果有输入文字，就直接返回，不画占位文字
    if (self.hasText) return;
    
    // 文字属性(有用户自定义的就用用户自定义的，没有就用系统默认的)
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    attrs[NSForegroundColorAttributeName] = self.placeholderColor?self.placeholderColor:[UIColor grayColor];
    // 画文字
    //    [self.placeholder drawAtPoint:CGPointMake(5, 8) withAttributes:attrs];
    CGFloat x = 5;
    CGFloat w = rect.size.width - 2 * x;
    CGFloat y = 8;
    CGFloat h = rect.size.height - 2 * y;
    CGRect placeholderRect = CGRectMake(x, y, w, h);
    [self.placeholder drawInRect:placeholderRect withAttributes:attrs];
}


- (void)dealloc
{
    [XXNotificationCenter removeObserver:self];
}



#pragma mark - 改变下列属性都会重绘占位文字
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    // setNeedsDisplay会在下一个消息循环时刻，调用drawRect:
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    [self setNeedsDisplay];
}



@end
