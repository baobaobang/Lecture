//
//  XXConst.h
//  Lecture
//
//  Created by 陈旭 on 16/1/9.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXConst : NSObject
#pragma mark - 全局

/** 简称*/
#define XXKeyWindow [UIApplication sharedApplication].keyWindow// 主窗口
#define XXTopWindow [[UIApplication sharedApplication].windows lastObject]// 最顶层的window
#define WEAKSELF  typeof(self) __weak weakSelf=self;// 弱指针
#define XXNotificationCenter [NSNotificationCenter defaultCenter]// 通知中心
#define XXTestLog XXLog(@"%s", __func__)// 打印测试
#define XXScreenWidth [UIScreen mainScreen].bounds.size.width// 屏幕的高度
#define XXScreenHeight [UIScreen mainScreen].bounds.size.height// 屏幕的宽度

/** 颜色*/
#define XXColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]// RGB颜色
#define XXRandomColor XXColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))// 随机色
#define XXTestColor [UIColor redColor]// 测试颜色
#define XXColorTint XXColor(47, 180, 254)// 项目默认颜色（浅蓝色）
#define XXColorText [UIColor whiteColor]// 项目默认文字颜色
#define XXSelectedColor XXColor(175, 220, 250)// 项目默认选中状态颜色（浅浅蓝色）

/** frame*/
extern const CGFloat kXXStatusAndNavBarHeight;// 状态栏和导航栏的总高度
/** 字体*/
extern const CGFloat kXXTextFont;

#pragma mark - 首页

#pragma mark - 提问
/** 通知*/
extern NSString * const XXTextDidDeleteNotification;

#pragma mark - 讲座前
/** frame*/
extern const CGFloat kXXPlayerPicViewHeightWidthRatio;// PlayerPicView高宽比
extern const CGFloat kXXExpertHeaderViewHeight;// 专家简介头部的高度
extern const CGFloat kXXExpertTableViewHeight;// 专家简介的高度
extern const CGFloat kXXLectureDescriptioinViewHeight;
extern const CGFloat kXXQuestionHeaderViewHeight;//精选提问头部高度
extern const CGFloat kXXJoinButtonHeight;// 报名活动按钮的高度
extern const CGFloat kXXJoinLectureActionSheetHeight;
extern const CGFloat kXXQuestionVCTextViewOriginalHeight; // textview初始高度
extern const CGFloat kXXQuestionVCTextViewMaxHeight; // textview初始高度
extern const CGFloat kXXQuestionReplyCellHeight;

/** 字体*/
extern const CGFloat kXXJoinLectureActionSheetLabelFont;
extern const CGFloat kXXJoinLectureActionSheetDoneBtnFont;
/** 颜色*/
#define XXColorGreen XXColor(75, 217, 130)// 精选提问默认颜色（浅绿色）
#define XXQuestionSelectedColor XXColor(5, 128, 0)// 精选提问选中状态颜色（深绿色）

/** 时间*/
extern const CGFloat kXXHideAndShowPicViewDuration;//收起图片和专家简介的时间
extern const CGFloat kXXJoinLectureActionSheetDuration;
/** 其他*/
extern const CGFloat kXXJoinLectureActionSheetAlpha;
extern const NSUInteger kXXQuestionVCTextViewMaxWords;// 最大字数限制
/** Identifier*/
extern NSString * const XXQuestionCellReuseId;
extern NSString * const XXQuestionReplyCellReuseId;
extern NSString * const XXQuestionReplyUserCellReuseId;

#pragma mark - 讲座中
/** frame*/
extern const CGFloat kXXPlayerToolBarHeight; //播放条的高度
extern const CGFloat kXXOnlineHeaderViewHeight;//在线交流头部高度
/** Identifier*/
extern NSString * const XXPlayerPicViewCellIdentifier;//播放图片的cell
extern NSString * const XXSharedLectureIdKey;

/** 通知*/
extern NSString * const XXQuestionToolbarShareButtonClickNotification;
extern NSString * const XXQuestionToolbarUnlikeButtonClickNotification;
extern NSString * const XXLandscapeBtnDidClickNotification;
extern NSString * const XXStartPlayingNotification;
extern NSString * const XXStopPlayingNotification;

extern NSString * const XXLectureVCRefreshNotification;
extern NSString * const XXLectureExpertOnlyVCRefreshNotification;
extern NSString * const XXLectureSelectedQuestionsVCRefreshNotification;
extern NSString * const XXPlayerShareNotification;
extern NSString * const showShareView;
extern NSString * const XXShareSuccessNotification;
extern NSString * const XXShareFailNotification;
/** 时间*/

extern const CGFloat kXXPlayerVCChageToLandscapeDuration;

#pragma mark - 专家简介
#define XXExpertProfileCellContentViewBackgroundColor XXQuestionReplyBackgroundColor// 专家简介的背景颜色

#pragma mark - 问题
extern NSString * const XXReplyCellDidClickNotification;
extern NSString * const XXReplyCellPlayBtnDidClickNotification;
#define XXQuestionCellReplyFont [UIFont systemFontOfSize:14]// 回复字体
#define XXQuestionCellReplyTimeFont [UIFont systemFontOfSize:11]// 回复语音的时间字体
#define XXQuestionReplyBackgroundColor XXColor(240, 240, 242)// 回复的背景颜色// cell的边框宽度
#define XXQuestionCellBorderW 10
// cell头像的宽高
#define XXQuestionCellIconWH 44


// 只能收听几页，之后需要分享才能继续收听
#define XXSharePageNumber 2

@end
