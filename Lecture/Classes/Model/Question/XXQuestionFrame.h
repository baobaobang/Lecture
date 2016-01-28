//
//  XXQuestionFrame.h
//  Lecture
//
//  Created by 陈旭 on 16/1/22.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXQuestion.h"

// 昵称字体
#define XXQuestionCellNameFont [UIFont systemFontOfSize:15]
// 时间字体
#define XXQuestionCellTimeFont [UIFont systemFontOfSize:12]
// 来源字体
#define XXQuestionCellSourceFont XXQuestionCellTimeFont
// 正文字体
#define XXQuestionCellContentFont [UIFont systemFontOfSize:14]

// 被转发微博的正文字体
#define XXQuestionCellRetweetContentFont [UIFont systemFontOfSize:13]

// cell之间的间距
#define XXQuestionCellMargin 15

// cell的边框宽度
#define XXQuestionCellBorderW 10

@interface XXQuestionFrame : NSObject

@property (nonatomic, strong) XXQuestion *question;

/** 头像 */
@property (nonatomic, assign) CGRect iconViewF;
/** 昵称 */
@property (nonatomic, assign) CGRect nameLabelF;
/** 会员图标 */
@property (nonatomic, assign) CGRect vipViewF;
/** 正文 */
@property (nonatomic, assign) CGRect contentLabelF;
/** 配图 */
@property (nonatomic, assign) CGRect photosViewF;
/** 底部工具条 */
@property (nonatomic, assign) CGRect toolbarF;
/** 回复 */
@property (nonatomic, assign) CGRect replyF;

/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;


- (NSComparisonResult)compareAttitudesCount:(XXQuestionFrame *)other;


@end
