//
//  XXquestionToolbar.m
//  黑马微博2期
//
//  Created by apple on 14-10-16.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "XXQuestionToolbar.h"
#define XXQuestionToolbarShareTitle @"分享"
#define XXQuestionToolbarUnlikeTitle @"棒"

@interface XXQuestionToolbar()
/** 里面存放所有的按钮 */
@property (nonatomic, strong) NSMutableArray *btns;
/** 里面存放所有的分割线 */
@property (nonatomic, strong) NSMutableArray *dividers;
@end

@implementation XXQuestionToolbar

- (NSMutableArray *)btns
{
    if (!_btns) {
        self.btns = [NSMutableArray array];
    }
    return _btns;
}

- (NSMutableArray *)dividers
{
    if (!_dividers) {
        self.dividers = [NSMutableArray array];
    }
    return _dividers;
}

+ (instancetype)toolbar
{
    return [[self alloc] init];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_card_bottom_background"]];
//        self.backgroundColor = XXTestColor;
        
        // 添加按钮
        self.shareBtn = [self setupBtn:XXQuestionToolbarShareTitle icon:@"timeline_icon_share" type:XXQuestionToolbarButtonTypeShare];
        self.attitudeBtn = [self setupBtn:XXQuestionToolbarUnlikeTitle icon:@"timeline_icon_unlike" type:XXQuestionToolbarButtonTypeUnlike];
        
        // 添加分割线
        [self setupDivider];
        [self setupDivider];
    }
    return self;
}
/**
 * 添加分割线
 */
- (void)setupDivider
{
    UIImageView *divider = [[UIImageView alloc] init];
    divider.image = [UIImage imageNamed:@"timeline_card_bottom_line"];
    [self addSubview:divider];
    
    [self.dividers addObject:divider];
}

/**
 * 初始化一个按钮
 * @param title : 按钮文字
 * @param icon : 按钮图标
 */
- (UIButton *)setupBtn:(NSString *)title icon:(NSString *)icon type:(XXQuestionToolbarButtonType)type
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.adjustsImageWhenHighlighted = NO;
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = type;
    [self addSubview:btn];
    
    [self.btns addObject:btn];
    
    return btn;
}

//TODO:
/**
 *  按钮点击
 *
 *  @param btn 点击的按钮
 */
- (void)btnClick:(UIButton *)btn{
    XXQuestion *question = self.questionFrame.question;
    
    switch (btn.tag) {
        case XXQuestionToolbarButtonTypeShare:{ // 分享
            question.shares_count++;
            // 发出通知
            NSNotification *notiShare = [NSNotification notificationWithName:XXQuestionToolbarShareButtonClick object:nil userInfo:@{@"toolbar":self}];
            [XXNotificationCenter postNotification:notiShare];
            break;
        }
        case XXQuestionToolbarButtonTypeUnlike:{ // 点赞可以增加和减少数字

//            if ([question isCurrentUserLike]) { // 如果已经点赞过，就取消点赞
//                [question.digUsers removeObject:[XXUser currentUser]];
//            }else{
//                [question.digUsers addObject:[XXUser currentUser]];
//            }
            
            question.like = !question.like;
            // 点棒可以增加和减少数字
            if (question.like) {
                question.attitudes_count++;
            }else{
                question.attitudes_count--;
            }
            
            // 发出通知
            NSNotification *notiUnlike = [NSNotification notificationWithName:XXQuestionToolbarUnlikeButtonClick object:nil userInfo:@{@"toolbar":self}];
            [XXNotificationCenter postNotification:notiUnlike];
            break;
        }

            
        default:
            break;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置按钮的frame
    NSUInteger btnCount = self.btns.count;
    CGFloat btnW = self.width / btnCount;
    CGFloat btnH = self.height;
    for (int i = 0; i<btnCount; i++) {
        UIButton *btn = self.btns[i];
        btn.y = 0;
        btn.width = btnW;
        btn.x = i * btnW;
        btn.height = btnH;
    }
    
    // 设置分割线的frame
    NSUInteger dividerCount = self.dividers.count;
    for (int i = 0; i<dividerCount; i++) {
        UIImageView *divider = self.dividers[i];
        divider.width = 1;
        divider.height = btnH;
        divider.x = i * btnW;
        divider.y = 0;
    }
}

- (void)setQuestionFrame:(XXQuestionFrame *)questionFrame
{
    _questionFrame = questionFrame;
    XXQuestion *question = questionFrame.question;
    
    // 转发
    [self setupBtnCount:question.shares_count btn:self.shareBtn title:XXQuestionToolbarShareTitle];
    // 赞
    [self setupBtnCount:question.attitudes_count btn:self.attitudeBtn title:XXQuestionToolbarUnlikeTitle];
    //TODO:
    
    if (question.like) {
        [self.attitudeBtn setImage:[UIImage imageNamed:@"timeline_icon_like"] forState:UIControlStateNormal];
    }else{
        [self.attitudeBtn setImage:[UIImage imageNamed:@"timeline_icon_unlike"] forState:UIControlStateNormal];
    }
}

- (void)setupBtnCount:(int)count btn:(UIButton *)btn title:(NSString *)title
{
    if (count > 0) { // 数字不为0
        if (count < 10000) { // 不足10000：直接显示数字，比如786、7986
            title = [NSString stringWithFormat:@"%d", count];
        } else { // 达到10000：显示xx.x万，不要有.0的情况
            double wan = count / 10000.0;
            title = [NSString stringWithFormat:@"%.1f万", wan];
            // 将字符串里面的.0去掉
            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }
    }
    [btn setTitle:title forState:UIControlStateNormal];
}
@end
