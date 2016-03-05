//
//  XXLectureDescriptionView.m
//  Lecture
//
//  Created by 陈旭 on 16/3/1.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXLectureDescriptionView.h"

@interface XXLectureDescriptionView ()
@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, weak) UIView *line;
@end

@implementation XXLectureDescriptionView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
        [self setupTextView];
        [self setupBottomLine];
    }
    return self;
}

- (void)setup{
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setupTextView{
    
    UITextView *textView = [[UITextView alloc] init];
    textView.font = XXQuestionCellReplyFont;
    textView.textColor = [UIColor blackColor];
    textView.editable = NO;
    self.textView = textView;
    [self addSubview:textView];
}

- (void)setupBottomLine{
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line];
    self.line = line;
}

- (void)layoutSubviews{
    
    _textView.x = 2 * XXQuestionCellBorderW + XXQuestionCellIconWH;
    _textView.y = 5;
    _textView.width = self.width - _textView.x - XXQuestionCellBorderW;
    _textView.height = self.height - 2 *_textView.y - 1;

    _line.frame = CGRectMake(0, self.height - 1, self.width, 1);
}

- (void)setContent:(NSString *)content{
    _content = content;
    _textView.text = content;
}

@end
