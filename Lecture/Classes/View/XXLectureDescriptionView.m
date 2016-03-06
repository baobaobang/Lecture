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
@property (nonatomic, weak) UIView *headerLine;
@property (nonatomic, weak) UIView *bottomLine;
@end

@implementation XXLectureDescriptionView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
        [self setupHeaderLine];
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

- (void)setupHeaderLine{
    UIView *line = [UIView separationLine];
    [self addSubview:line];
    self.headerLine = line;
}

- (void)setupBottomLine{
    UIView *line = [UIView separationLine];
    [self addSubview:line];
    self.bottomLine = line;
}

- (void)layoutSubviews{
    _headerLine.frame = CGRectMake(0, 0, self.width, 1);
    
    _textView.x = 2 * XXQuestionCellBorderW + XXQuestionCellIconWH;
    _textView.y = 5;
    _textView.width = self.width - _textView.x - XXQuestionCellBorderW;
    _textView.height = self.height - 2 *_textView.y;

    _bottomLine.frame = CGRectMake(0, self.height - 1, self.width, 1);
}

- (void)setContent:(NSString *)content{
    _content = content;
    _textView.text = content;
}

@end
