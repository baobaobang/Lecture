//
//  XXPlayerMaskView.m
//  Lecture
//
//  Created by 陈旭 on 16/1/20.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXPlayerMaskView.h"

// 页码字体
#define XXPlayerPageNumberFont [UIFont systemFontOfSize:15]

#define XXPlayerCornerMaigin 10
#define XXPlayerShareBtnWH 30

@interface XXPlayerMaskView ()

/** 转发讲座按钮 */
@property (weak, nonatomic) UIButton *shareLectureBtn;
@property (weak, nonatomic) UIButton *bigPlayBtn;
@property (weak, nonatomic) UIButton *previousBtn;
@property (weak, nonatomic) UIButton *nextBtn;


@end

@implementation XXPlayerMaskView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        // 设置自己的属性
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.6;
        
        // 初始化子控件
        UILabel *pageNumberLabel = [[UILabel alloc] init];
        pageNumberLabel.font = XXPlayerPageNumberFont;
        pageNumberLabel.textColor = [UIColor whiteColor];
        [self addSubview:pageNumberLabel];
        self.pageNumberLabel = pageNumberLabel;
        
        UIButton *shareLectureBtn = [[UIButton alloc] init];
        shareLectureBtn.tag = XXPlayerMaskViewButtonTypeShare;
        [shareLectureBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [shareLectureBtn setNBg:@"share_btn"];
        [self addSubview:shareLectureBtn];
        self.shareLectureBtn = shareLectureBtn;
        
        UIButton *bigPlayBtn = [[UIButton alloc] init];
        bigPlayBtn.tag = XXPlayerMaskViewButtonTypePlay;
        [bigPlayBtn setNBg:@"playbar_playbtn_nomal" hBg:@"playbar_playbtn_click"];
        [bigPlayBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bigPlayBtn];
        self.bigPlayBtn = bigPlayBtn;
        
        UIButton *previousBtn = [[UIButton alloc] init];
        previousBtn.tag = XXPlayerMaskViewButtonTypePrevious;
        [previousBtn setNBg:@"playbar_prebtn_nomal" hBg:@"playbar_prebtn_click"];
        [previousBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:previousBtn];
        self.previousBtn = previousBtn;
        
        UIButton *nextBtn = [[UIButton alloc] init];
        nextBtn.tag = XXPlayerMaskViewButtonTypeNext;
        [nextBtn setNBg:@"playbar_nextbtn_nomal" hBg:@"playbar_nextbtn_click"];
        [nextBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:nextBtn];
        self.nextBtn = nextBtn;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // pageNumberLabel
    CGFloat pageX = XXPlayerCornerMaigin;
    CGFloat pageY = XXPlayerCornerMaigin;
    CGSize pageSize = [self.pageNumberLabel.text sizeWithFont:XXPlayerPageNumberFont];
    self.pageNumberLabel.frame = CGRectMake(pageX, pageY, pageSize.width, pageSize.height);
    
    // shareLectureBtn
    CGFloat shareW = XXPlayerShareBtnWH;
    CGFloat shareH = shareW;
    CGFloat shareX = self.width - XXPlayerCornerMaigin - shareW;
    CGFloat shareY = pageY;
    self.shareLectureBtn.frame = CGRectMake(shareX, shareY, shareW, shareH);
    
    // bigPlayBtn
    self.bigPlayBtn.center = self.center;
    self.bigPlayBtn.width = self.bigPlayBtn.height = 60;
    
    // previousBtn
    CGFloat previousW = self.bigPlayBtn.width;
    CGFloat previousH = previousW;
    CGFloat previousX = self.bigPlayBtn.x - previousW;
    CGFloat previousY = self.bigPlayBtn.y;
    self.previousBtn.frame = CGRectMake(previousX, previousY, previousW, previousH);
    
    // nextBtn
    CGFloat nextW = self.bigPlayBtn.width;
    CGFloat nextH = nextW;
    CGFloat nextX = CGRectGetMaxX(self.bigPlayBtn.frame);
    CGFloat nextY = self.bigPlayBtn.y;
    self.nextBtn.frame = CGRectMake(nextX, nextY, nextW, nextH);
}

- (void)setCurrentItem:(NSInteger)currentItem{
    _currentItem = currentItem;
    
    // 设置页码标签
    self.pageNumberLabel.text =[NSString stringWithFormat:@"第%ld/%ld页", currentItem + 1, self.musics.count];
    [self.pageNumberLabel sizeToFit];
}

- (void)btnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(playerMaskView:didClickBtnType:)]) {
        [self.delegate playerMaskView:self didClickBtnType:btn.tag];
    }
}


@end
